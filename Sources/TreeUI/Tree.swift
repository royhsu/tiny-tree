//
//  Tree.swift
//  DataPreviewer
//
//  Created by Roy Hsu on 2020/4/5.
//  Copyright © 2020 TinyWorld. All rights reserved.
//

//import SwiftUI
//import Logging
//import TinyConsoleSwiftLog

//final class TreeStore<ID, Data>: ObservableObject {
//  let id: ID
//  @Published
//  var root: Root
//
//  init(id: ID, root: Root) {
//    self.id = id
//    self.root = root
//  }
//}
//
//extension TreeStore {
//  typealias Root = KeyValuePairs<ID, Data>
//}
//
//struct Tree<ID, Data, Node>: View where Node: View {
//  @ObservedObject
//  var store: Store
//  var leaf: Leaf
//
//  var body: some View {
//    List {
//      Subtree(
//        SubtreeStore(id: self.store.id, children: self.store.root),
//        leaf: self.leaf
//      )
//    }
//  }
//
//  init(_ store: Store, leaf: @escaping Leaf) {
//    self.store = store
//    self.leaf = leaf
//  }
//}
//
// MARK: - Store
//
//extension Tree {
//  typealias Store = TreeStore<ID, Data>
//}
//
// MARK: - Leaf
//
//extension Tree {
//  typealias Leaf = (LeafStore<ID, Data>) -> Node
//}
//
// MAKR: - Previews
//
//struct Tree_Previews: PreviewProvider {
//  static var previews: some View {
//    Tree(
//      TreeStore(
//        id: UUID(),
//        root: [
//          UUID(): "a",
//          UUID(): "1",
//          UUID(): "b",
//          UUID(): "3"
//        ]
//      )
//    ) { store in
//      HStack {
//        HStack {
//          Text("ID: \(store.id)")
//            .lineLimit(1)
//          Spacer()
//        }
//          .frame(width: 120.0)
//        Rectangle()
//          .frame(width: 0.5)
//          .foregroundColor(.gray)
//        Text(store.data)
//
//      }
//    }
//  }
//}


































//extension View {
//  func nested() -> some View {
//    HStack {
//      Rectangle()
//        .frame(width: 8.0)
//        .foregroundColor(.red)
//      self
//    }
//  }
//}
//
//struct DictionaryView: View {
//  @ObservedObject
//  var dictionary: NewDictionaryStore
//  @Environment(\.logger)
//  var logger
//
//  var body: some View {
//    List {
//      dictionaryView(from: dictionary)
//    }
//      .onAppear {
//        self.dictionary.fetch()
//      }
//  }
//}
//
//extension DictionaryView {
//  private func stringView(from string: StringStore) -> some View {
//    Text(string.value)
//  }
//
//  private func dictionaryView(from dictionary: NewDictionaryStore) -> some View {
//    ForEach(dictionary.pairs) { pair in
//      self.pairView(from: pair)
//    }
//  }
//
//  private func keyView(from pair: NewDictionaryStore.Pair) -> some View {
//    Text(pair.key)
//  }
//
//  private func pairView(from pair: NewDictionaryStore.Pair) -> some View {
//    switch pair.value {
//    case let .string(store):
//      return AnyView(
//        HStack {
//          keyView(from: pair)
//          Rectangle()
//            .frame(width: 0.5)
//          Spacer()
//          stringView(from: store)
//        }
//      )
//    case let .dictionary(store):
//      return AnyView(
//        Group {
//          keyView(from: pair)
//            .onTapGesture {
//              self.logger.trace("Tapped")
//              store.fetch()
//            }
//
//          ForEach(store.pairs) { pair in
//            self.pairView(from: pair)
////              .nested()
//          }
//        }
//      )
//    }
//  }
//}
//
//let testData: [String: TreeNode] = [
//  "A": .string(StringStore(value: "a")),
//  "B": .string(StringStore(value: "b")),
//  "C": .dictionary(
//    NewDictionaryStore(
//      fetch: {
//        Future { promise in
//          let data: [String: TreeNode] = [
//            "-c.0": .string(StringStore(value: "0")),
//            "-c.1": .string(StringStore(value: "1")),
//            "-c.2": .string(StringStore(value: "2")),
//          ]
//          promise(.success(data))
//        }
//          .eraseToAnyPublisher()
//      }
//    )
//  )
//]

