//
//  LeafProperty.swift
//  
//
//  Created by Roy Hsu on 2020/4/17.
//

import SwiftUI
import TinyTreeCore

public struct LeafProperty: View {
  @ObservedObject
  public var store: LeafStore<Atomic>
  @Environment(\.debugMode)
  private var debugMode
  
  public var body: some View {
    HStack {
      indenter
      AtomicView(value: store.value)
      Spacer()
    }
  }
  
  public init(_ store: LeafStore<Atomic>) {
    self.store = store
  }
}

extension LeafProperty {
  private var indenter: some View {
    HStack(spacing: indenterSpacing) {
      Indenter(
        count: store.ancestors.count + 1,
        blank: {
          self.blank
        },
        cursor: {
          self.cursor
        }
      )
    }
  }
  
  private var indenterSpacing: CGFloat? { debugMode.wrappedValue ? nil : 0.0 }
  
  private var _debugBlank: some View {
    Rectangle()
      .fill(Color.red)
      .frame(width: 8.0)
  }
  
  private var _releaseBlank: some View {
    Rectangle()
      .fill(Color.clear)
      .frame(width: 8.0)
  }
  
  private var blank: some View {
    debugMode.wrappedValue ? AnyView(_debugBlank) : AnyView(_releaseBlank)
  }
  
  private var _debugCursor: some View {
    Rectangle()
      .fill(Color.green)
      .frame(width: 8.0)
  }
  
  private var _releaseCursor: some View { EmptyView() }
  
  private var cursor: some View {
    debugMode.wrappedValue ? AnyView(_debugCursor) : AnyView(_releaseCursor)
  }
}

//LeafProperty(LeafStore(value: "a"))
//  .previewDisplayName("A node without parent")
