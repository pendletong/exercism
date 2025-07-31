import gleam/string
import gleam/result
import gleam/regex.{type Options}

pub fn hey(remark: String) -> String {
  case string.trim(remark) {
    
    "" -> "Fine. Be that way!"
    remark -> {
      let assert Ok(r) = regex.compile("[A-Z]", regex.Options(case_insensitive: False, multi_line: False))
      let shout = string.uppercase(remark) == remark && regex.check(r, remark)
      case result.unwrap(string.last(remark), "") {
        "?" -> { 
          case shout {
            True -> "Calm down, I know what I'm doing!"
            False -> "Sure."
          }
        }
      
        _ -> {
          case shout {
            True -> "Whoa, chill out!"
            False -> "Whatever."
          }
        }
      }
    }
  }
}
