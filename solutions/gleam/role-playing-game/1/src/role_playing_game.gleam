import gleam/option.{type Option, Some, None}
import gleam/int

pub type Player {
  Player(name: Option(String), level: Int, health: Int, mana: Option(Int))
}

pub fn introduce(player: Player) -> String {
  case player.name {
    Some(name) -> name
    _ -> "Mighty Magician"
  }
}

pub fn revive(player: Player) -> Option(Player) {
  case player.health {
    0 -> Some(
      case player.level < 10 {
        True -> Player(..player, health: 100, mana: None)        
        False -> Player(..player, health: 100, mana: Some(100))
      }) 
    _ -> None
  }
}

pub fn cast_spell(player: Player, cost: Int) -> #(Player, Int) {
  case player.mana {
    None -> {
      #(Player(..player, health: int.max(player.health - cost, 0)), 0)
    }
    Some(mana) if mana < cost -> #(player, 0)
    Some(mana) -> #(Player(..player, mana: Some(mana - cost)), cost * 2)
  }
}
