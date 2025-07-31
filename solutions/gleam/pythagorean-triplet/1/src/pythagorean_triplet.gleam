import gleam/iterator
import gleam/int.{multiply}


pub type Triplet {
  Triplet(Int, Int, Int)
}

pub fn triplets_with_sum(sum: Int) -> List(Triplet) {
  iterator.range(sum / 3, 1)
  |> iterator.fold(from: [], with:fn(acc, a) {
    iterator.filter(iterator.range({sum - a} / 2, a), fn(b) {
      let c = sum - a - b
      multiply(a, a) + multiply(b, b) == multiply(c, c)
    })
    |> iterator.fold(acc, fn(acc2, b) {
      [Triplet(a, b, sum - a - b), ..acc2]
    })
  })
  
}
