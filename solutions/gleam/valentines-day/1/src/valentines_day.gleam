// TODO: please define the 'Approval' custom type
pub type Approval {
  Yes
  No
  Maybe
}

// TODO: please define the 'Cuisine' custom type
pub type Cuisine {
  Korean
  Turkish
}

// TODO: please define the 'Genre' custom type
pub type Genre {
  Crime
  Horror
  Romance
  Thriller
}

// TODO: please define the 'Activity' custom type
pub type Activity {
  BoardGame
  Chill
  Movie(genre: Genre)
  Restaurant(cuisine: Cuisine)
  Walk(km: Int)
}

pub fn rate_activity(activity: Activity) -> Approval {
  case activity {
    Movie(Romance) -> Yes
    Restaurant(Korean) -> Yes
    Restaurant(_) -> Maybe
    Walk(km) -> {
      case km {
        _ if km > 11 -> Yes
        _ if km > 6 -> Maybe
        _ -> No
      }
    }
    _ -> No
  }
}
