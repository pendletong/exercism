import gleam/iterator.{iterate, take, reduce}
import gleam/int.{multiply}

pub fn square_of_sum(n: Int) -> Int {
  let assert sos = 
    case iterate(1, fn(a) {a + 1})
    |> take(n)
    |> reduce(fn(acc, el) {
          acc+el
      })
  {
  Ok(s) -> s
Error(_) -> panic
  }

multiply(sos, sos)
}

pub fn sum_of_squares(n: Int) -> Int {
  let assert sos = 
    case iterate(1, fn(a) {a + 1})
    |> take(n)
    |> reduce(fn(acc, el) {
          acc + multiply(el, el)
      })
  {
  Ok(s) -> s
Error(_) -> panic
  }
sos
}

pub fn difference(n: Int) -> Int {
  square_of_sum(n) - sum_of_squares(n)
}
