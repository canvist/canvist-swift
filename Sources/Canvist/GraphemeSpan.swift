import Foundation

/// UTF-16 lengths of extended grapheme clusters, for `UITextInput`.
///
/// UIKit asks for the character at a point and the character beside a
/// caret. Those are extended grapheme clusters: a base character, its
/// combining marks, a flag, or a joined emoji, not one UTF-16 code unit
/// and not one surrogate pair. A cluster can be longer than the first
/// window of the document, so the window widens until the cluster is
/// whole or the document ends.
enum GraphemeSpan {
  /// The cluster that begins at `start`, in UTF-16 code units. Zero when
  /// `start` is outside the document.
  static func leadingLength(
    at start: Int,
    utf16Length: Int,
    text: (_ start: Int, _ end: Int) -> String
  ) -> Int {
    guard start >= 0, start < utf16Length else { return 0 }

    var end = min(start + Self.firstWindow, utf16Length)

    while true {
      let window = text(start, end)
      let length = min(window.first?.utf16.count ?? 0, utf16Length - start)
      let cutOff = length > 0 && length == window.utf16.count && end < utf16Length

      if !cutOff {
        return length
      }

      let next = min(end + max(end - start, Self.firstWindow), utf16Length)

      if next == end {
        return length
      }

      end = next
    }
  }

  /// The cluster that ends at `end`, in UTF-16 code units. Zero at the
  /// start of the document.
  static func trailingLength(
    endingAt end: Int,
    text: (_ start: Int, _ end: Int) -> String
  ) -> Int {
    guard end > 0 else { return 0 }

    var start = max(end - Self.firstWindow, 0)

    while true {
      let window = text(start, end)
      var last = 0
      var units = 0

      for character in window {
        last = character.utf16.count
        units += last
      }

      last = min(last, end)
      let cutOff = last > 0 && last == units && start > 0

      if !cutOff {
        return last
      }

      let next = max(start - max(end - start, Self.firstWindow), 0)

      if next == start {
        return last
      }

      start = next
    }
  }

  /// Long enough for a surrogate pair, a flag, or a short combining
  /// sequence. Anything longer, such as a family emoji, widens the window.
  private static let firstWindow = 8
}
