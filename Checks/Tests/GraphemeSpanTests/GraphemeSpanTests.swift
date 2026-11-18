import XCTest

@testable import GraphemeSpan

/// `UITextInput` character ranges are extended grapheme clusters. A family
/// emoji, a flag, or a combining sequence is one character even when it is
/// more than two UTF-16 code units, which is all a fixed window of two
/// would see.
final class GraphemeSpanTests: XCTestCase {
  func testLeadingLengthOfAnAsciiCharacterIsOne() {
    let text = "ab"

    XCTAssertEqual(length(leading: text, at: 0), 1)
    XCTAssertEqual(length(leading: text, at: 1), 1)
  }

  func testLeadingLengthAtTheEndIsZero() {
    XCTAssertEqual(length(leading: "ab", at: 2), 0)
    XCTAssertEqual(length(leading: "ab", at: 3), 0)
    XCTAssertEqual(length(leading: "", at: 0), 0)
  }

  func testLeadingLengthCoversACombiningSequence() {
    let text = "e\u{0301}"

    XCTAssertEqual(text.count, 1)
    XCTAssertEqual(text.utf16.count, 2)
    XCTAssertEqual(length(leading: text, at: 0), 2)
  }

  func testLeadingLengthCoversAFlagAndACarriageReturnLineFeed() {
    XCTAssertEqual("🇺🇸".count, 1)
    XCTAssertEqual(length(leading: "🇺🇸", at: 0), 4)
    XCTAssertEqual("\r\n".count, 1)
    XCTAssertEqual(length(leading: "\r\n", at: 0), 2)
  }

  func testLeadingLengthCoversAFamilyEmojiLongerThanOneWindow() {
    let emoji = "👨‍👩‍👧‍👦"
    XCTAssertEqual(emoji.count, 1)
    XCTAssertGreaterThan(emoji.utf16.count, 8, "longer than the first window")

    XCTAssertEqual(length(leading: emoji, at: 0), emoji.utf16.count)
  }

  func testLeadingLengthStopsAtTheCharacterAfterAFamilyEmoji() {
    let text = "👨‍👩‍👧‍👦!"
    let emoji = "👨‍👩‍👧‍👦".utf16.count

    XCTAssertEqual(length(leading: text, at: emoji), 1)
  }

  func testTrailingLengthIsTheClusterThatEndsAtTheOffset() {
    let emoji = "👨‍👩‍👧‍👦"
    let text = "Hi \(emoji)"
    let end = text.utf16.count

    XCTAssertEqual(length(trailing: text, endingAt: end), emoji.utf16.count)
    XCTAssertEqual(length(trailing: text, endingAt: 3), 1, "the space before the emoji")
    XCTAssertEqual(length(trailing: "a\r\n", endingAt: 3), 2)
    XCTAssertEqual(length(trailing: text, endingAt: 0), 0)
  }

  func testSpansStayInsideTheDocument() {
    let text = "👨‍👩‍👧‍👦"
    var requests: [(Int, Int)] = []

    let leading = GraphemeSpan.leadingLength(at: 0, utf16Length: text.utf16.count) { start, end in
      requests.append((start, end))
      return slice(text, start, end)
    }
    let trailing = GraphemeSpan.trailingLength(endingAt: text.utf16.count) { start, end in
      requests.append((start, end))
      return slice(text, start, end)
    }

    XCTAssertEqual(leading, text.utf16.count)
    XCTAssertEqual(trailing, text.utf16.count)
    XCTAssertFalse(requests.isEmpty)
    for (start, end) in requests {
      XCTAssertGreaterThanOrEqual(start, 0)
      XCTAssertLessThanOrEqual(end, text.utf16.count)
      XCTAssertLessThanOrEqual(start, end)
    }
  }

  private func length(leading text: String, at start: Int) -> Int {
    GraphemeSpan.leadingLength(at: start, utf16Length: text.utf16.count) { start, end in
      slice(text, start, end)
    }
  }

  private func length(trailing text: String, endingAt end: Int) -> Int {
    GraphemeSpan.trailingLength(endingAt: end) { start, end in
      slice(text, start, end)
    }
  }

  /// The UTF-16 slice `text` would return for `start..<end`.
  private func slice(_ text: String, _ start: Int, _ end: Int) -> String {
    let utf16 = text.utf16
    let lower = utf16.index(utf16.startIndex, offsetBy: start)
    let upper = utf16.index(utf16.startIndex, offsetBy: end)

    return String(decoding: utf16[lower..<upper], as: UTF16.self)
  }
}
