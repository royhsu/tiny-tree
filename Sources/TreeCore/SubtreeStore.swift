//
//  SubtreeStore.swift
//
//
//  Created by Roy Hsu on 2020/4/6.
//

import Combine

/// Subtree is a specialized node that can carry children associated with it and also share all the capabilities
/// a leaf has, such as representing a value of node.
public final class SubtreeStore<Value>: LeafStore<Value> {
  public var children: [Child] {
    willSet {
      // Beware of the follwoing rules for subclasses to publish their updates.
      // 1. CANNOT be marked with @Published property wrapper.
      // 2. Must be triggered manually due to synthesis is not applied automatically on subclasses.
      // See [@Published property wrapper not working on subclass of ObservableObject
      // ](https://stackoverflow.com/questions/57615920/published-property-wrapper-not-working-on-subclass-of-observableobject)
      objectWillChange.send()
    }
    didSet {
      updateParentForChildren()
    }
  }
  /// Indicate wehther to show its children.
  public var areChildrenExpanded = false {
    willSet {
      // Same reason from above.
      objectWillChange.send()
    }
  }
  
  public init(value: Value, children: [Child]) {
    self.children = children
    super.init(value: value)
    self.setUp()
  }
}

extension SubtreeStore {
  private func setUp() {
    updateParentForChildren()
  }
  
  private func updateParentForChildren() {
    for child in children {
      child.parent = self
    }
  }
}

// MARK: - Primitive

extension SubtreeStore where Value == Atomic {
  public convenience init(value: Atomic, children: Primitive) {
    self.init(
      value: value,
      children: Self.parseChildren(from: children)
    )
  }
  
  public func setChildren(_ primitive: Primitive) {
    children = Self.parseChildren(from: primitive)
  }
  
  private static func parseChildren(from primitive: Primitive) -> [Child] {
    switch primitive {
    case let .integer(integer):
      return  [.leaf(LeafStore(value: .integer(integer)))]
    case let .string(string):
      return [.leaf(LeafStore(value: .string(string)))]
    case let .array(array):
      return zip(array.indices, array).map(SubtreeStore.Child.init)
    case let .dictionary(dictionary):
      return dictionary.map(SubtreeStore.Child.init)
    }
  }
}

// MARK: - Child
  
extension SubtreeStore {
  public enum Child {
    case leaf(LeafStore<Value>)
    case subtree(SubtreeStore<Value>)
    
    public var value: Value? {
      switch self {
      case let .leaf(store):
        return store.value
      case let .subtree(store):
        return store.value
      }
    }
    
    public var parent: LeafStore<Value>? {
      get {
        switch self {
        case let .leaf(store):
          return store.parent
        case let .subtree(store):
          return store.parent
        }
      }
      
      nonmutating set {
        switch self {
        case let .leaf(store):
          store.parent = newValue
        case let .subtree(store):
          store.parent = newValue
        }
      }
    }
  }
}

// MARK: - Identifiable

extension SubtreeStore.Child: Identifiable {
  public var id: ObjectIdentifier {
    switch self {
    case let .leaf(store):
      return store.id
    case let .subtree(store):
      return store.id
    }
  }
}

// MARK: - Primitive

extension SubtreeStore.Child where Value == Atomic {
  fileprivate init(index: Int, primitive: Primitive) {
    self = .init(key: Primitive.Key(intValue: index), primitive: primitive)
  }
  
  fileprivate init(key: Primitive.Key, primitive: Primitive) {
    switch primitive {
    case let .integer(integer):
      self = .subtree(
        SubtreeStore(
          value: Atomic(key),
          children: [.leaf(LeafStore(value: .integer(integer)))]
        )
      )
    case let .string(string):
      self = .subtree(
        SubtreeStore(
          value: Atomic(key),
          children: [.leaf(LeafStore(value: .string(string)))]
        )
      )
    case let .array(array):
      self = .subtree(
        SubtreeStore(
          value: Atomic(key),
          children: zip(array.indices, array).map(SubtreeStore.Child.init)
        )
      )
    case let .dictionary(dictionary):
      self = .subtree(
        SubtreeStore(
          value: Atomic(key),
          children: dictionary.map(SubtreeStore.Child.init)
        )
      )
    }
  }
}
