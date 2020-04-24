//
//  Primitive+Key.swift
//
//
//  Created by Roy Hsu on 2020/4/9.
//

extension Primitive {
  public struct Key: RawRepresentable {
    public var rawValue: RawValue
    
    public init(rawValue: RawValue) {
      self.rawValue = rawValue
    }
  }
}

// MARK: - RawValue

extension Primitive.Key {
  public enum RawValue: Hashable {
    case integer(Int)
    case string(String)
  }
}

// MARK: - Hashable

extension Primitive.Key: Hashable {}

// MARK: - Comparable

extension Primitive.Key: Comparable {
  public static func < (lhs: Self, rhs: Self) -> Bool {
    switch (lhs.rawValue, rhs.rawValue) {
    case (.integer(let lhsValue), .integer(let rhsValue)):
      return lhsValue < rhsValue
    case (.string(let lhsValue), .string(let rhsValue)):
      return lhsValue < rhsValue
    case (.integer, .string), (.string, .integer):
      return false
    }
  }
}

// MARK: - ExpressibleByIntegerLiteral

extension Primitive.Key: ExpressibleByIntegerLiteral {
  public init(integerLiteral value: Int) {
    self.init(intValue: value)
  }
}

// MARK: - ExpressibleByStringLiteral

extension Primitive.Key: ExpressibleByStringLiteral {
  public init(stringLiteral value: String) {
    self.init(stringValue: value)
  }
}

// MARK: - Decodable

extension Primitive.Key: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    if let value = try? container.decode(Int.self) {
      self.rawValue = .integer(value)
    } else if let value = try? container.decode(String.self) {
      self.rawValue = .string(value)
    } else {
      throw DecodingError.typeMismatch(
        Primitive.Key.self,
        .init(
          codingPath: decoder.codingPath,
          debugDescription: "Incompatible key."
        )
      )
    }
  }
}

// MARK: - Encodable

extension Primitive.Key: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    switch rawValue {
    case let .integer(value):
      try container.encode(value)
    case let .string(value):
      try container.encode(value)
    }
  }
}

// MARK: - CodingKey

extension Primitive.Key: CodingKey {
  public var stringValue: String {
    switch rawValue {
    case let .integer(value):
      return "\(value)"
    case let .string(value):
      return value
    }
  }

  public var intValue: Int? {
    switch rawValue {
    case let .integer(value):
      return value
    case let .string(value):
      return Int(value)
    }
  }

  public init(intValue: Int) {
    self.rawValue = .integer(intValue)
  }

  public init(stringValue: String) {
    self.rawValue = .string(stringValue)
  }
}
