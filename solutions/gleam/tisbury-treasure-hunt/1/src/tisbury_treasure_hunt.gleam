import gleam/list

pub fn place_location_to_treasure_location(
  place_location: #(String, Int),
) -> #(Int, String) {
  #(place_location.1, place_location.0)
}

pub fn treasure_location_matches_place_location(
  place_location: #(String, Int),
  treasure_location: #(Int, String),
) -> Bool {
  treasure_location == place_location_to_treasure_location(place_location)
}

pub fn count_place_treasures(
  place: #(String, #(String, Int)),
  treasures: List(#(String, #(Int, String))),
) -> Int {
  list.fold(treasures,0, fn(acc, el) {
      case treasure_location_matches_place_location(place.1, el.1) {
        True -> acc + 1
        False -> acc
      }
  })
}

pub fn special_case_swap_possible(
  found_treasure: #(String, #(Int, String)),
  place: #(String, #(String, Int)),
  desired_treasure: #(String, #(Int, String)),
) -> Bool {
  case found_treasure, place, desired_treasure {
    #("Brass Spyglass", _), _, _ -> True
    #("Amethyst Octopus", _), #("Stormy Breakwater", _), #("Crystal Crab", _) -> True
    #("Amethyst Octopus", _), #("Stormy Breakwater", _), #("Glass Starfish", _) -> True
    #("Vintage Pirate Hat", _), #("Harbor Managers Office", _), #("Model Ship in Large Bottle", _) -> True
    #("Vintage Pirate Hat", _), #("Harbor Managers Office", _), #("Antique Glass Fishnet Float", _) -> True
    _,_,_ -> False
  }
}
