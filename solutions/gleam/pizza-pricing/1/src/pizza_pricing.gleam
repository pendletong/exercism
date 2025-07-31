// TODO: please define the Pizza custom type

pub type Pizza {
  Margherita
  Caprese
  Formaggio
  ExtraSauce(Pizza)
  ExtraToppings(Pizza)
}

pub fn pizza_price(pizza: Pizza) -> Int {
  case pizza {
    Margherita -> 7
    Caprese -> 9
    Formaggio -> 10
    ExtraSauce(p) -> 1 + pizza_price(p)
    ExtraToppings(p) -> 2 + pizza_price(p)
  }
}

pub fn order_price(order: List(Pizza)) -> Int {
  sum_pizzas(order, case order {
      [_] -> 3
      [_,_] -> 2
      _ -> 0
    })
    
}

fn sum_pizzas(pizzas: List(Pizza), total: Int) -> Int {
  case pizzas {
    [] -> total
    [pizza, ..rest] -> {
      let total = total + pizza_price(pizza)
      sum_pizzas(rest, total)
    }
  }
}
