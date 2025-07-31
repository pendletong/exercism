import gleam/queue.{type Queue}
import gleam/list

pub fn insert_top(queue: Queue(Int), card: Int) {
  queue.push_back(queue, card)
}

pub fn remove_top_card(queue: Queue(Int)) -> Queue(Int) {
  case queue.pop_back(queue) {
    Ok(#(_, q)) -> q
    Error(_) -> queue.new()
  }
}

pub fn insert_bottom(queue: Queue(Int), card: Int) -> Queue(Int) {
  queue.push_front(queue, card)
}

pub fn remove_bottom_card(queue: Queue(Int)) -> Queue(Int) {
  case queue.pop_front(queue) {
    Ok(#(_, q)) -> q
    Error(_) -> queue.new()
  }
}

pub fn check_size_of_stack(queue: Queue(Int), target: Int) -> Bool {
  list.length(queue.to_list(queue)) == target
}
