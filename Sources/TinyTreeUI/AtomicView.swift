//
//  AtomicView.swift
//
//
//  Created by Roy Hsu on 2020/4/25.
//

import SwiftUI
import TinyTreeCore

struct AtomicView: View {
  var value: Atomic
  var body: some View {
    content()
  }
}

extension AtomicView {
  private func content() -> some View {
    switch value {
    case let .bool(bool):
      let text = "\(bool)"
      return Text(text)
    case let .integer(integer):
      return Text("\(integer)")
    case let .string(string):
      return Text(string)
    }
  }
}
