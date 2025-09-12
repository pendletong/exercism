import gleam/bool
import gleam/dict.{type Dict}
import gleam/list.{Continue, Stop}
import gleam/option.{None, Some}
import gleam/set.{type Set}
import gleam/string

pub fn solve(puzzle: String) -> Result(Dict(String, Int), Nil) {
  let #(stack1, non_zero, rest) = to_stack(puzzle, #("", dict.new(), set.new()))
  let #(stack2, non_zero, _) = to_stack(rest, #("", dict.new(), non_zero))

  let d =
    dict.fold(stack2, stack1, fn(acc, k, v) {
      dict.upsert(acc, k, fn(x) {
        case x {
          Some(i) -> i - v
          None -> -v
        }
      })
    })
  let combinations =
    list.combinations([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], dict.size(d))
  let keys = dict.keys(d)
  let ignores =
    list.index_fold(keys, set.new(), fn(acc, k, i) {
      case set.contains(non_zero, k) {
        True -> set.insert(acc, i)
        False -> acc
      }
    })
  list.fold_until(combinations, Error(Nil), fn(_, c) {
    case try_combination(d, keys, ignores, non_zero, c) {
      Error(_) as e -> Continue(e)
      Ok(_) as r -> Stop(r)
    }
  })
}

fn try_combination(
  d: Dict(String, Int),
  keys: List(String),
  ignores: Set(Int),
  non_zero: Set(String),
  combination: List(Int),
) -> Result(Dict(String, Int), Nil) {
  let permutations =
    list.permutations(combination)
    |> list.filter(fn(p) {
      list.fold_until(p, #(True, 0), fn(acc, i) {
        case i == 0 {
          True -> {
            case set.contains(ignores, acc.1) {
              True -> {
                Stop(#(False, 0))
              }
              False -> Stop(#(True, 0))
            }
          }
          False -> Continue(#(True, acc.1 + 1))
        }
      }).0
    })
  list.fold_until(permutations, None, fn(_, c) {
    let vals =
      list.zip(keys, c)
      |> dict.from_list
    use <- bool.guard(
      when: set.fold(non_zero, False, fn(b, char) {
        case dict.get(vals, char) {
          Ok(0) -> True || b
          _ -> b || False
        }
      }),
      return: Continue(None),
    )

    case calculate(d, vals) {
      0 -> Stop(Some(vals))
      _ -> Continue(None)
    }
  })
  |> option.to_result(Nil)
}

fn calculate(d: Dict(String, Int), vals: Dict(String, Int)) -> Int {
  dict.fold(d, 0, fn(acc, k, v) {
    let assert Ok(n) = dict.get(vals, k)

    n * v + acc
  })
}

fn to_stack(
  str: String,
  acc: #(String, Dict(String, Int), Set(String)),
) -> #(Dict(String, Int), Set(String), String) {
  case str {
    "" -> add_el(acc.0, acc.1, acc.2, "")
    " + " <> rest -> {
      let #(d, s, _) = add_el(acc.0, acc.1, acc.2, rest)
      to_stack(rest, #("", d, s))
    }
    " == " <> rest -> {
      add_el(acc.0, acc.1, acc.2, rest)
    }
    _ -> {
      let assert Ok(#(char, rest)) = string.pop_grapheme(str)
      to_stack(rest, #(acc.0 <> char, acc.1, acc.2))
    }
  }
}

fn add_el(
  el: String,
  d: Dict(String, Int),
  s: Set(String),
  rest: String,
) -> #(Dict(String, Int), Set(String), String) {
  let assert Ok(#(c, _)) = string.pop_grapheme(el)
  #(process_el(el |> string.reverse, #(d, 1)), set.insert(s, c), rest)
}

fn process_el(el: String, acc: #(Dict(String, Int), Int)) -> Dict(String, Int) {
  case string.pop_grapheme(el) {
    Ok(#(char, rest)) -> {
      let d =
        dict.upsert(acc.0, char, fn(x) {
          case x {
            Some(i) -> i + acc.1
            None -> acc.1
          }
        })
      process_el(rest, #(d, acc.1 * 10))
    }
    Error(_) -> acc.0
  }
}

pub fn main() {
  solve("AND + A + STRONG + OFFENSE + AS + A + GOOD == DEFENSE") |> echo
}
