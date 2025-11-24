//
//  File.swift
//  WordSearchKit
//
//  Created by luke on 23/11/2025.
//

import Foundation

struct Grid {
  private(set) var rows: Int
  private(set) var columns: Int
  private(set) var placedWords: [PlacedWord] = []
  
  private var storage: [[Character]]
  
  init(rows: Int, columns: Int) {
    self.rows = rows
    self.columns = columns
    
    self.storage = Array(
      repeating: Array(repeating: " ", count: columns),
      count: rows
    )
  }
  
  var description: String {
    return storage.map(\.description).joined(separator: "\n")
  }
  
  mutating func storePlacedWord(_ word: PlacedWord) {
    placedWords.append(word)
  }
  
  func character(at row: Int, col: Int) throws(WordSearchError) -> Character {
    
    guard isInside(row, col) else {
      throw .outOfBounds
    }
    
    return storage[row][col]
  }
  
  mutating func set(_ char: Character, at row: Int, col: Int) throws(WordSearchError) {
    
    guard isInside(row, col) else {
      throw .outOfBounds
    }
    
    storage[row][col] = char
  }
  
  func isInside(_ row: Int, _ col: Int) -> Bool {
    row >= 0 &&
    row < rows &&
    col >= 0 &&
    col < columns
  }
}
