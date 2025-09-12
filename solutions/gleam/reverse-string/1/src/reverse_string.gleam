import gleam/string

pub fn reverse(value: String) -> String {
  do_reverse(value, "")
}

fn do_reverse(str: String, acc: String) -> String {
  case string.pop_grapheme(str) {
    Error(_) -> acc
    Ok(#(g, rest)) -> do_reverse(rest, g <> acc)
  }
}
