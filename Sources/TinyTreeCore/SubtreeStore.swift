//
//  SubtreeStore.swift
//
//
//  Created by Roy Hsu on 2020/4/6.
//

/// Subtree is a specialized node that can carry children associated with it and also share all the capabilities
/// a node has, such as representing a value of node.
public final class SubtreeStore<Value>: NodeStore<Value> {
  public var children: [Child] {
    willSet {
      // Beware of the follwoing rules for subclasses to publish their updates.
      // 1. CANNOT be marked with @Published property wrapper.
      // 2. Must be triggered manually due to synthesis is not applied automatically on subclasses.
      // See [@Published property wrapper not working on subclass of ObservableObject](https://stackoverflow.com/questions/57615920/published-property-wrapper-not-working-on-subclass-of-observableobject)
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
    for child in children { child.parent = self }
  }
}

// MARK: - Primitive

extension SubtreeStore where Value == Atom {
  public convenience init(value: Atom, children: Primitive) {
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
    case let .bool(bool):
      return [.leaf(LeafStore(value: .bool(bool)))]
    case let .integer(integer):
      return [.leaf(LeafStore(value: .integer(integer)))]
    case let .double(double):
      return [.leaf(LeafStore(value: .double(double)))]
    case let .string(string):
      return [.leaf(LeafStore(value: .string(string)))]
    case let .array(array):
      return zip(array.indices, array).map(SubtreeStore.Child.init)
    case let .dictionary(dictionary):
      return dictionary.map(SubtreeStore.Child.init)
    }
  }
}
