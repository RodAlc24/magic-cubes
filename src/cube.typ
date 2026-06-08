#import "deps.typ" as e: field, types

#let cube-colors = e.types.declare(
  "cube-colors",
  doc: "Defines the colors of a cube",
  prefix: "@preview/magic-cubes,v1",
  fields: (
    field("f", color, doc: "Front face color", default: red),
    field("r", color, doc: "Right face color", default: blue),
    field("u", color, doc: "Up face color", default: white),
    field("b", color, doc: "Back face color", default: orange),
    field("l", color, doc: "Left face color", default: green),
    field("d", color, doc: "Down face color", default: yellow),
  ),
  casts: ((from: dictionary),),
)

#let cube = e.types.declare(
  "cube",
  doc: "Represents a cube",
  prefix: "@preview/magic-cubes,v1",
  fields: (
    field("size", int, doc: "The dimension of the cube", default: 3),
    field(
      "f",
      types.array(color),
      doc: "Front face",
    ),
    field(
      "r",
      types.array(color),
      doc: "Right face",
    ),
    field(
      "u",
      types.array(color),
      doc: "Up face",
    ),
    field(
      "b",
      types.array(color),
      doc: "Back face",
    ),
    field(
      "l",
      types.array(color),
      doc: "Left face",
    ),
    field(
      "d",
      types.array(color),
      doc: "Down face",
    ),
  ),
  construct: constructor => (
    size: 3,
    colors: cube-colors(),
    f: none,
    r: none,
    u: none,
    b: none,
    l: none,
    d: none,
  ) => {
    let obj = constructor(size: size)
    colors = types.cast(colors, cube-colors)

    assert(colors.at(0), message: "colors must be a cube-colors dict")
    colors = colors.at(1)

    if (f != none) {
      assert(
        f.len() == size * size,
        message: "The length of colors.f must be " + str(size * size),
      )
    } else {
      f = size * size * (colors.f,)
    }
    if (u != none) {
      assert(
        u.len() == size * size,
        message: "The length of colors.u must be " + str(size * size),
      )
    } else {
      u = size * size * (colors.u,)
    }
    if (r != none) {
      assert(
        r.len() == size * size,
        message: "The length of colors.r must be " + str(size * size),
      )
    } else {
      r = size * size * (colors.r,)
    }
    if (b != none) {
      assert(
        b.len() == size * size,
        message: "The length of colors.b must be " + str(size * size),
      )
    } else {
      b = size * size * (colors.b,)
    }
    if (l != none) {
      assert(
        l.len() == size * size,
        message: "The length of colors.l must be " + str(size * size),
      )
    } else {
      l = size * size * (colors.l,)
    }
    if (d != none) {
      assert(
        d.len() == size * size,
        message: "The length of colors.d must be " + str(size * size),
      )
    } else {
      d = size * size * (colors.d,)
    }
    return constructor(size: size, f: f, r: r, u: u, l: l, b: b, d: d)
  },
)
