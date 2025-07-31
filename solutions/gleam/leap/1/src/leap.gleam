import gleam/int.{modulo}

pub fn is_leap_year(year: Int) -> Bool {
  let assert Ok(mod) = modulo(year, 4)
  case mod {
    0 -> {
      let assert Ok(mod2) = modulo(year, 100)
      case mod2 {
        0 -> {
          let assert Ok(mod3) = modulo(year, 400)
          case mod3 {
            0 -> True
            _ -> False
          }
        }
        _ -> True
      }
    }
    _ -> False
  }
}
