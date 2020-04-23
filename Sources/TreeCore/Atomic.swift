//
//  Atomic.swift
//
//
//  Created by Roy Hsu on 2020/4/11.
//

/// UInt8, Int32...
public enum Atomic {
  case integer(Int)
  case string(String)
}

// MARK: - Primitive.Key

extension Atomic {
  init(_ key: Primitive.Key) {
    switch key.rawValue {
    case let .integer(integer):
      self = .integer(integer)
    case let .string(string):
      self = .string(string)
    }
  }
}
