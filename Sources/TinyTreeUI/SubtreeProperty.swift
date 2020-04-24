//
//  SubtreeProperty.swift
//  DataPreviewer
//
//  Created by Roy Hsu on 2020/4/7.
//  Copyright © 2020 TinyWorld. All rights reserved.
//

#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif
import SwiftUI
import TinyTreeCore

public struct SubtreeProperty: View {
  @ObservedObject
  public var store: SubtreeStore<Atomic>
  @Environment(\.debugMode)
  public var debugMode
  
  public var body: some View {
    HStack {
      indenter
      property
      Spacer()
    }
      .onTapGesture {
        withAnimation {
          self.store.areChildrenExpanded.toggle()
        }
      }
      .frame(maxWidth: .infinity)
  }
  
  public init(_ store: SubtreeStore<Atomic>) {
    self.store = store
  }
}

extension SubtreeProperty {
  private var indenter: some View {
    HStack(spacing: indenterSpacing) {
      Indenter(
        count: store.ancestors.count + 1,
        blank: {
          self.blank
        },
        cursor: {
          self.cursor
            .rotationEffect(
              Angle(degrees: self.store.areChildrenExpanded ? 90.0 : 0.0)
            )
        }
      )
    }
  }
  
  private var indenterSpacing: CGFloat? { debugMode.wrappedValue ? nil : 0.0 }
  
  private var property: some View {
    debugMode.wrappedValue
      ? AnyView(
        Group {
          AtomicView(value: store.value)
          Text(store.parent == nil ? "(tree)" : "(subtree)")
            .foregroundColor(.gray)
        }
      )
      : AnyView(AtomicView(value: store.value))
  }
  
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
  
  private var _releaseCursor: some View {
    #if canImport(AppKit)
    return Image(
      nsImage: NSImage(named: NSImage.rightFacingTriangleTemplateName)!
    )
    #elseif canImport(UIKit)
    return Image(systemName: "arrowtriangle.right.fill")
    #else
    fatalError("Unimplemented")
    #endif
  }
  
  private var cursor: some View {
    debugMode.wrappedValue ? AnyView(_debugCursor) : AnyView(_releaseCursor)
  }
}

// MARK: - Previews

struct SubtreeProperty_Previews: PreviewProvider {
  static let grandParent = SubtreeStore(
    value: .string("grand parent"),
    children: []
  )
  static let parent = SubtreeStore(value: .string("parent"), children: [])
  static let child = SubtreeStore(value: .string("child"), children: [])
  
  static var previews: some View {
    SubtreeProperty(
      withObject(child) { child in
        child.parent = parent
        parent.parent = grandParent
      }
    )
      .environment(\.debugMode.wrappedValue, true)
      .previewDisplayName("A node with parent and grand parent.")
  }
}
