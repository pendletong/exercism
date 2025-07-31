import gleam/option.{type Option, Some}

pub fn two_fer(name: Option(String)) -> String {
  "One for " <> {
    case name {
      Some(name) -> name
      _ -> "you"
    }
  } <> ", one for me."
}
