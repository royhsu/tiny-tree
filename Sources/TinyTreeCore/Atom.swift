//
//  Atom.swift
//
//
//  Created by Roy Hsu on 2020/4/11.
//

import Foundation

public enum Atom {
  case bool(Bool)
  case integer(Int)
  case double(Double)
  case string(String)
}

// MARK: - Primitive.Key

extension Atom {
  init(_ key: Primitive.Key) {
    switch key.rawValue {
    case let .integer(integer):
      self = .integer(integer)
    case let .string(string):
      self = .string(string)
    }
  }
}
