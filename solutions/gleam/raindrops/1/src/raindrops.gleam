import gleam/int.{modulo, to_string}

pub fn convert(number: Int) -> String {
  let s = case modulo(number, 3) {
    Ok(0) -> "Pling"
    _ -> ""
  } <>
  case modulo(number, 5) {
    Ok(0) -> "Plang"
    _ -> ""
  } <>
  case modulo (number, 7) {
    Ok(0) -> "Plong"
    _ -> ""
  }

  case s {
    "" -> to_string(number)
    s -> s
  }
}
