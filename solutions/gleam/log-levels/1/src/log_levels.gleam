import gleam/string
import gleam/list



pub fn message(log_line: String) -> String {
    case list.rest(string.split(log_line, ":")) {
      Ok(l) -> l
      _ -> panic
    }

  |> string.join("")
  |> string.trim()
}

pub fn log_level(log_line: String) -> String {
  
    case list.first(string.split(log_line, ":")) {
      Ok(e) -> e
      _ -> panic
    }

  |> string.drop_left(1)
  |> string.drop_right(1)
  |> string.lowercase()
}

pub fn reformat(log_line: String) -> String {
  message(log_line) <> " (" <> log_level(log_line) <> ")"
}
