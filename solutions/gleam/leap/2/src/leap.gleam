import gleam/int.{modulo}

pub fn is_leap_year(year: Int) -> Bool {
  let assert Ok(mod) = modulo(year, 4)
  let assert Ok(mod2) = modulo(year, 100)
  let assert Ok(mod3) = modulo(year, 400)
  case mod,mod2,mod3 {
    0,0,0 -> True
    0,0,_ -> False
    0,_,_ -> True
    _,_,_ -> False
  }
}
