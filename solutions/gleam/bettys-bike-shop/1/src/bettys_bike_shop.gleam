// TODO: import the `gleam/int` module
// TODO: import the `gleam/float` module
// TODO: import the `gleam/string` module
import gleam/float
import gleam/string
import gleam/int

pub fn pence_to_pounds(pence: Int) -> Float {
  let assert pounds = {
    case float.divide(int.to_float(pence), 100.0)
{
Ok(p) -> p
Error(e) -> panic
}
  }
  pounds
}

pub fn pounds_to_string(pounds: Float) -> String {
  "£" <> float.to_string(pounds)
}
