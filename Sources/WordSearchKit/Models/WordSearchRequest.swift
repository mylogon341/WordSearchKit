//
//  File.swift
//  WordSearchKit
//
//  Created by luke on 23/11/2025.
//

import Foundation

public struct WordSearchRequest {
  let rows: Int
  let columns: Int
  let words: [String]
  
  public init(rows: Int, columns: Int, words: [String]) {
    self.rows = rows
    self.columns = columns
    self.words = words
  }
}
