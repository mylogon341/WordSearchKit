//
//  File.swift
//  WordSearchKit
//
//  Created by luke on 23/11/2025.
//

import Foundation

public struct Grid {
  public private(set) var rows: Int
  public private(set) var columns: Int
  public private(set) var placedWords: [PlacedWord] = []
  public private(set) var storage: [[Character]]
 
  internal init(rows: Int, columns: Int) {
    self.rows = rows
    self.columns = columns
    
    self.storage = Array(
      repeating: Array(repeating: " ", count: columns),
      count: rows
    )
  }
  
  // for reliable unit testing
  internal init(storage: [[Character]]) {
    self.rows = storage.count
    self.columns = storage.first?.count ?? 0
    self.storage = storage
  }
  
  internal mutating func addPlacedWord(_ word: PlacedWord) {
    placedWords.append(word)
  }
  
  /// For getting a visual representation of the 2D array in the console
  public var description: String {
    storage
      .map(\.description)
      .joined(separator: "\n")
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
