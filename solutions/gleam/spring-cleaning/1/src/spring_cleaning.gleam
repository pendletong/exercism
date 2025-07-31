import gleam/string

pub fn extract_error(problem: Result(a, b)) -> b {
  let assert Error(err) = problem
  err
}

pub fn remove_team_prefix(team: String) -> String {
  let assert "Team " <> t2 = team
  t2
}

pub fn split_region_and_team(combined: String) -> #(String, String) {

  let assert [region, team] = string.split(combined, ",")
  #(region, remove_team_prefix(team))
  
}
