import gleam/list

pub type Nucleotide {
  Adenine
  Cytosine
  Guanine
  Thymine
}

pub fn encode_nucleotide(nucleotide: Nucleotide) -> Int {
  case nucleotide {
    Adenine -> 0b00
    Cytosine -> 0b01
    Guanine -> 0b10
    Thymine -> 0b11
  }
}

pub fn decode_nucleotide(nucleotide: Int) -> Result(Nucleotide, Nil) {
  case nucleotide {
    0b00 -> Ok(Adenine)
    0b01 -> Ok(Cytosine)
    0b10 -> Ok(Guanine)
    0b11 -> Ok(Thymine)
    _ -> Error(Nil)
  }
}

pub fn encode(dna: List(Nucleotide)) -> BitArray {
  list.fold(dna, <<>>, fn(acc, n) {
    << acc:bits, encode_nucleotide(n):2 >>
  })
}

pub fn decode(dna: BitArray) -> Result(List(Nucleotide), Nil) {
  case decode_loop(Ok([]), dna)
{
  Error(_) -> Error(Nil)
  Ok(l) -> Ok(list.reverse(l))
}
}

fn decode_loop(list: Result(List(Nucleotide), Nil), dna: BitArray) -> Result(List(Nucleotide), Nil) {
  let assert Ok(l) = list
  case dna {
    <<value:2, rest:bits>> -> {
      case decode_nucleotide(value) {
        Error(_) -> Error(Nil)
        Ok(n) -> decode_loop(Ok([n, ..l]), rest)
      }
    } 
    <<>> -> list
    _ -> Error(Nil)
  }
}
