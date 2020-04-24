//
//  Primitive.swift
//
//
//  Created by Roy Hsu on 2020/4/7.
//

/// Codable representation of Swift built-in primitive types.
public enum Primitive {
  case integer(Int)
  case string(String)
  indirect case array([Primitive])
  indirect case dictionary([Key: Primitive])
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
  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    if let array = try? container.decode([Primitive].self) {
      self = .array(array)
    } else if let dictionary = try? container.decode([String: Primitive].self) {
      self = .dictionary(
        Dictionary(uniqueKeysWithValues: dictionary
          .map { key, value in (Key(stringValue: key), value) })
      )
    } else if let dictionary = try? container.decode([Int: Primitive].self) {
      self = .dictionary(
        Dictionary(uniqueKeysWithValues: dictionary
          .map { key, value in (Key(intValue: key), value) })
      )
    } else if let integer = try? container.decode(Int.self) {
      self = .integer(integer)
    } else if let string = try? container.decode(String.self) {
      self = .string(string)
    } else {
      throw DecodingError.typeMismatch(
        Primitive.self,
        DecodingError.Context(
          codingPath: container.codingPath,
          debugDescription: "Incompatible value."
        )
      )
    }
  }
}

// MARK: - Encodable

extension Primitive: Encodable {
  public func encode(to encoder: Encoder) throws {
    switch self {
    case let .integer(integer):
      var container = encoder.singleValueContainer()
      try container.encode(integer)
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
