import gleam/result
pub type Player {
  Black
  White
}

pub type Game {
  Game(
    white_captured_stones: Int,
    black_captured_stones: Int,
    player: Player,
    error: String,
  )
}

pub fn apply_rules(
  game: Game,
  rule1: fn(Game) -> Result(Game, String),
  rule2: fn(Game) -> Game,
  rule3: fn(Game) -> Result(Game, String),
  rule4: fn(Game) -> Result(Game, String),
) -> Game {
  case result.try(Ok(game), rule1)
  |> result.try(fn(a) {
    Ok(rule2(a))
  })
  |> result.try(rule3)
  |> result.try(rule4)
  {
    Error(e) -> Game(..game, error: e)
    Ok(new_game) -> Game(..new_game, player: {
      case game.player {
        Black->White
        White->Black
      }
    })
  }
}