//struct DictionaryView_Previews: PreviewProvider {
//  static var previews: some View {
//    DictionaryView(
//      dictionary: NewDictionaryStore(
//        fetch: {
//          Future { promise in
//            promise(.success(testData))
//          }
//            .eraseToAnyPublisher()
//        }
//      )
//    )
//  }
//}

//final class TreeStore: ObservableObject {
//  @Published
//  var name = "Root"
//  @Published
//  var nodes: [TreeNode] = [
//    .dictionary(
//      DictionaryStore(
//        pairs: [
//          .init(key: "A", value: .string(StringStore(value: "a"))),
//          .init(key: "B", value: .string(StringStore(value: "b"))),
//        ]
//      )
//    )
//  ]
//}

//enum TreeNode {
//  case string(StringStore)
//  case dictionary(NewDictionaryStore)
//
//  var objectWillChange: AnyPublisher<Void, Never> {
//    switch self {
//    case let .dictionary(store): return store.objectWillChange.eraseToAnyPublisher()
//    case let .string(store): return store.objectWillChange.eraseToAnyPublisher()
//    }
//  }
//}
//
//extension TreeNode: Identifiable {
//  var id: UUID {
//    switch self {
//    case let .string(string): return string.id
//    case let .dictionary(dictionary): return dictionary.id
//    }
//  }
//}
//
//final class StringStore: ObservableObject {
//  let id = UUID()
//  @Published
//  var value: String
//  init(value: String) { self.value = value }
//}
//
//extension StringStore: Identifiable { }
//
//final class DictionaryStore: ObservableObject {
//  let id = UUID()
//  @Published
//  var pairs = [Pair]()
//
//  init(pairs: [Pair]) {
//    self.pairs = pairs
//  }
//
//  struct Pair: Identifiable {
//    var key: String
//    var value: TreeNode
//    var id: String { key }
//  }
//}
//
//extension DictionaryStore: Identifiable { }

//import Combine
//
//@propertyWrapper
//final class NewDictionaryStore: ObservableObject {
//  let id = UUID()
//  private lazy var logger = Logger(label: "DictionaryStore.\(id)")
//  private(set) var isFetching = false
//  private let _fetch: Fetch
//  private var streams = Set<AnyCancellable>()
//  private var _wrappedValueStreams = [AnyCancellable]()
//  @Published
//  private(set) var wrappedValue = [String: TreeNode]()
//
//  var pairs: [Pair] {
//    wrappedValue.map { key, value in NewDictionaryStore.Pair(key: key, value: value) }
//  }
//
//  init(fetch: @escaping Fetch) {
//    self._fetch = fetch
//  }
//}
//
//extension NewDictionaryStore {
//  func fetch() {
//    precondition(!isFetching, "API Misuse: You CANNOT perform another fetch during the store is fetching.")
//    logger.trace("fetching data.")
//    isFetching = true
//
//    _fetch()
//      .sink(
//        receiveCompletion: { [weak self] completion in
//          guard let self = self else { return }
//          self.isFetching = false
//
//          switch completion {
//          case let .failure(error): print("\(error)")
//          case .finished: break
//          }
//        },
//        receiveValue: { [weak self] value in
//          guard let self = self else { return }
//          self.wrappedValue.merge(value, uniquingKeysWith: { _, new in new })
//          self._wrappedValueStreams = self.wrappedValue.values.map { value in
//            value.objectWillChange.sink { [weak self] in
//              self?.objectWillChange.send()
//            }
//          }
//        }
//      )
//      .store(in: &streams)
//  }
//}
//
//extension NewDictionaryStore {
//  typealias Fetch = () -> AnyPublisher<[String: TreeNode], Error>
//}
//
//extension NewDictionaryStore {
//  struct Pair: Identifiable {
//    var key: String
//    var value: TreeNode
//    var id: String { key }
//  }
//}
//
//extension NewDictionaryStore: Identifiable {}
