import gleam/int
import gleam/list
import gleam/string

pub fn score(word: String) -> Int {
  word
  |> string.to_graphemes()
  |> list.map(get_score)
  |> int.sum
}

fn get_score(char) {
  case string.lowercase(char) {
    "a" | "e" | "i" | "o" | "u" | "l" | "r" | "n" | "s" | "t" -> 1
    "d" | "g" -> 2
    "b" | "c" | "m" | "p" -> 3
    "f" | "h" | "v" | "w" | "y" -> 4
    "k" -> 5
    "j" | "x" -> 8
    "q" | "z" -> 10
    _ -> -999_999
  }
}
