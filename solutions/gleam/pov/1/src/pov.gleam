import gleam/bool
import gleam/list.{Continue, Stop}
import gleam/result

pub type Tree(a) {
  Tree(label: a, children: List(Tree(a)))
}

pub fn from_pov(tree: Tree(a), from: a) -> Result(Tree(a), Nil) {
  do_from_pov(tree, from)
}

fn do_from_pov(tree: Tree(a), from: a) -> Result(Tree(a), Nil) {
  use path <- result.try(path_to(tree, from, tree.label))

  list.fold(path |> list.reverse, Error(Nil), fn(t, node) {
    use tnode <- result.try(find_node(tree, node))

    case t {
      Error(Nil) -> Ok(tnode)
      Ok(Tree(_, _) as t) -> {
        let tchildren = remove_el(t.children, tnode, [])
        let t = Tree(..t, children: tchildren)
        let children = [t, ..tnode.children]

        Ok(Tree(..tnode, children:))
      }
    }
  })
}

fn remove_el(l: List(a), el: a, acc: List(a)) -> List(a) {
  case l {
    [] -> acc
    [head, ..tail] if head == el -> remove_el(tail, el, acc)
    [head, ..tail] -> remove_el(tail, el, [head, ..acc])
  }
}

fn find_node(tree: Tree(a), node: a) -> Result(Tree(a), Nil) {
  use <- bool.guard(when: tree.label == node, return: Ok(tree))

  case tree.children {
    [] -> Error(Nil)
    l ->
      list.fold_until(l, Error(Nil), fn(_, el) {
        case find_node(el, node) {
          Error(_) -> Continue(Error(Nil))
          Ok(t) -> Stop(Ok(t))
        }
      })
  }
}

pub fn path_to(
  tree tree: Tree(a),
  from from: a,
  to to: a,
) -> Result(List(a), Nil) {
  use path1 <- result.try(do_path_to(tree, from, []))
  use path2 <- result.try(do_path_to(tree, to, []))
  path1 |> echo
  path2 |> echo
  let #(path1, path2) = zip_els(path1, path2, #([], []))
  list.append(path1, path2)
  |> Ok
}

fn zip_els(
  list1: List(a),
  list2: List(a),
  acc: #(List(a), List(a)),
) -> #(List(a), List(a)) {
  let #(l1, l2) = acc
  case list1, list2 {
    [], [] -> #(l1, list.reverse(l2))
    [head1, ..rest1], [head2, ..rest2] if head1 == head2 ->
      zip_els(rest1, rest2, #([], [head2]))
    [head1, ..rest1], [head2, ..rest2] ->
      zip_els(rest1, rest2, #([head1, ..l1], [head2, ..l2]))
    [head1, ..rest1], [] -> zip_els(rest1, [], #([head1, ..l1], l2))
    [], [head2, ..rest2] -> zip_els([], rest2, #(l1, [head2, ..l2]))
  }
}

fn do_path_to(
  tree tree: Tree(a),
  to to: a,
  path path: List(a),
) -> Result(List(a), Nil) {
  case tree.label == to {
    True -> Ok([to, ..path])
    False -> {
      list.fold_until(tree.children, Error(Nil), fn(_, t) {
        case do_path_to(t, to, path) {
          Error(Nil) -> Continue(Error(Nil))
          Ok(l) -> Stop(Ok([tree.label, ..l]))
        }
      })
    }
  }
}
