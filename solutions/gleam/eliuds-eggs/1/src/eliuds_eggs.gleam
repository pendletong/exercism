import gleam/iterator.{iterate, fold_until}
import gleam/list.{Continue, Stop}
import gleam/int

pub fn egg_count(number: Int) -> Int {
  let it = iterate(number, fn(i: Int) -> Int {
    case int.divide(i, 2) {
      Ok(h) -> h
      _ -> panic
    }
  })

  fold_until(it, 0, fn(eggs, cur_it) {
    case cur_it {
      0 -> Stop(eggs)
      n -> case int.modulo(n, 2) {
        Ok(1) -> Continue(eggs + 1)
        _ -> Continue(eggs)
      }
    }
  })
}
