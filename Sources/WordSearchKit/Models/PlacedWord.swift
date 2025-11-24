//
//  File.swift
//  WordSearchKit
//
//  Created by luke on 23/11/2025.
//

import Foundation

public struct PlacedWord {
  public let word: String
  public let start: (row: Int, col: Int)
  public let direction: Direction
  public let overlapsAnotherWord: Bool
}
