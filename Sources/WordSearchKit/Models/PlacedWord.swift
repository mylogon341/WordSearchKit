//
//  File.swift
//  WordSearchKit
//
//  Created by luke on 23/11/2025.
//

import Foundation

public struct PlacedWord {
  public let word: String
  public let start: GridPoint
  public let direction: Direction
  
  public var allPoints: [GridPoint] {
    var points: [GridPoint] = [start]
    
    for _ in 1..<word.count {
      if let next = points.last?.offset(by: direction.delta) {
        points.append(next)
      }
    }
    
    return points
  }
}
