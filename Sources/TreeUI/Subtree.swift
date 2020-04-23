//
//  Subtree.swift
//
//
//  Created by Roy Hsu on 2020/4/6.
//

import Combine
import SwiftUI
import TreeCore

/// Subtrees are primarily for generating leaves for containers, such as, List or Form to render content.
public struct Subtree<Value, Content, Leaf>: View
where Content: View, Leaf: View {
  /// The source of truth for a subtree.
  @ObservedObject
  public var store: SubtreeStore<Value>
  /// The content of a subtree itself.
  public var content: (SubtreeStore<Value>) -> Content
  /// The content for each leaf in a subtree.
  public var leaf: (LeafStore<Value>) -> Leaf
  
  public var body: some View {
    Group {
      content(store)
      if store.areChildrenExpanded {
        ForEach(store.children) { child in
          self.view(for: child)
        }
      }
    }
  }

  public init(
    _ store: SubtreeStore<Value>,
    content: @escaping (SubtreeStore<Value>) -> Content,
    leaf: @escaping (LeafStore<Value>) -> Leaf
  ) {
    self.store = store
    self.content = content
    self.leaf = leaf
  }
}

extension Subtree {
  private func view(for child: SubtreeStore<Value>.Child) -> AnyView {
    switch child {
    case let .leaf(store):
      return AnyView(leaf(store))
    case let .subtree(store):
      return AnyView(Subtree(store, content: self.content, leaf: self.leaf))
    }
  }
}

// MARK: - Previews

struct Subtree_Previews: PreviewProvider {
  static var previews: some View {
    List {
      Subtree(
        SubtreeStore(
          value: .string("root"),
          children: [
            "a": ["x", "y", "z"],
            "b": "hi",
            "c": 3,
          ]
        ),
        content: { store in
          HStack {
            SubtreeProperty(store)
            HStack {
              AtomicView(value: store.value)
              Text(store.parent == nil ? "(tree)" : "(subtree)")
                .foregroundColor(.gray)
            }
          }
        },
        leaf: { store in
          HStack {
//            SubtreeProperty(store)
            AtomicView(value: store.value)
          }
        }
      )
    }
  }
}

struct AtomicView: View {
  var value: Atomic
  var body: some View {
    content()
  }
  
  private func content() -> some View {
    switch value {
    case let .integer(integer):
      return Text("\(integer)")
    case let .string(string):
      return Text(string)
    }
  }
}
