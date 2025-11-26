//
//  File.swift
//  WordSearchKit
//
//  Created by luke on 23/11/2025.
//

internal struct Delta {
  let row: Int
  let column: Int
  
  init(_ row: Int, _ column: Int) {
    self.row = row
    self.column = column
  }
}

public enum Direction: CaseIterable {
  case up
  case down
  case left
  case right
  case diagUpLeft
  case diagUpRight
  case diagDownLeft
  case diagDownRight
  
  internal var delta: Delta {
    switch self {
    case .up:            .init(-1,  0)
    case .down:          .init( 1,  0)
    case .left:          .init( 0, -1)
    case .right:         .init( 0,  1)
    case .diagUpLeft:    .init(-1, -1)
    case .diagUpRight:   .init(-1,  1)
    case .diagDownLeft:  .init( 1, -1)
    case .diagDownRight: .init( 1,  1)
    }
  }
}

