pub fn to_rna(dna: String) -> Result(String, Nil) {
  do_rna(dna, "")
}

fn do_rna(dna: String, rna: String) -> Result(String, Nil) {
  case dna {
    "" -> Ok(rna)
    "G" <> rest -> do_rna(rest, rna <> "C")
    "C" <> rest -> do_rna(rest, rna <> "G")
    "T" <> rest -> do_rna(rest, rna <> "A")
    "A" <> rest -> do_rna(rest, rna <> "U")
    _ -> Error(Nil)
  }
}
