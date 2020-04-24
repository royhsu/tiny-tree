//
//  LeafStore.swift
//
//
//  Created by Roy Hsu on 2020/4/6.
//

import Combine

public class LeafStore<Value>: ObservableObject {
  @Published
  public var value: Value
  public weak var parent: LeafStore? {
    didSet { objectWillChange.send() }
  }
  
  public init(value: Value) {
    self.value = value
  }
}

// MARK: - Identifiable

extension LeafStore: Identifiable {}

extension LeafStore {
  public var ancestors: [LeafStore] {
    var ancestors = [LeafStore]()
    var next = parent
    while true {
      guard let ancestor = next else {
        break
      }
      ancestors.append(ancestor)
      next = next?.parent
    }

    return ancestors
  }
}
