import gleam/regex
import gleam/list
import gleam/option.{Some}

pub fn is_valid_line(line: String) -> Bool {
  let assert Ok(re) = regex.from_string("^\\[(DEBUG|INFO|WARNING|ERROR)\\]")
  regex.check(re, line)
}

pub fn split_line(line: String) -> List(String) {
  let assert Ok(re) = regex.from_string("<[~*=-]*>")
  regex.split(re, line)
}

pub fn tag_with_user_name(line: String) -> String {
  let assert Ok(re) = regex.from_string("User\\s*([^\\s]+)")
  case regex.scan(re, line) {
    [] -> line
    [m, ..] -> {
      let assert Ok(Some(user)) = list.first(m.submatches)
      "[USER] " <> user <> " " <> line
    }
  }
}
