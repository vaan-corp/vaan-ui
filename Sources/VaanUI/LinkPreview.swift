//
// Created by Imthathullah on 14/02/23.
//

import Foundation
import LinkPresentation
import SwiftUI
import VaanKit

public enum LinkPreview {
  public struct Info {
    let title: String
    var image: ImageRepresentable?
  }
}

public extension LinkPreview {
  actor Service {
    private var cache = InMemoryCache<URL, Info>(totalCostLimit: 100 * 1024 * 1024)

    private init() {}

    public static let shared: Service = .init()

    public func fetchLinkInfo(for url: URL) async throws -> Info {
      if let value = cachedLinkInfo(for: url) {
        return value
      }
      do {
        var info: Info = try await fetchLinkInfoFromInternet(for: url)
        if info.image == nil {
          try info.image = await fetchMetadataForHost(url: url)?.image
        }
        setCache(info: info, for: url)
        return info
      } catch let error {
        log("Failed to load link preview")
        if let info: Info = try await fetchMetadataForHost(url: url) {
          setCache(info: info, for: url)
          return info
        }
        throw error
      }
    }
  }
}

private extension LinkPreview.Service {
  func fetchLinkInfoFromInternet(for url: URL) async throws -> LinkPreview.Info {
    let emailError = CommonError("Can not fetch link info for email address")
    if url.scheme == "mailto" {
      throw emailError
    }
    var urlWithScheme: URL {
      get throws {
        if url.scheme == nil {
          if Email.isValid(url.absoluteString) {
            throw emailError
          }
          return URL(string: "https://" + url.absoluteString) ?? url
        }
        return url
      }
    }
    let metadata: LPLinkMetadata = try await fetchMetadata(for: urlWithScheme)
    guard let title = metadata.title else {
      throw CommonError("No title found for URL \(url.absoluteString)")
    }
    guard let imageProvider = metadata.imageProvider else {
      return LinkPreview.Info(title: title, image: nil)
    }
    do {
      let image = try await imageProvider.loadImage(forTypeIdentifier: "public.png")
      return LinkPreview.Info(title: title, image: image)
    } catch {
      log("Preview image not found")
      return LinkPreview.Info(title: title, image: nil)
    }
  }

  func fetchMetadataForHost(url: URL) async throws -> LinkPreview.Info? {
    guard url.scheme != "mailto",
          let host: String = url.host,
          host != url.absoluteString,
          let hostURL: URL = URL(string: host) else {
      return nil
    }
    var newURL: URL {
      if hostURL.absoluteString.contains("slack.com"),
         let slackHost: URL = URL(string: "slack.com") {
        return slackHost
      }
      return hostURL
    }
    let result: LinkPreview.Info = try await fetchLinkInfo(for: newURL)
    setCache(info: result, for: url)
    return result
  }

  func setCache(info: LinkPreview.Info, for url: URL) {
    cache.setValue(info, forKey: url)
  }

  func cachedLinkInfo(for url: URL) -> LinkPreview.Info? {
    cache.value(forKey: url)
  }

//  @MainActor // WKWebView sometimes throws an exception unless we start fetching on the main queue.
  func fetchMetadata(for url: URL) async throws -> LPLinkMetadata {
    // LPMetadataProvider is a one-shot object
    try await LPMetadataProvider().startFetchingMetadata(for: url)
  }
}

// MARK: - NSItemProvider
private extension NSItemProvider {
  func loadImage(forTypeIdentifier typeIdentifier: String) async throws -> ImageRepresentable {
    try await withCheckedThrowingContinuation { continuation in
      loadDataRepresentation(forTypeIdentifier: typeIdentifier) { data, error in
        if let error = error {
          continuation.resume(throwing: error)
          return
        }
        guard let data: Data = data, let image: ImageRepresentable = data.imageRepresentation else {
          continuation.resume(throwing: CommonError("Image data not found or invalid"))
          return
        }
        continuation.resume(returning: image)
      }
    }
  }
}
