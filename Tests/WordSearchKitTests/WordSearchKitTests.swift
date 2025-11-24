import Testing
import Foundation
@testable import WordSearchKit

@Test func defaultConfigGrid() async throws {

  let grid = try WordSearchKit.generate(.init(
    rows: 10,
    columns: 10,
    words: ["the"]
  ))
  
  #expect(grid.placedWords.count == 1)
  #expect(grid.placedWords.first?.word == "THE")
  dump(grid.placedWords)
}

@Test func unmodifiedConfigGrid() async throws {
  
  let grid = try WordSearchKit.generate(
    .init(
      rows: 3,
      columns: 3,
      words: ["the"]
    ),
    config: .init(uppercaseEverything: false)
  )
  
  #expect(grid.placedWords.count == 1)
  #expect(grid.placedWords.first?.word == "the")

  dump(grid)
}

@Test func lotsOfOverlapping() async throws {
  let grid = try WordSearchKit.generate(
    .init(
      rows: 2,
      columns: 2,
      words: ["aa", "aa", "aa", "aa"]
    )
  )
  
  #expect(
    grid
      .placedWords
      .compactMap(\.overlapsAnotherWord)
      .allSatisfy({$0})
  )
  
}

@Test func moreWordsFitting() async throws {
  
  let grid = try WordSearchKit.generate(.init(
    rows: 5,
    columns: 5,
    words: ["the", "meh"]
  ))
  
  #expect(grid.placedWords.count == 2)
  print(grid.description)
}

@Test func errorOnWordsOverlapping() async {
  do {
    
    _ = try WordSearchKit.generate(
      .init(
        rows: 2,
        columns: 2,
        words: ["aa", "aa", "aa"]
      ),
      config: .init(allowOverlaps: false)
    )
    
    Issue.record("Expected to throw but it didn't")
  } catch {
    print("successfully threw an error")
  }
}

@Test func errorOnImpossibleWordPlacement() async {
  do {
    
    _ = try WordSearchKit.generate(.init(
      rows: 2,
      columns: 2,
      words: ["aaaa"]
    ))
    
    Issue.record("Expected to throw but it didn't")
  } catch {
    print("successfully threw an error")
  }
}
