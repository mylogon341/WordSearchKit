import Testing
import Foundation
@testable import WordSearchKit

var testGrid: Grid {
  Grid(storage: [
    ["A", "B", "C"],
    ["D", "E", "F"],
    ["G", "H", "I"]
  ])
}

@Test func defaultConfigGrid() async throws {

  let grid = try WordSearchKit.generate(.init(
    rows: 10,
    columns: 10,
    words: ["the"]
  ))
  
  #expect(grid.placedWords.count == 1)
  #expect(grid.placedWords.first?.word == "THE")
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
}

@Test func testMoreWordsFitting() async throws {
  
  let grid = try WordSearchKit.generate(.init(
    rows: 5,
    columns: 5,
    words: ["the", "meh"]
  ))
  
  #expect(grid.placedWords.count == 2)
  print(grid.description)
}

@Test func testErrorOnWordsOverlapping() async {
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

@Test func testAllPoints() throws {
  
  let grid = try WordSearchKit.generate(
    .init(
      rows: 1,
      columns: 2,
      words: ["ab"]
    )
  )
  
  print(grid.description)
  print("rows: \(grid.rows)\ncols: \(grid.columns)")
  
  
  guard let word = grid.placedWords.first else {
    Issue.record("no word found")
    return
  }
  
  let points = word.allPoints
  print("points: \(points)")
  
  #expect(points.count == 2)
  
  let point1 = GridPoint(row: 0, column: 0)
  let point2 = GridPoint(row: 0, column: 1)
  
  #expect(points.contains(where: { $0 == point1 }))
  #expect(points.contains(where: { $0 == point2 }))
}

@Test func testAnswerCheckDirectionInsensitive() throws {
  
  var grid = testGrid
  grid.addPlacedWord(.init(word: "ABC",
                           start: .init(row: 0, column: 0),
                           direction: .right))
  
  let found = WordSearchKit.checkPoints(grid: grid,
                                        start: .init(row: 0, column: 2),
                                        end: .init(row: 0, column: 0))
  
  #expect(found?.word == "ABC")
}

@Test func testAnswerCheckDirectionSensitive() throws {
  
  var grid = testGrid
  grid.addPlacedWord(.init(word: "ABC",
                           start: .init(row: 0, column: 0),
                           direction: .right))
  
  let found = WordSearchKit.checkPoints(grid: grid,
                                        start: .init(row: 0, column: 2),
                                        end: .init(row: 0, column: 0),
                                        directionSensitive: true)
  
  #expect(found?.word == nil)
}

@Test func testStartEndReturnValuesRight() throws {
  
  let found = try WordSearchKit.returnLettersBetweenPoints(grid: testGrid,
                                                                start: .init(row: 0, column: 0),
                                                                end: .init(row: 0, column: 2))
  
  #expect(found == ["A", "B", "C"])
  
}

@Test func testStartEndReturnValuesLeft() throws {

  let found = try WordSearchKit.returnLettersBetweenPoints(grid: testGrid,
                                                               start: .init(row: 0, column: 2),
                                                               end: .init(row: 0, column: 0))
  
  #expect(found == ["C", "B", "A"])
}

@Test func testStartEndReturnValuesDown() throws {
  
  let foundDown = try WordSearchKit.returnLettersBetweenPoints(grid: testGrid,
                                                               start: .init(row: 0, column: 1),
                                                               end: .init(row: 2, column: 1))
  
  #expect(foundDown == ["B", "E", "H"])
}

@Test func testStartEndReturnValuesUp() throws {

  let foundUp = try WordSearchKit.returnLettersBetweenPoints(grid: testGrid,
                                                             start: .init(row: 2, column: 1),
                                                             end: .init(row: 0, column: 1))
  
  #expect(foundUp == ["H", "E", "B"])
}

@Test func testStartEndReturnValuesDiagonalDownRight() throws {
  
  let found = try WordSearchKit.returnLettersBetweenPoints(grid: testGrid,
                                                           start: .init(row: 0, column: 0),
                                                           end: .init(row: 2, column: 2))
  
  #expect(found == ["A", "E", "I"])
}

@Test func testStartEndReturnValuesDiagonalDownLeft() throws {
  
  let found = try WordSearchKit.returnLettersBetweenPoints(grid: testGrid,
                                                           start: .init(row: 0, column: 2),
                                                           end: .init(row: 2, column: 0))
  
  #expect(found == ["C", "E", "G"])
}

@Test func testStartEndReturnValuesDiagonalUpRight() throws {
  
  let found = try WordSearchKit.returnLettersBetweenPoints(grid: testGrid,
                                                           start: .init(row: 2, column: 0),
                                                           end: .init(row: 0, column: 2))
  
  #expect(found == ["G", "E", "C"])
}

@Test func testStartEndReturnValuesDiagonalUpLeft() throws {
  
  let found = try WordSearchKit.returnLettersBetweenPoints(grid: testGrid,
                                                           start: .init(row: 2, column: 2),
                                                           end: .init(row: 0, column: 0))
  
  #expect(found == ["I", "E", "A"])
}
