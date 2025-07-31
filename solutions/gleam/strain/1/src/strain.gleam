pub fn keep(list: List(t), predicate: fn(t) -> Bool) -> List(t) {
  case list {
    [] -> list
    [f,..rest] -> {
      case predicate(f) {
        True -> [f, ..keep(rest, predicate)]
        False -> keep(rest, predicate)
      }
    }
  }
}

pub fn discard(list: List(t), predicate: fn(t) -> Bool) -> List(t) {
    keep(list, fn(t) {!predicate(t)})
}
