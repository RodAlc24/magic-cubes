#import "moves.typ": rotate_layer

#let parse(alg) = {
  let a = alg.split(" ")
  let list_alg = ()

  for move in a {
    let n
    let action
    let depth = 1

    if move.len() == 0 {
      continue
    } else if move.len() == 1 {
      n = 1
      action = move.at(0)
    } else if move.len() == 2 {
      if move.at(1) == "'" {
        n = 3
        action = move.at(0)
      } else if move.at(1) == "2" {
        n = 2
        action = move.at(0)
      } else {
        n = 1
        depth = int(move.at(0))
        action = move.at(1)
      }
    } else if move.len() == 3 {
      depth = int(move.at(0))
      action = move.at(1)

      if move.at(2) == "'" {
        n = 3
      } else if move.at(2) == "2" {
        n = 2
      } else {
        assert(false, message: "Invalid syntax: " + move)
      }
    } else {
      assert(false, message: "Invalid syntax: " + move)
    }

    action = lower(action)
    if (
      action in ("f", "r", "u", "b", "l", "d", "x", "y", "z", "m", "e", "s")
    ) {
      list_alg += ((action, depth, n),)
    } else {
      assert(false, message: "Invalid syntax: " + move)
    }
  }

  return list_alg
}

#let invert(alg) = {
  let inverted = ()
  for move in alg {
    inverted.insert(0, (move.at(0), move.at(1), 4 - move.at(2)))
  }
  return inverted
}

#let apply(cube, alg) = {
  let list_alg = parse(alg)

  for move in list_alg {
    if move in ("f", "r", "u", "b", "l", "d") {
      cube = rotate_layer(cube, move.at(0), depth: move.at(1), n: move.at(2))
    } else {
      assert(false, message: "Not yet implemented")
    }
  }

  return cube
}
