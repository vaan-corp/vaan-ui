//
//  SwiftUIView.swift
//  
//
//  Created by Imthathullah on 25/01/23.
//

import SwiftUI

/// SwiftUI Button which can perform async tasks and can show loader, disable it self while the task is being peformed.
public struct AsyncButton<Content: View>: View {
  var action: () async -> Void
  var actionOptions = Set(ActionOption.allCases)
  @ViewBuilder var label: () -> Content

  public init(
    action: @escaping () async -> Void,
    actionOptions: Set<ActionOption> = Set(ActionOption.allCases),
    label: @escaping () -> Content
  ) {
    self.action = action
    self.actionOptions = actionOptions
    self.label = label
  }

  @State private var isDisabled = false
  @State private var showProgressView = false

  public var body: some View {
    Button(
      action: {
        if actionOptions.contains(.disableButton) {
          isDisabled = true
        }

        Task {
          var progressViewTask: Task<Void, Error>?

          if actionOptions.contains(.showProgressView) {
            progressViewTask = Task {
              try await Task.sleep(nanoseconds: 150_000_000)
              showProgressView = true
            }
          }

          await action()
          progressViewTask?.cancel()

          isDisabled = false
          showProgressView = false
        }
      },
      label: {
        ZStack {
          label().opacity(showProgressView ? 0 : 1)

          if showProgressView {
            ProgressView()
          }
        }
      }
    )
    .disabled(isDisabled)
  }
}

public extension AsyncButton {
  enum ActionOption: CaseIterable {
    case disableButton
    case showProgressView
  }
}

public extension AsyncButton where Content == Text {
  init(_ label: String,
       actionOptions: Set<ActionOption> = Set(ActionOption.allCases),
       action: @escaping () async -> Void) {
    self.init(action: action) {
      Text(label)
    }
  }
}

public extension AsyncButton where Content == Image {
  init(systemImageName: String,
       actionOptions: Set<ActionOption> = Set(ActionOption.allCases),
       action: @escaping () async -> Void) {
    self.init(action: action) {
      Image(systemName: systemImageName)
    }
  }
}

public extension AsyncButton where Content == Label<Text, Image> {
  init(label: Label<Text, Image>,
       actionOptions: Set<ActionOption> = Set(ActionOption.allCases),
       action: @escaping () async -> Void) {
    self.init(action: action) {
      label
    }
  }
}
