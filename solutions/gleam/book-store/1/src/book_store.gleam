import gleam/bool
import gleam/int
import gleam/list
import gleam/set.{type Set}

fn calc_cost(books: List(List(Int))) -> Float {
  list.fold(books, 0.0, fn(acc, book_list) { acc +. cost(book_list) })
}

fn cost(book_list: List(Int)) -> Float {
  let discount = case list.length(book_list) {
    2 -> 0.95
    3 -> 0.9
    4 -> 0.8
    5 -> 0.75
    _ -> 1.0
  }
  int.to_float(list.length(book_list) * 800) *. discount
}

fn assign_book(sets: List(Set(Int)), book: Int) -> List(Set(Int)) {
  case sets {
    [] -> [set.from_list([book])]
    [s, ..rest] -> {
      case set.contains(s, book) {
        True -> list.prepend(assign_book(rest, book), s)
        False -> [set.insert(s, book), ..rest]
      }
    }
  }
}

fn group_books(books: List(Int)) -> List(List(Int)) {
  let groups =
    books
    |> list.fold([], assign_book)
    |> list.map(set.to_list)
  // Take any groups with 5 & 3 books and convert to 4 & 4 books
  let num_5 = list.count(groups, fn(l) { list.length(l) == 5 })
  let num_3 = list.count(groups, fn(l) { list.length(l) == 3 })
  case num_5 > 0 && num_3 > 0 {
    True -> {
      let num_3_or_5 =
        list.filter(groups, fn(l) { list.length(l) == 5 || list.length(l) == 3 })
      let others =
        list.filter(groups, fn(l) { list.length(l) != 5 && list.length(l) != 3 })
      list.append(num_3_or_5 |> reduce_groups, others)
    }
    False -> {
      groups
    }
  }
}

fn reduce_groups(list: List(List(Int))) -> List(List(Int)) {
  let num_5 = list.filter(list, fn(l) { list.length(l) == 5 })
  let num_3 = list.filter(list, fn(l) { list.length(l) == 3 })

  do_reduce_groups(num_5, num_3, [])
}

fn do_reduce_groups(
  list_5: List(List(Int)),
  list_3: List(List(Int)),
  acc: List(List(Int)),
) -> List(List(Int)) {
  case list_5, list_3 {
    [], [] -> acc
    [_, ..] as a, [] | [], [_, ..] as a -> list.append(acc, a)
    [i_5, ..rest_5], [i_3, ..rest_3] -> {
      let assert Ok(move) =
        i_5 |> list.find(fn(i) { list.contains(i_3, i) |> bool.negate })
      let i_5 = list.filter(i_5, fn(i) { i != move })
      let i_3 = [move, ..i_3]

      do_reduce_groups(rest_5, rest_3, [i_3, i_5, ..acc])
    }
  }
}

pub fn lowest_price(books: List(Int)) -> Float {
  calc_cost(group_books(books))
}
