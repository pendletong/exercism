import gleam/string
import gleam/list
import gleam/dict.{type Dict}
import gleam/option.{type Option, Some, None}
import gleam/order.{Eq}
import gleam/int

type Results {
  Results(win: Int, draw: Int, lose: Int)
}

fn update_win(result: Option(Results)) -> Results {
  case result {
    None -> Results(1,0,0)
    Some(r) -> Results(..r, win: r.win+1)
  }
}

fn update_lose(result: Option(Results)) -> Results {
  case result {
    None -> Results(0,0,1)
    Some(r) -> Results(..r, lose: r.lose+1)
  }
}

fn update_draw(result: Option(Results)) -> Results {
  case result {
    None -> Results(0,1,0)
    Some(r) -> Results(..r, draw: r.draw+1)
  }
}

fn process_result(table: Dict(String, Results), result: String) -> Dict(String, Results) {
  
  case string.split(result, ";") {
    [""] -> table
    [a,b,"win"] -> {
      dict.update(dict.update(table, b, update_lose), a, update_win)
    }
    [a,b,"loss"] -> {
      dict.update(dict.update(table, b, update_win), a, update_lose)
    }
    [a,b,"draw"] -> {
      dict.update(dict.update(table, b, update_draw), a, update_draw)
    }
    _ -> panic
  }  
}

fn get_points(res: Results) -> Int {
  res.win*3 + res.draw
}

fn get_games(res: Results) -> Int {
  res.win + res.draw + res.lose
}



fn output_team(team: #(String, Results)) -> String {
  let #(name, res) = team

    string.pad_right(name, 30, " ")
<> " | " <> string.pad_left(int.to_string(get_games(res)), 2, " ")
<> " | " <> string.pad_left(int.to_string(res.win), 2, " ")
<> " | " <> string.pad_left(int.to_string(res.draw) , 2, " ")
<> " | " <> string.pad_left(int.to_string(res.lose) , 2, " ")
<> " | " <> string.pad_left(int.to_string(get_points(res)) , 2, " ")
}

pub fn tally(input: String) -> String {
  let table: Dict(String, Results) = dict.new()


  string.split(input, "\n")
  |> list.fold(table, process_result)
  |> dict.to_list
  |> list.sort(fn(t1, t2) {
    case int.compare(get_points(t2.1), get_points(t1.1))
    {
      Eq -> string.compare(t1.0, t2.0)
      c -> c
    }
  })
  |> list.map(output_team)
  |> list.prepend("Team                           | MP |  W |  D |  L |  P")
  |> string.join("\n")
}
