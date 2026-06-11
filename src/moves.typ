#let rotate_piece = (i, size, n: 1) => {
  let j = calc.rem(n + 4, 4)
  if j == 0 {
    return i
  } else if j == 1 {
    return size * (size - 1 - calc.rem(i, size)) + calc.floor(i / size)
  } else if j == 2 {
    return size * size - 1 - i
  } else {
    return (size - 1 + size * calc.rem(i, size)) - calc.floor(i / size)
  }
}

#let rotate_face(cube, face, n: 1) = {
  cube.at(face) = cube
    .at(face)
    .enumerate()
    .map(i => cube.at(face).at(_rotate_piece(i.at(0), cube.size, n: n)))

  return cube
}

#let rotate_layer(cube, index, depth: 1, n: 1) = {
  let size = cube.size
  assert(
    index in ("f", "r", "u", "b", "l", "d"),
    message: "Invalid index. Expected one of (\"f\", \"r\", \"u\", \"b\", \"l\", \"d\")",
  )

  assert(
    0 < depth and depth < size,
    message: "Depth must be an integer between 1 and size - 1",
  )
  depth = depth - 1

  let prepare = (
    f: (r: 1, u: 2, l: 3),
    r: (f: 3, u: 3, b: 1, d: 3),
    u: (:),
    b: (r: 3, l: 1, d: 2),
    l: (f: 1, u: 1, b: 3, d: 1),
    d: (f: 2, r: 2, b: 2, l: 2),
  )

  let moves = (
    f: ("r", "d", "l", "u"),
    r: ("f", "u", "b", "d"),
    u: ("f", "l", "b", "r"),
    b: ("r", "u", "l", "d"),
    l: ("f", "d", "b", "u"),
    d: ("f", "r", "b", "l"),
  )

  for i in prepare.at(index).pairs() {
    cube = _rotate_face(cube, i.first(), n: i.last())
  }

  let copy = cube
  for j in range(size) {
    for i in range(4) {
      copy.at(moves.at(index).at(i)).at(j + size * depth) = cube
        .at(moves.at(index).at(i - n))
        .at(j + size * depth)
    }
  }

  cube = copy
  for i in prepare.at(index).pairs() {
    cube = _rotate_face(cube, i.first(), n: -i.last())
  }

  if depth == 0 {
    return _rotate_face(cube, index, n: n)
  } else {
    return cube
  }
}

#let rotate_cube(cube, axis) = {
  let copy = cube
  if axis == "x" {
    copy.f = cube.d
    copy.r = _rotate_face(cube, "r", n: 1).r
    copy.u = cube.f
    copy.b = _rotate_face(cube, "u", n: 2).u
    copy.l = _rotate_face(cube, "l", n: 3).l
    copy.d = _rotate_face(cube, "b", n: 2).b
  } else if axis == "y" {
    copy.f = cube.r
    copy.r = cube.b
    copy.u = _rotate_face(cube, "u", n: 1).u
    copy.b = cube.l
    copy.l = cube.f
    copy.d = _rotate_face(cube, "d", n: 3).d
  } else if axis == "z" {
    copy.f = _rotate_face(cube, "f", n: 1).f
    copy.r = _rotate_face(cube, "u", n: 1).u
    copy.u = _rotate_face(cube, "l", n: 1).l
    copy.b = _rotate_face(cube, "b", n: 3).b
    copy.l = _rotate_face(cube, "d", n: 1).d
    copy.d = _rotate_face(cube, "r", n: 1).r
  } else {
    assert(false, "Argument error: Axis must be one of (\"x\", \"y\", \"z\")")
  }
  return copy
}
