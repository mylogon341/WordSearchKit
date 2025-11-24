// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public struct WordSearchKit {
  
  public struct Config {
    var uppercaseEverything = true
    var allowOverlaps = true
    
    static var `default`: Config {
      return Config()
    }
  }
  
  static func generate(_ request: WordSearchRequest,
                       config: Config = .default) throws -> Grid {
    
    var grid = Grid(rows: request.rows, columns: request.columns)
    
    let words = request.words
      .compactMap({
        config.uppercaseEverything ? $0.uppercased() : $0
      })
    
    for word in words {
      let placed = try WordPlacer.place(word: word,
                                        in: &grid,
                                        allowOverlaps: config.allowOverlaps)
      grid.storePlacedWord(placed)
    }
    
    try RandomFill.fillEmptySpaces(in: &grid,
                                   uppercase: config.uppercaseEverything)
    
    return grid
  }
  
//  static func check(grid: Grid, )
}
