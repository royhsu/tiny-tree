//
//  Leaf.swift
//  DataPreviewer
//
//  Created by Roy Hsu on 2020/4/6.
//  Copyright © 2020 TinyWorld. All rights reserved.
//

import Combine
import SwiftUI
import TinyTreeCore

struct Leaf<Value, Content>: View where Content: View {
  @ObservedObject
  var store: LeafStore<Value>
  var content: (Value) -> Content
  
  var body: some View {
    content(store.value)
  }
  
  init(_ store: LeafStore<Value>, content: @escaping (Value) -> Content) {
    self.store = store
    self.content = content
  }
}

// MARK: - Previews

struct Leaf_Previews: PreviewProvider {
  static var previews: some View {
    Leaf(LeafStore(value: "Leaf")) { data in
      Text(data)
    }
  }
}
