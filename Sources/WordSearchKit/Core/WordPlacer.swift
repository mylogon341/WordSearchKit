//
//  File.swift
//  WordSearchKit
//
//  Created by luke on 23/11/2025.
//

import Foundation

/// Attempts to place a single word into the grid.
/// Returns a `PlacedWord` if successful.
struct WordPlacer {
  
  /// Try placing the word several times in random positions.
  static func place(word: String,
                    in grid: inout Grid,
                    allowOverlaps: Bool,
                    maxAttempts: Int = 40) throws(WordSearchError) -> PlacedWord {
    
    let directions = Direction.allCases
    
    for _ in 0..<maxAttempts {
      guard let direction = directions.randomElement() else { continue }
      
      let startRow = Int.random(in: 0..<grid.rows)
      let startCol = Int.random(in: 0..<grid.columns)
      let delta = direction.delta
      
      
      if try canPlace(word,
                      at: startRow,
                      col: startCol,
                      delta: delta,
                      allowOverlaps: allowOverlaps,
                      grid: grid) {
        return try write(word,
                         at: startRow,
                         col: startCol,
                         delta: direction.delta,
                         grid: &grid,
                         direction: direction)
      }
    }
    
    throw .unableToPlaceWord
  }
  
  /// Check if the word fits from the given start position.
  private static func canPlace(_ word: String,
                               at row: Int,
                               col: Int,
                               delta: Delta,
                               allowOverlaps: Bool,
                               grid: Grid) throws(WordSearchError) -> Bool {
    
    var row = row
    var col = col
    
    for char in word {
      
      if !grid.isInside(row, col) {
        return false
      }
      
      let existing = try grid.character(at: row, col: col)
      if existing != " " && existing != char {
        return false
      }
      
      if !allowOverlaps && existing != " " {
        return false
      }
      
      row += delta.row
      col += delta.column
    }
    
    return true
  }
  
  /// Write the word into the grid.
  private static func write(_ word: String,
                            at row: Int,
                            col: Int,
                            delta: Delta,
                            grid: inout Grid,
                            direction: Direction) throws(WordSearchError) -> PlacedWord {
    
    var row = row
    var col = col
    var overlaps = true
    
    for char in word {
      if !overlaps {
        let existing = try grid.character(at: row, col: col)
        if existing == char {
          overlaps = true
        }
      }

      try grid.set(char, at: row, col: col)
      row += delta.row
      col += delta.column
    }
    
    return .init(word: word,
                 start: (row, col),
                 direction: direction,
                 overlapsAnotherWord: overlaps)
  }
}
