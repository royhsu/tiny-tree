//
//  NodeStore.swift
//
//
//  Created by Roy Hsu on 2020/4/25.
//

import Combine

public class NodeStore<Value>: ObservableObject {
  @Published
  public var value: Value
  public weak var parent: NodeStore? {
    willSet { objectWillChange.send() }
  }
  
  public init(value: Value) {
    self.value = value
  }
}

// MARK: - Identifiable

extension NodeStore: Identifiable {}

// MARK: - Relationships

extension NodeStore {
  public var ancestors: [NodeStore] {
    var ancestors = [NodeStore]()
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
