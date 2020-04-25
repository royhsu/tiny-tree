//
//  SubtreeStore+Child.swift
//  
//
//  Created by Roy Hsu on 2020/4/25.
//

// MARK: - Child
  
extension SubtreeStore {
  public enum Child {
    case leaf(LeafStore<Value>)
    case subtree(SubtreeStore<Value>)
  }
}
 
extension SubtreeStore.Child {
  public var value: Value? {
    switch self {
    case let .leaf(store):
      return store.value
    case let .subtree(store):
      return store.value
    }
  }
  
  public var parent: NodeStore<Value>? {
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
  init(index: Int, primitive: Primitive) {
    self = .init(key: Primitive.Key(intValue: index), primitive: primitive)
  }
  
  init(key: Primitive.Key, primitive: Primitive) {
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
