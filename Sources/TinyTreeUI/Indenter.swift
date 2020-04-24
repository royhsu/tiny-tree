//
//  Indenter.swift
//
//
//  Created by Roy Hsu on 2020/4/17.
//

import SwiftUI

struct Indenter<Blank, Cursor>: View where Blank: View, Cursor: View {
  var count: Int
  private let blank: () -> Blank
  private let cursor: () -> Cursor
  
  var body: some View {
    content()
  }
  
  init(
    count: Int,
    blank: @escaping () -> Blank,
    cursor: @escaping () -> Cursor
  ) {
    self.count = count
    self.blank = blank
    self.cursor = cursor
  }
}

extension Indenter{
  private func content() -> some View {
    if count < 1 {
      return AnyView(EmptyView())
    } else if count == 1 {
      return AnyView(cursor())
    } else { // > 1
      return AnyView(
        Group {
          ForEach(0..<count - 1) { _ in
            self.blank()
          }
          cursor()
        }
      )
    }
  }
}

// MARK: - Previews

struct Indenter_Previews: PreviewProvider {
  static var blank: some View {
    Rectangle()
      .fill(Color.red)
      .frame(width: 8.0)
  }
  
  static var cursor: some View {
    Rectangle()
      .fill(Color.green)
      .frame(width: 8.0)
  }
  
  static var previews: some View {
    Group {
      HStack {
        Indenter(
          count: 0,
          blank: {
            blank
          },
          cursor: {
            cursor
          }
        )
      }
        .previewDisplayName("Count: 0")
      
      HStack {
        Indenter(
          count: 1,
          blank: {
            blank
          },
          cursor: {
            cursor
          }
        )
      }
        .previewDisplayName("Count: 1")
      
      HStack {
        Indenter(
          count: 4,
          blank: {
            blank
          },
          cursor: {
            cursor
          }
        )
      }
        .previewDisplayName("Count: 4")
    }
      .frame(height: 50.0)
  }
}
