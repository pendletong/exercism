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

  // method1(d, non_zero)
  method2(d, non_zero)
}

fn method2(
  d: Dict(String, Int),
  non_zero: Set(String),
) -> Result(Dict(String, Int), Nil) {
  let used = list.range(0, 9) |> set.from_list

  do_method2(dict.to_list(d), non_zero, used, 0, dict.new())
}

fn do_method2(
  d: List(#(String, Int)),
  non_zero: Set(String),
  used: Set(Int),
  cur_val: Int,
  result: Dict(String, Int),
) -> Result(Dict(String, Int), Nil) {
  case d, cur_val {
    [], 0 -> Ok(result)
    [], _ -> Error(Nil)
    [#(char, val), ..rest], _ -> {
      list.fold_until(set.to_list(used), Error(Nil), fn(_, i) {
        use <- bool.guard(
          when: i == 0 && set.contains(non_zero, char),
          return: Continue(Error(Nil)),
        )

        case
          do_method2(
            rest,
            non_zero,
            set.delete(used, i),
            cur_val + { val * i },
            dict.insert(result, char, i),
          )
        {
          Error(_) -> Continue(Error(Nil))
          Ok(_) as res -> Stop(res)
        }
      })
    }
  }
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
