import gleam/int

pub fn secret_add(secret: Int) -> fn(Int) -> Int {
  fn(a: Int) -> Int {
    secret + a
  }
}

pub fn secret_subtract(secret: Int) -> fn(Int) -> Int {
  fn(a: Int) -> Int {
    a - secret
  }
}

pub fn secret_multiply(secret: Int) -> fn(Int) -> Int {
  fn(a: Int) -> Int {
    int.multiply(a, secret)
  }
}

pub fn secret_divide(secret: Int) -> fn(Int) -> Int {
  fn(a: Int) -> Int {
    case int.divide(a, secret) {
      Ok(r) -> r
      _ -> panic
    }
  }
}

pub fn secret_combine(
  secret_function1: fn(Int) -> Int,
  secret_function2: fn(Int) -> Int,
) -> fn(Int) -> Int {
  fn(a: Int) -> Int {
    secret_function2(secret_function1(a))
  }
}
