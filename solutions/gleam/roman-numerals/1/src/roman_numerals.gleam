import gleam/iterator
import gleam/list.{Continue, Stop}

pub fn convert(number: Int) -> String {

  iterator.fold_until(
    iterator.iterate(#("", number), fn(i) {
      let next = next_numeral(i.1)
      #(i.0<>next.0, next.1)
    }),
    "",
    fn(_r, a) {
    //io.debug(r)
    //io.debug(a)
      case a.1 {
         0 -> Stop(a.0)
         _ -> Continue(a.0) 
      }
    }
  )


}

fn next_numeral(number: Int) -> #(String, Int) {
  case number {
    n if n >= 1000 -> #("M", number - 1000)
    n if n >= 900 -> #("CM", number - 900)
    n if n >= 500 -> #("D", number - 500)
    n if n >= 400 -> #("CD", number - 400)
    n if n >= 100 -> #("C", number - 100)
    n if n >= 90 -> #("XC", number - 90)
    n if n >= 50 -> #("L", number - 50)
    n if n >= 40 -> #("XL", number - 40)
    n if n >= 10 -> #("X", number - 10)
    n if n >= 9 -> #("IX", number - 9)
    n if n >= 5 -> #("V", number - 5)
    n if n >= 4 -> #("IV", number - 4)
    n if n >= 1 -> #("I", number - 1)
    _ -> #("", number)
  }
}