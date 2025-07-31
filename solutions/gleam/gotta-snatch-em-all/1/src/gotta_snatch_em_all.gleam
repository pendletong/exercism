import gleam/set.{type Set}
import gleam/list

pub fn new_collection(card: String) -> Set(String) {
  set.from_list([card])
}

pub fn add_card(collection: Set(String), card: String) -> #(Bool, Set(String)) {
  case set.contains(collection, card){
    True -> #(True, collection)
    False -> #(False, set.insert(collection, card))
  }
}

pub fn trade_card(
  my_card: String,
  their_card: String,
  collection: Set(String),
) -> #(Bool, Set(String)) {
  case set.contains(collection, my_card) {
    False -> #(False, set.insert(collection, their_card))
    True -> case set.contains(collection, their_card) {
      True -> #(False, set.delete(collection, my_card))
      False -> #(True, set.delete(set.insert(collection, their_card), my_card))
    }
  }
}

pub fn boring_cards(collections: List(Set(String))) -> List(String) {
  case list.reduce(collections, set.intersection) {
    Error(_) -> []
    Ok(s) -> set.to_list(s)
  }

}

pub fn total_cards(collections: List(Set(String))) -> Int {
  case list.reduce(collections, set.union) {
    Error(_) -> 0
    Ok(s) -> set.size(s)
  }
}

pub fn shiny_cards(collection: Set(String)) -> Set(String) {
  set.fold(collection, set.new(), fn(s, card) {
    case card {
      "Shiny " <> _ -> set.insert(s, card)
      _ -> s
    }
  })
}
