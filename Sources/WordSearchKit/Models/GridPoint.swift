//
//  File.swift
//  WordSearchKit
//
//  Created by luke on 26/11/2025.
//

import Foundation

/// Provides a coordinates system for the 2D array
public struct GridPoint: Equatable {
  let row: Int
  let column: Int
  
  var x: Int { column }
  var y: Int { row }
  
  func offset(by delta: Delta) -> GridPoint {
    .init(row: row + delta.row,
          column: column + delta.column)
  }
}
