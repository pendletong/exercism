import gleam/float
import gleam/list
import gleam/order.{Gt}

const dist_to_scores = [#(1.0, 10), #(5.0, 5), #(10.0, 1)]

fn find_score(dist: Float) -> Int {
  case list.find(dist_to_scores, fn(s) {
    case float.compare(dist, s.0) {
      Gt -> False
      _ -> True
    }
  }) {
    Error(_) -> 0
    Ok(#(_,s)) -> s
  }
}
pub fn score(x: Float, y: Float) -> Int {
  case float.square_root(x*.x+.y*.y) {
    Error(_) -> 0
    Ok(n) -> find_score(n)
  }
}
