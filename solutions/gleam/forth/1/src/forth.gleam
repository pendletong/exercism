import gleam/bool
import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/string

pub type Forth {
  Forth(stack: List(Int), fns: Dict(String, List(Cmd)))
}

pub type Cmd {
  PushStack(i: Int)
  Def(String, List(Cmd))
  Exec(String, Dict(String, List(Cmd)))
  Plus
  Minus
  Divide
  Multiply
  Dup
  Drop
  Swap
  Over
}

pub type ForthError {
  DivisionByZero
  StackUnderflow
  InvalidWord
  UnknownWord
}

pub fn new() -> Forth {
  Forth([], dict.new())
}

pub fn format_stack(f: Forth) -> String {
  f.stack |> list.reverse |> list.map(int.to_string) |> string.join(" ")
}

pub fn eval(f: Forth, prog: String) -> Result(Forth, ForthError) {
  use prog <- result.try(lex_parse(f, prog, #("", [])))
  execute(f, prog |> list.reverse)
}

fn execute(f: Forth, prog: List(Cmd)) -> Result(Forth, ForthError) {
  case prog {
    [] -> Ok(f)
    [cmd, ..rest] -> {
      use f <- result.try(execute_cmd(f, cmd))

      execute(f, rest)
    }
  }
}

fn execute_cmd(f: Forth, cmd: Cmd) -> Result(Forth, ForthError) {
  use f2 <- result.try(execute_def_fn(f, cmd))

  case f2 {
    None -> {
      case cmd {
        Divide ->
          process_two_nums(f, fn(i1, i2) {
            int.divide(i2, i1) |> result.replace_error(DivisionByZero)
          })
        Drop -> {
          use #(_, stack) <- result.try(pop(f.stack))
          Ok(Forth(..f, stack:))
        }
        Dup -> {
          use #(i, _) <- result.try(pop(f.stack))
          let stack = f.stack |> push(i)
          Ok(Forth(..f, stack:))
        }
        Minus -> process_two_nums(f, fn(i1, i2) { Ok(i2 - i1) })
        Multiply -> process_two_nums(f, fn(i1, i2) { Ok(i2 * i1) })
        Over -> {
          use #(_, stack) <- result.try(pop(f.stack))
          use #(i1, _) <- result.try(pop(stack))
          let stack = f.stack |> push(i1)
          Ok(Forth(..f, stack:))
        }
        Plus -> process_two_nums(f, fn(i1, i2) { Ok(i2 + i1) })
        Swap -> {
          use #(i1, stack) <- result.try(pop(f.stack))
          use #(i2, stack) <- result.try(pop(stack))
          let stack = stack |> push(i1) |> push(i2)
          Ok(Forth(..f, stack:))
        }
        PushStack(i:) -> Ok(Forth(..f, stack: push(f.stack, i)))
        Exec(_, _) -> Error(UnknownWord)
        Def(name, cmds) ->
          Ok(Forth(..f, fns: dict.insert(f.fns, name, cmds |> list.reverse)))
      }
    }
    Some(f) -> Ok(f)
  }
}

fn process_two_nums(
  f: Forth,
  c: fn(Int, Int) -> Result(Int, ForthError),
) -> Result(Forth, ForthError) {
  use #(#(n1, n2), stack) <- result.try(pop_two_numbers(f.stack))

  use r <- result.try(c(n1, n2))

  Ok(Forth(..f, stack: [r, ..stack]))
}

fn pop_two_numbers(
  stack: List(Int),
) -> Result(#(#(Int, Int), List(Int)), ForthError) {
  use #(n1, stack) <- result.try(pop(stack))
  use #(n2, stack) <- result.try(pop(stack))

  Ok(#(#(n1, n2), stack))
}

fn execute_def_fn(f: Forth, cmd: Cmd) {
  let #(cmd, fns) = case cmd {
    Exec(name, fns) -> {
      #(Some(name), fns)
    }
    _ -> {
      #(cmd_to_str(cmd), f.fns)
    }
  }
  case cmd {
    Some(cmd) -> {
      case dict.get(fns, cmd) {
        Ok(cmds) -> {
          use res <- result.try(execute(f, cmds))
          Ok(Some(res))
        }
        Error(_) -> {
          Ok(None)
        }
      }
    }
    None -> {
      Ok(None)
    }
  }
}

fn cmd_to_str(cmd: Cmd) -> Option(String) {
  case cmd {
    Divide -> Some("/")
    Drop -> Some("drop")
    Dup -> Some("dup")
    Minus -> Some("-")
    Multiply -> Some("*")
    Over -> Some("over")
    Plus -> Some("+")
    Swap -> Some("swap")
    Exec(_, _) -> None
    _ -> None
  }
}

fn lex_parse(
  f: Forth,
  prog: String,
  cur: #(String, List(Cmd)),
) -> Result(List(Cmd), ForthError) {
  let #(cmd, cmds) = cur
  case prog {
    "" -> {
      case cmd {
        "" -> Ok(cmds)
        _ -> {
          use word <- result.try(parse_word(f, cmd, cmds))
          case word, cmds {
            Def("", []), _ -> Ok([word, ..cmds])
            Def(_, _), [Def(_, _), ..cmds] -> Ok([word, ..cmds])
            _, _ -> Ok([word, ..cmds])
          }
        }
      }
    }
    " " <> rest -> {
      use word <- result.try(parse_word(f, cmd, cmds))
      case word, cmds {
        Def("", []), _ -> lex_parse(f, rest, #("", [word, ..cmds]))
        Def(_, _), [Def(_, _), ..cmds] ->
          lex_parse(f, rest, #("", [word, ..cmds]))
        _, _ -> lex_parse(f, rest, #("", [word, ..cmds]))
      }
    }
    _ -> {
      let assert Ok(#(char, rest)) = string.pop_grapheme(prog)
      lex_parse(f, rest, #(cmd <> char, cmds))
    }
  }
}

fn parse_word(
  f: Forth,
  word: String,
  cmds: List(Cmd),
) -> Result(Cmd, ForthError) {
  let is_num = int.parse(word)
  let word = string.lowercase(word)
  case cmds {
    [Def(name, cmds) as cmd, ..] -> {
      case name {
        "" -> {
          use <- bool.guard(
            when: result.is_ok(is_num),
            return: Error(InvalidWord),
          )
          Ok(Def(word, []))
        }
        _ -> {
          use <- bool.guard(when: word == ";", return: Ok(cmd))
          use cmd <- result.try(parse_word(f, word, []))
          Ok(Def(name, [cmd, ..cmds]))
        }
      }
    }
    _ -> {
      case word {
        "+" -> Ok(Plus)
        "-" -> Ok(Minus)
        "/" -> Ok(Divide)
        "*" -> Ok(Multiply)
        "dup" -> Ok(Dup)
        "drop" -> Ok(Drop)
        "swap" -> Ok(Swap)
        "over" -> Ok(Over)
        ":" -> Ok(Def("", []))
        word -> {
          case is_num {
            Ok(num) -> Ok(PushStack(num))
            _ -> Ok(Exec(word, f.fns))
          }
        }
      }
    }
  }
}

fn push(l: List(Int), i: Int) -> List(Int) {
  [i, ..l]
}

fn pop(l: List(Int)) -> Result(#(Int, List(Int)), ForthError) {
  case l {
    [] -> Error(StackUnderflow)
    [i, ..rest] -> Ok(#(i, rest))
  }
}
