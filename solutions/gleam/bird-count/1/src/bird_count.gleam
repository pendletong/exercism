import gleam/list

pub fn today(days: List(Int)) -> Int {
  case days {
    [] -> 0
    [first, ..] -> first
  }
}

pub fn increment_day_count(days: List(Int)) -> List(Int) {
  case days {
    [] -> [1]
    [f] -> [f+1]
    [f,..d] -> [f+1,..d]
  }
}

pub fn has_day_without_birds(days: List(Int)) -> Bool {
  case list.find(days, fn(el) {
    el == 0
  }) {
    Ok(_) -> True
    _ -> False
  }
}

pub fn total(days: List(Int)) -> Int {
  list.fold(days, 0, fn(acc, el) {
    acc + el
  })
}

pub fn busy_days(days: List(Int)) -> Int {
  list.fold(days, 0, fn(acc, el) {
    case el >= 5 {
      True -> acc + 1
      False -> acc
    }
  })
}
