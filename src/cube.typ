#let faces = ("f", "r", "u", "b", "l", "d")
#let default-colors = (
  f: red,
  r: blue,
  u: white,
  b: orange,
  l: green,
  d: yellow,
)

/// This function creates a @type:cube given the size, colors, and/or state.
/// This is the correct way to create @type:cube instances.
///
/// The #arg[state] argument lets you specify all the stickers on a face.
/// Note that if a face is specified with this argument, it must be fully specified, and the corresponding entry in #arg[colors] is ignored.
///
/// #alert("warning")[For each face present in #arg[state], the corresponding value in #arg[colors] is ignored.]
/// -> cube
#let cube(
  /// The size of the cube.
  /// The default value is 3, i.e., a standard cube.
  /// -> int
  size: 3,
  /// The colors assigned to each face.
  ///
  /// It must be a @type:cube-colors, although it does not need to contain all the keys.
  /// In that case, the default color value will be used.
  ///
  /// The default values for each face are:
  ///
  /// #raw(
  ///    "(
  ///  f: red,
  ///  r: blue,
  ///  u: white,
  ///  b: orange,
  ///  l: green,
  ///  d: yellow
  ///)
  ///")
  ///
  /// -> cube-colors | auto
  colors: auto,

  /// The state of the cube.
  /// By default, the cube is initialized in the solved state.
  /// See @sec:creating-cubes for more details and examples.
  /// -> cube-state | auto
  state: auto,
) = {
  assert(
    type(size) == int and size > 0,
    message: "Argument error: size must be a positive integer",
  )
  if (colors != auto) {
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
    colors = default-colors + colors
  } else {
    colors = default-colors
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

