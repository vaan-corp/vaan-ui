//
//  SwiftUIView.swift
//  
//
//  Created by Imthathullah on 01/03/23.
//

import SwiftUI
import WebKit

#if canImport(UIKit)
@available(iOS 16.0, *)
public struct InAppLink: View {
  let url: URL
  let title: String
  let accentColor: Color

  public init(url: URL, title: String, accentColor: Color) {
    self.url = url
    self.title = title
    self.accentColor = accentColor
  }

  @State var showWebPage = false

  public var body: some View {
    Button(title) {
      showWebPage = true
    }
    .buttonStyle(InfoButtonStyle())
    .sheet(isPresented: $showWebPage) {
      WebPage(url: url, title: title)
        .accentColor(accentColor)
    }
  }
}

@available(iOS 16.0, *)
public struct WebPage: View {
  let url: URL
  let title: String

  @Environment(\.dismiss) var dismiss

  public var body: some View {
    NavigationStack {
      WebView(url: url)
        .navigationTitle(Text(title))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
          ToolbarItem(placement: .navigationBarTrailing) {
            Button("Close") {
              dismiss()
            }
          }
        }
    }
  }
}

private struct WebView: UIViewRepresentable {
  var url: URL

  func makeUIView(context: Context) -> WKWebView {
    return WKWebView()
  }

  func updateUIView(_ webView: WKWebView, context: Context) {
    let request = URLRequest(url: url)
    webView.load(request)
  }
}

@available(iOS 16.0, *)
struct SwiftUIView_Previews: PreviewProvider {
  static var previews: some View {
    InAppLink(url: URL(string: "vaancorp.com")!, title: "Home", accentColor: .red)
  }
}
#endif
