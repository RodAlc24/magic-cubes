#import "moves.typ": rotate_cube, rotate_layer

/// Parses an algorithm and translates it to an alg-t dictionary. -> alg-t
#let _parse(
  /// The algorithm to parse. -> str
  alg,
) = {
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

/// Inverts an algorithm. -> alg-t
#let _invert(
  /// The algorithm to invert. -> alg-t
  alg,
) = {
  let inverted = ()
  for move in alg {
    inverted.insert(0, (move.at(0), move.at(1), 4 - move.at(2)))
  }
  return inverted
}

/// Returns a new cube after applying the algorithm. -> cube-t
#let apply(
  /// The cube to apply the algorithm. -> cube-t
  cube,

  /// The algorithm to apply. -> str
  alg,

  /// Whether it should be applied in inverse order. -> bool
  inverted: false,
) = {
  let list_alg = _parse(alg)
  if inverted {
    list_alg = _invert(list_alg)
  }

  for move in list_alg {
    if move.at(0) in ("f", "r", "u", "b", "l", "d") {
      cube = rotate_layer(cube, move.at(0), depth: move.at(1), n: move.at(2))
    } else if move.at(0) in ("x", "y", "z") {
      for i in range(move.at(2)) {
        cube = rotate_cube(cube, move.at(0))
      }
    } else {
      assert(false, message: "Not yet implemented" + move)
    }
  }

  return cube
}
