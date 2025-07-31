import gleam/dict
import gleam/result

pub type Color {
  Black
  Brown
  Red
  Orange
  Yellow
  Green
  Blue
  Violet
  Grey
  White
}

const color_list = [#(Black, 0), #(Brown, 1), #(Red, 2), #(Orange, 3), #(Yellow, 4), #(Green, 5), #(Blue, 6), #(Violet, 7), #(Grey, 8), #(White, 9)]

fn color_map() {
  dict.from_list(color_list)
}

pub fn code(color: Color) -> Int {
  result.unwrap(dict.get(color_map(), color), -1)
}

pub fn colors() -> List(Color) {
  dict.keys(color_map())
}
