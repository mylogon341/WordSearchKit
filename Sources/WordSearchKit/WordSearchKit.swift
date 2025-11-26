// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public struct WordSearchKit {
  
  public struct Config {
    var uppercaseEverything = true
    var allowOverlaps = true
    
    public static var `default`: Config {
      return Config()
    }
  }
  
  /// Pass in a request for generating your word search grid.
  /// Optionally, pass in a config for some customisation
  public static func generate(_ request: WordSearchRequest,
                              config: Config = .default) throws -> Grid {
    
    var grid = Grid(rows: request.rows,
                    columns: request.columns)
    
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
  
  /**
   Use to check if the two points are the start and end for any word.
   This is not direction sensitive, so ``start`` and ``end`` just denotes the
   'start' and 'end' of the user's input, not necesserily of the word. To change this, pass in true for `directionSensitive`.
   Returns the word if found or nil if nothing found.
   */
  public static func checkPoints(grid: Grid,
                                 start: GridPoint,
                                 end: GridPoint,
                                 directionSensitive: Bool = false) -> PlacedWord? {
    
    for word in grid.placedWords {
      let points = word.allPoints
      
      if let first = points.first,
         let last = points.last {
        
        if directionSensitive {
          if start == first && end == last {
            return word
          }
        } else if (start == first && end == last) ||
                    (start == last && end == first) {
          return word
        }
      }
    }
    
    return nil
  }
  
  public static func returnLettersBetweenPoints(grid: Grid,
                                         start: GridPoint,
                                         end: GridPoint) throws(WordSearchError) -> [Character] {
    
    let xDelta = start.column - end.column
    let yDelta = start.row - end.row
    
    let xDeltaAbs = abs(xDelta)
    let yDeltaAbs = abs(yDelta)
    
    let isHorizontal = xDeltaAbs > 0 && yDeltaAbs == 0
    let isVertical = yDeltaAbs > 0 && xDeltaAbs == 0
    let isDiagonal = xDeltaAbs == yDeltaAbs
    
    guard isHorizontal ||
            isVertical ||
            isDiagonal else {
      throw .invalidDirection
    }
    
    if xDelta == 0 && yDelta == 0 {
      // start and stop in same location
      throw .invalidDirection
    }
    
    let storage = grid.storage

    if isHorizontal {
      
      let row = storage[start.row]

      if start.column > end.column {
        // LEFT
        let letters = row[end.column...start.column]
        return Array(letters).reversed()
      } else {
        // RIGHT
        let letters = row[start.column...end.column]
        return Array(letters)
      }
      
    } else if isVertical {
      
      if start.row > end.row {
        // UP
        let rows = storage[end.row...start.row]
        
        return rows.reversed().compactMap {
          $0[start.column]
        }
        
      } else {
        // DOWN
        let rows = storage[start.row...end.row]
        return rows.compactMap {
          $0[start.column]
        }
      }

    } else if isDiagonal {
      
      var result: [Character] = []
      var column = start.column
      
      if start.row > end.row {
        // UP
        
        let rows = storage[end.row...start.row]
        
        if start.column > end.column {
          // LEFT
          
          for row in rows.reversed() {
            result.append(row[column])
            column -= 1
          }
          
        } else {
          // RIGHT
          
          for row in rows.reversed() {
            result.append(row[column])
            column += 1
          }
        }
        
      } else {
        // DOWN
        let rows = storage[start.row...end.row]
        
        if start.column > end.column {
          // LEFT
          
          for row in rows {
            result.append(row[column])
            column -= 1
          }
          
        } else {
          // RIGHT
          
          for row in rows {
            result.append(row[column])
            column += 1
          }
          
        }
      }
      
      return result
    }
    
    fatalError("should not be able to get here")
  }
  
}
