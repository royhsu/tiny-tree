//
//  Primitive.swift
//
//
//  Created by Roy Hsu on 2020/4/7.
//

import Foundation

/// Codable representation of common primitive types.
public enum Primitive {
  case bool(Bool)
  case integer(Int)
  case double(Double)
  case string(String)
  indirect case array([Primitive])
  indirect case dictionary([Key: Primitive])
}

// MARK: - ExpressibleByBooleanLiteral

extension Primitive: ExpressibleByBooleanLiteral {
  public init(booleanLiteral bool: Bool) {
    self = .bool(bool)
  }
}

// MARK: - ExpressibleByIntegerLiteral

extension Primitive: ExpressibleByIntegerLiteral {
  public init(integerLiteral integer: Int) {
    self = .integer(integer)
  }
}

// MARK: - ExpressibleByStringLiteral

extension Primitive: ExpressibleByStringLiteral {
  public init(stringLiteral string: String) {
    self = .string(string)
  }
}

// MARK: - ExpressibleByArrayLiteral

extension Primitive: ExpressibleByArrayLiteral {
  public init(arrayLiteral elements: Primitive...) {
    self = .array(elements)
  }
}

// MARK: - ExpressibleByDictionaryLiteral

extension Primitive: ExpressibleByDictionaryLiteral {
  public init(dictionaryLiteral elements: (Key, Primitive)...) {
    self = .dictionary(Dictionary(uniqueKeysWithValues: elements))
  }
}

// MARK: - Decodable

extension Primitive: Decodable {
  init(from keyedContainer: KeyedDecodingContainer<Key>) throws {
    var decoded = [Key: Primitive]()
    for key in keyedContainer.allKeys {
      if let bool = try? keyedContainer.decode(Bool.self, forKey: key) {
        decoded[key] = .bool(bool)
      } else if let integer = try? keyedContainer.decode(Int.self, forKey: key) {
        decoded[key] = .integer(integer)
      } else if let double = try? keyedContainer.decode(Double.self, forKey: key) {
        decoded[key] = .double(double)
      } else if let string = try? keyedContainer.decode(String.self, forKey: key) {
        decoded[key] = .string(string)
      } else if let nestedKeyedContainer = try? keyedContainer.nestedContainer(keyedBy: Key.self, forKey: key) {
        var decodedNested = [Key: Primitive]()
        for nestedKey in nestedKeyedContainer.allKeys {
          decodedNested[nestedKey] = try nestedKeyedContainer.decode(
            Primitive.self,
            forKey: nestedKey
          )
        }
        decoded[key] = .dictionary(decodedNested)
      } else if var nestedUnkeyedContainer = try? keyedContainer.nestedUnkeyedContainer(forKey: key) {
        var decodedNested = [Primitive]()
        while !nestedUnkeyedContainer.isAtEnd {
          decodedNested.append(
            try nestedUnkeyedContainer.decode(Primitive.self)
          )
        }
        decoded[key] = .array(decodedNested)
      } else {
        throw DecodingError.typeMismatch(
          Primitive.self,
          DecodingError.Context(
            codingPath: keyedContainer.codingPath,
            debugDescription: "Incompatible value."
          )
        )
      }
    }
    self = .dictionary(decoded)
  }
  
  init(from unkeyedContainer: UnkeyedDecodingContainer) throws {
    var unkeyedContainer = unkeyedContainer
    var decoded = [Primitive]()
    while !unkeyedContainer.isAtEnd {
      if let bool = try? unkeyedContainer.decode(Bool.self) {
        decoded.append(.bool(bool))
      } else if let integer = try? unkeyedContainer.decode(Int.self) {
        decoded.append(.integer(integer))
      } else if let double = try? unkeyedContainer.decode(Double.self) {
        decoded.append(.double(double))
      } else if let string = try? unkeyedContainer.decode(String.self) {
        decoded.append(.string(string))
      } else if let nestedKeyedContainer = try? unkeyedContainer.nestedContainer(keyedBy: Key.self) {
        var decodedNested = [Key: Primitive]()
        for nestedKey in nestedKeyedContainer.allKeys {
          decodedNested[nestedKey] = try nestedKeyedContainer.decode(
            Primitive.self,
            forKey: nestedKey
          )
        }
        decoded.append(.dictionary(decodedNested))
      } else if var nestedUnkeyedContainer = try? unkeyedContainer.nestedUnkeyedContainer() {
        var decodedNested = [Primitive]()
        while !nestedUnkeyedContainer.isAtEnd {
          try decodedNested.append(
            nestedUnkeyedContainer.decode(Primitive.self)
          )
        }
        decoded.append(.array(decodedNested))
      } else {
        throw DecodingError.typeMismatch(
          Primitive.self,
          DecodingError.Context(
            codingPath: unkeyedContainer.codingPath,
            debugDescription: "Incompatible value."
          )
        )
      }
    }
    self = .array(decoded)
  }
  
  init(from singleValueContainer: SingleValueDecodingContainer) throws {
    if let bool = try? singleValueContainer.decode(Bool.self) {
      self = .bool(bool)
    } else if let integer = try? singleValueContainer.decode(Int.self) {
      self = .integer(integer)
    } else if let double = try? singleValueContainer.decode(Double.self) {
      self = .double(double)
    } else if let string = try? singleValueContainer.decode(String.self) {
      self = .string(string)
    } else {
      throw DecodingError.typeMismatch(
        Primitive.self,
        DecodingError.Context(
          codingPath: singleValueContainer.codingPath,
          debugDescription: "Incompatible value."
        )
      )
    }
  }
  
  public init(from decoder: Decoder) throws {
    if let keyedContainer = try? decoder.container(keyedBy: Key.self) {
      try self.init(from: keyedContainer)
    } else if let unkeyedContainer = try? decoder.unkeyedContainer() {
      try self.init(from: unkeyedContainer)
    } else {
      try self.init(from: decoder.singleValueContainer())
    }
  }
}

// MARK: - Encodable

extension Primitive: Encodable {
  public func encode(to encoder: Encoder) throws {
    switch self {
    case let .bool(bool):
      var container = encoder.singleValueContainer()
      try container.encode(bool)
    case let .integer(integer):
      var container = encoder.singleValueContainer()
      try container.encode(integer)
    case let .double(double):
      var container = encoder.singleValueContainer()
      try container.encode(double)
    case let .string(string):
      var container = encoder.singleValueContainer()
      try container.encode(string)
    case let .array(array):
      var container = encoder.unkeyedContainer()
      try container.encode(array)
    case let .dictionary(dictionary):
      var container = encoder.container(keyedBy: Key.self)
      for (key, value) in dictionary {
        try container.encode(value, forKey: key)
      }
    }
  }
}
