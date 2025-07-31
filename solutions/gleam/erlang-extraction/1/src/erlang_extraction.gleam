// Please define the GbTree type
pub type GbTree(key, value)

@external(erlang, "gb_trees", "empty")
pub fn new_gb_tree() -> GbTree(k, v)

@external(erlang, "gb_trees", "insert")
fn do_insert(key: k, value: v, tree: GbTree(k,v)) -> GbTree(k,v)

pub fn insert(tree: GbTree(k, v), key: k, value: v) -> GbTree(k, v)
{
  do_insert(key, value, tree)
}

@external(erlang, "gb_trees", "delete_any")
pub fn do_delete_any(key: k, tree: GbTree(k,v)) -> GbTree(k,v)

pub fn delete(tree: GbTree(k, v), key: k) -> GbTree(k, v)
{
  do_delete_any(key, tree)
}
