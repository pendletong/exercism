import simplifile
import gleam/string
import gleam/list
import gleam/result

pub fn read_emails(path: String) -> Result(List(String), Nil) {
  let assert Ok(text) = simplifile.read(path)
  Ok({
      string.split(text, "\n")
      |> list.filter(fn(e) {
        case string.trim(e) {
          "" -> False
          _ -> True
        }
      })
  })
}


pub fn create_log_file(path: String) -> Result(Nil, Nil) {
  case simplifile.create_file(path) {
    Ok(_) -> Ok(Nil)
    _ -> Error(Nil)
  }
}

pub fn log_sent_email(path: String, email: String) -> Result(Nil, Nil) {
  case simplifile.append(path, email<>"\n") {
    Ok(_) -> Ok(Nil)
    _ -> Error(Nil)
  }
}

pub fn send_newsletter(
  emails_path: String,
  log_path: String,
  send_email: fn(String) -> Result(Nil, Nil),
) -> Result(Nil, Nil) {
let _ = create_log_file(log_path)
use emails <- result.try(read_emails(emails_path))
  list.each(emails, fn(email) {
    case send_email(email) {
      Ok(_) -> log_sent_email(log_path, email)
      _ -> Error(Nil)
    }
  })
Ok(Nil)
}
