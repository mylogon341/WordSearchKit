//
//  File.swift
//  WordSearchKit
//
//  Created by luke on 26/11/2025.
//

import Foundation

/// Provides a coordinates system for the 2D array
public struct GridPoint: Equatable, Hashable {
  let row: Int
  let column: Int
  
  var x: Int { column }
  var y: Int { row }
  
  func offset(by delta: Delta) -> GridPoint {
    .init(row: row + delta.row,
          column: column + delta.column)
  }
  
  public init(row: Int, column: Int) {
    self.row = row
    self.column = column
  }
}

extension GridPoint {
  /// A convenient way to construct via x and y points rather than row and column, if you prefer.
  public init(x: Int, y: Int) {
    self.init(row: y, column: x)
  }
}
