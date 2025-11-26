//
//  File.swift
//  WordSearchKit
//
//  Created by luke on 23/11/2025.
//

import Foundation

internal struct RandomFill {
  
  static func fillEmptySpaces(in grid: inout Grid, uppercase: Bool) throws(WordSearchError) {
    
    for r in 0..<grid.rows {
      for c in 0..<grid.columns {
        
        if try grid.character(at: r, col: c) == " " {
          let letter = randomLetter(uppercase: uppercase)
          try grid.set(letter, at: r, col: c)
        }
      }
    }
  }
  
  private static func randomLetter(uppercase: Bool) -> Character {
    // TODO: Consider non-english?
    let upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    let lower = upper.lowercased()
    
    if uppercase {
      return upper.randomElement()!
    } else {
      return lower.randomElement()!
    }
  }
}
