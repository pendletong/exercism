import gleam/string
import gleam/list

pub fn first_letter(name: String) {
  let assert Ok(fl) = string.trim(name)
  |> string.first
  fl
}

pub fn initial(name: String) {
  first_letter(name)
  |> string.capitalise
  <> "."
}

pub fn initials(full_name: String) {
  string.trim(full_name)
  |> string.split(" ")
  |> list.map(fn(n) {
    initial(n)
  })
  |> string.join(" ")
}

pub fn pair(full_name1: String, full_name2: String) {
  "\n     ******       ******\n"<>
  "   **      **   **      **\n"<>
  " **         ** **         **\n"<>
  "**            *            **\n"<>
  "**                         **\n"<>
  "**     "<>initials(full_name1)<>"  +  "<>initials(full_name2)<>"     **\n"<>
  " **                       **\n"<>
  "   **                   **\n"<>
  "     **               **\n"<>
  "       **           **\n"<>
  "         **       **\n"<>
  "           **   **\n"<>
  "             ***\n"<>
  "              *\n"
  
}
