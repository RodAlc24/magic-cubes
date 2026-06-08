#import "moves.typ": rotate_layer

#let parse(cube, alg) = {
  let a = alg.split(" ")
  for move in a {
    move = lower(move)
    let n

    if move.len() == 0 {
      continue
    } else if move.len() == 1 {
      n = 1
    } else if move.len() == 2 and move.at(1) == "'" {
      n = 3
    } else {
      n = int(move.slice(1))
    }

    move = move.at(0)
    cube = rotate_layer(cube, move, n: n)
  }

  return cube
}

