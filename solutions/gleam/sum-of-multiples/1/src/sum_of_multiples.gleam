import gleam/iterator
import gleam/int
import gleam/set.{type Set}
import gleam/list

pub fn sum(factors factors: List(Int), limit limit: Int) -> Int {
  
  list.fold(factors, set.new(), fn(points, factor) {
    set.union(points, get_multiples(factor, limit))
  })
  |> set.fold(0, fn(total, factor) {
    total + factor
  })
}

fn get_multiples(factor: Int, limit: Int) -> Set(Int) {
  iterator.iterate(factor, fn(n) { n + factor })
  |> iterator.take({
      let n = limit / factor
      n - case int.modulo(limit, factor) {
        Ok(0) -> 1
        _ -> 0
      }
  })
  |> iterator.to_list
  |> set.from_list
}
