import gleam/list
import gleam/int

pub type Allergen {
  Eggs//1
  Peanuts//2
  Shellfish//4
  Strawberries//8
  Tomatoes//16
  Chocolate//32
  Pollen//64
  Cats//128
}

const allergens = [#(128,Cats),#(64,Pollen),#(32,Chocolate),#(16,Tomatoes),#(8,Strawberries),#(4,Shellfish),#(2,Peanuts),#(1,Eggs)]

pub fn allergic_to(allergen: Allergen, score: Int) -> Bool {
  list.contains(list(score), allergen)
}

pub fn list(score: Int) -> List(Allergen) {
  list.fold(allergens, [], fn(acc, al) {
    case int.bitwise_and(score, al.0) == al.0 {
      True -> [al.1, ..acc]
      False -> acc
    }
  })
}
