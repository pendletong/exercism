import gleam/int.{modulo}

pub fn is_leap_year(year: Int) -> Bool {
  case modulo(year, 4),modulo(year, 100),modulo(year, 400) {
    Ok(0),Ok(0),Ok(0) -> True
    Ok(0),Ok(0),_ -> False
    Ok(0),_,_ -> True
    _,_,_ -> False
  }
}
