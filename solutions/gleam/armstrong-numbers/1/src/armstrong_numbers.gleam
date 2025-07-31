import gleam/iterator
import gleam/list
import gleam/int



fn fold(len: Int) -> fn(Int, Int) -> Int {
  fn(acc, n) {

  case n {
    0-> acc
    _ -> {

      let assert Ok(p) = {
        iterator.repeat(n)
        |>iterator.take(len)
        |>iterator.reduce(fn(acc,n){acc*n})
      }
  
      acc + p
    }
    }
  }
}


pub fn is_armstrong_number(number: Int) -> Bool {

  let assert Ok(l) = int.digits(number, 10)

  number == list.fold(l, 0, fold(list.length(l)))
}