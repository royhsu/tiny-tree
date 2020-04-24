//
//  DebugMode.swift
//  
//
//  Created by Roy Hsu on 2020/4/18.
//

import SwiftUI

@propertyWrapper
public struct DebugMode {
  public var wrappedValue: Bool
  
  public init(wrappedValue: Bool = false) {
    self.wrappedValue = wrappedValue
  }
}

// MARK: - Environment

extension EnvironmentValues {
  public var debugMode: DebugMode {
    get { self[DebugModeKey.self] }
    set { self[DebugModeKey.self] = newValue }
  }
}

// MARK: - Key

struct DebugModeKey: EnvironmentKey {
  static var defaultValue: DebugMode { DebugMode() }
}
