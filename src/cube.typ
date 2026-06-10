#import "deps.typ" as e: field, types

#let faces = ("f", "r", "u", "b", "l", "d")
#let default-colors = (
  f: red,
  r: blue,
  u: white,
  b: orange,
  l: green,
  d: yellow,
)

#let cube(
  size: 3,
  colors: default-colors,
  state: auto,
) = {
  assert(
    type(size) == int and size > 0,
    message: "Argument error: size must be a positive integer",
  )
  assert(
    type(colors) == dictionary,
    message: "Argument error: colors must be a dictionary",
  )

  for elem in colors {
    assert(
      elem.first() in faces,
      message: "Key error: " + elem.first() + " is not a valid key",
    )
    assert(
      type(elem.last()) == color,
      message: "Argument error: colors must be a dictionary of colors",
    )
  }

  for elem in faces {
    if not elem in colors {
      colors.insert(elem, default-colors.at(elem))
    }
  }

  if state != auto {
    assert(
      type(state) == dictionary,
      message: "Argument error: state must be a dictionary",
    )
    for face in state {
      assert(
        face.first() in faces,
        message: "Key error: " + face.first() + " is not a valid key",
      )
      assert(
        type(face.last()) == array,
        message: "Value error: state values must be arrays",
      )
      assert(
        face.last().len() == size * size,
        message: "Length error: length of state values must be "
          + str(size * size),
      )
      for elem in face.last() {
        assert(
          type(elem) == color,
          message: "Value error: state values must be arrays of colors",
        )
      }
    }
  } else {
    state = (:)
  }

  for elem in faces {
    if elem not in state {
      state.insert(elem, size * size * (colors.at(elem),))
    }
  }

  return (
    size: size,
    f: state.f,
    r: state.r,
    u: state.u,
    b: state.b,
    l: state.l,
    d: state.d,
  )
}

