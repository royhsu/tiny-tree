//
//  AtomView.swift
//
//
//  Created by Roy Hsu on 2020/4/25.
//

import SwiftUI
import TinyTreeCore

struct AtomView: View {
  var value: Atom
  var body: some View {
    content()
  }
}

extension AtomView {
  private func content() -> some View {
    switch value {
    case let .bool(bool):
      let text = "\(bool)"
      return Text(text)
    case let .integer(integer):
      return Text("\(integer)")
    case let .double(double):
      return Text("\(double)")
    case let .string(string):
      return Text(string)
    case let .date(date):
      return Text("\(date)")
    }
  }
}
