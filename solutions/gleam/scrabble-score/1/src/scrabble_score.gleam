import gleam/int
import gleam/string

pub fn score(word: String) -> Int {
  do_score(word, 0)
}

fn do_score(word, score) -> Int {
  case string.pop_grapheme(word) {
    Error(_) -> score
    Ok(#(char, rest)) -> {
      let val = case string.lowercase(char) {
        "a" | "e" | "i" | "o" | "u" | "l" | "r" | "n" | "s" | "t" -> 1
        "d" | "g" -> 2
        "b" | "c" | "m" | "p" -> 3
        "f" | "h" | "v" | "w" | "y" -> 4
        "k" -> 5
        "j" | "x" -> 8
        "q" | "z" -> 10
        _ -> -999_999
      }
      do_score(rest, val + score)
    }
  }
}
