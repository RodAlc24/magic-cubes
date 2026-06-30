#import "deps.typ": cetz
#import "parser.typ": apply
#import "presets.typ": f2l-cube, oll-cube, solved-cube

/// Draws a flat representation of the cube.
/// -> content
#let draw_flat(
  /// The cube to draw.
  /// -> cube
  cube,

  /// The length of the side of the cube.
  /// -> length
  length: 60pt,
) = {
  let size = cube.size
  cetz.canvas(
    length: length / size,
    {
      import cetz.draw: rect

      let gap = size / 3 * 0.2
      let stroke = calc.min(0.3mm, 3 / size * 0.4mm)

      for i in range(size) {
        for j in range(size) {
          rect(
            (j, size - i),
            (j + 1, size - i - 1),
            fill: cube.f.at(i * size + j),
            stroke: stroke,
          )
          rect(
            (size + gap + j, size - i),
            (size + gap + j + 1, size - i - 1),
            fill: cube.r.at(i * size + j),
            stroke: stroke,
          )
          rect(
            (j, size + gap + size - i),
            (j + 1, size + gap + size - i - 1),
            fill: cube.u.at(i * size + j),
            stroke: stroke,
          )
          rect(
            (2 * (size + gap) + j, size - i),
            (2 * (size + gap) + j + 1, size - i - 1),
            fill: cube.b.at(i * size + j),
            stroke: stroke,
          )
          rect(
            (-size - gap + j, size - i),
            (-size - gap + j + 1, size - i - 1),
            fill: cube.l.at(i * size + j),
            stroke: stroke,
          )
          rect(
            (j, -size - gap + size - i),
            (j + 1, -size - gap + size - i - 1),
            fill: cube.d.at(i * size + j),
            stroke: stroke,
          )
        }
      }
    },
  )
}

/// Draws a single face of a cube.
/// -> content
#let _face(
  /// The cube.
  /// -> cube
  cube,

  /// The face, one of f, r, u, b, l, d
  /// -> str
  index,
) = {
  let size = cube.size
  for i in range(size) {
    for j in range(size) {
      let l = if index in ("f", "l", "d") {
        i * size + j
      } else if index == "u" {
        size * (size - i - 1) + j
      } else {
        size * (i + 1) - j - 1
      }

      cetz.draw.rect(
        (j - size / 2, size / 2 - i),
        (j + 1 - size / 2, size / 2 - i - 1),
        fill: cube.at(index).at(l),
        stroke: calc.min(0.3mm, 3 / size * 0.4mm),
      )
    }
  }
}

/// Draws a 3D representation of the cube.
///
/// The orientation can be modified with the #arg[x], #arg[y] and #arg[z] arguments.
/// The default orientation is an isometric projection.
/// For more details, see the CeTZ #link("https://cetz-package.github.io/docs/api/draw-functions/projections/ortho")[documentation].
///
/// -> content
#let draw_cube(
  /// The cube to draw.
  /// -> cube
  cube,

  /// Rotation around the x-axis.
  /// -> angle
  x: 35.264deg,

  /// Rotation around the y-axis.
  /// -> angle
  y: 45deg,

  /// Rotation around the z-axis.
  /// -> angle
  z: 0deg,

  /// The length of the side of the cube.
  ///
  /// #alert("warning")[
  ///  Note that it is different from the cube length.
  ///  #arg[length] specifies the length of *one cube edge before projection*.
  /// ]
  /// -> length
  length: 60pt,
) = {
  let size = cube.size
  cetz.canvas(
    length: length / size,
    {
      import cetz.draw: *

      ortho(x: x, y: y, z: z, {
        on-xy(z: size / 2, {
          _face(cube, "f")
        })

        on-zy(x: size / 2, {
          _face(cube, "r")
        })

        on-xz(y: size / 2, {
          _face(cube, "u")
        })

        on-xy(z: -size / 2, {
          _face(cube, "b")
        })

        on-zy(x: -size / 2, {
          _face(cube, "l")
        })

        on-xz(y: -size / 2, {
          _face(cube, "d")
        })
      })
    },
  )
}

/// Draws a single face of the cube, and optionally the first row of the adjacent faces.
///-> content
#let draw_face(
  /// The cube to draw.
  /// -> cube
  cube,

  /// The face to display.
  ///
  /// It must be one of `("f", "r", "u", "b", "l", "d")`.
  /// -> face
  face,

  /// The face that will be displayed above the main face.
  /// It defines the orientation of the cube.
  /// If set to #typ.t.auto, the logical default is used:
  /// - For `"f", "r", "b"` and `"l"`: `"u"`.
  /// - For `"u"`: `"b"`.
  /// - For `"d"`: `"f"`.
  ///
  /// Valid values are #typ.t.auto and any @type:face except the selected in #arg[face] and its opposite.
  /// -> face | auto
  up-face: auto,

  /// The length of the side of the cube.
  /// -> length
  length: 60pt,

  /// Whether lateral faces will appear or not.
  /// -> bool
  lateral-faces: true,

  /// TODO: docuemnt and publish this
  _arrows: none,
) = {
  let size = cube.size

  assert(
    face in ("f", "r", "u", "b", "l", "d"),
    message: "Invalid argument (face): Expected one of (\"f\", \"r\", \"u\", \"b\", \"l\", \"d\"), got: "
      + face,
  )

  let faces = (
    f: (u: "", r: "z'", d: "z2", l: "z"),
    r: (u: "y", b: "y z'", d: "y z2", f: "y z"),
    u: (b: "x'", r: "x' z'", f: "x' z2", l: "x' z"),
    b: (u: "y2", l: "y2 z'", d: "y2 z2", r: "y2 z"),
    l: (u: "y'", f: "y' z'", d: "y' z2", b: "y' z"),
    d: (f: "x", r: "x z'", b: "x z2", l: "x z"),
  )

  if up-face == auto {
    if face == "u" {
      up-face = "b"
    } else if face == "d" {
      up-face = "f"
    } else {
      up-face = "u"
    }
  }

  if up-face != auto {
    assert(
      up-face in faces.at(face).keys(),
      message: "Invalid argument (up-face): Must be one of the adjacent faces of argument face ("
        + face
        + ") or auto. Got: "
        + str(up-face),
    )
  }

  cube = apply(cube, faces.at(face).at(up-face))

  cetz.canvas(
    length: length / size,
    {
      import cetz.draw: *

      let gap = size / 3 * 0.2
      let height = size / 3 * 0.4
      let stroke = calc.min(0.3mm, 3 / size * 0.4mm)

      _face(cube, "f")

      if _arrows != none {
        for (i, j) in _arrows {
          line(
            (
              -size / 2 + 0.5 + calc.rem(j, size),
              -size / 2 + 0.5 + size - 1 - calc.floor(j / size),
            ),
            (
              -size / 2 + 0.5 + calc.rem(i, size),
              -size / 2 + 0.5 + size - 1 - calc.floor(i / size),
            ),
            mark: (end: "stealth", fill: black),
          )
        }
      }
      if lateral-faces {
        for i in range(size) {
          rect(
            (-size / 2 + i, size / 2 + height + gap),
            (-size / 2 + (i + 1), size / 2 + gap),
            fill: cube.u.at(size * (size - 1) + i),
            stroke: stroke,
          )
          rect(
            (-size / 2 + i, -size / 2 - height - gap),
            (-size / 2 + (i + 1), -size / 2 - gap),
            fill: cube.d.at(i),
            stroke: stroke,
          )
          rect(
            (size / 2 + height + gap, -size / 2 + i),
            (size / 2 + gap, -size / 2 + (i + 1)),
            fill: cube.r.at(size * (size - i - 1)),
            stroke: stroke,
          )
          rect(
            (-size / 2 - height - gap, -size / 2 + i),
            (-size / 2 - gap, -size / 2 + (i + 1)),
            fill: cube.l.at(size * (size - i - 1) + size - 1),
            stroke: stroke,
          )
        }
      }
    },
  )
}

/// Draws a cube after applying the algorithm alongside with the algorithm.
/// Default cube is #var[f2l-cube].
#let draw_f2l(
  /// The algorithm to apply.
  /// -> str
  alg,

  /// The cube to draw.
  /// -> cube
  cube: f2l-cube,

  /// The length of the side of the cube.
  /// See @cmd:draw_cube.
  /// -> length
  length: 60pt,
) = {
  box(
    inset: 1em,
    grid(
      align: center,
      row-gutter: 2em,
      columns: 2 * length,
      draw_cube(
        apply(
          cube,
          alg,
          inverted: true,
        ),
        length: length,
      ),
      text(alg),
    ),
  )
}

/// Draws a face after applying the algorithm alongside with the algorithm.
/// Default cube is #var[oll-cube].
#let draw_oll(
  /// The algorithm to apply.
  /// -> str
  alg,

  /// The cube to draw.
  /// -> cube
  cube: oll-cube,

  /// The length of the side of the cube.
  /// See @cmd:draw_cube.
  /// -> length
  length: 60pt,
) = {
  box(
    inset: 1em,
    grid(
      align: center,
      row-gutter: 2em,
      columns: 2 * length,
      draw_face(
        apply(
          cube,
          alg,
          inverted: true,
        ),
        length: length,
        "u",
      ),
      text(alg),
    ),
  )
}

/// Draws a face after applying the algorithm alongside with the algorithm.
/// It may also show arrows with the movement of the pieces on the upper face.
/// Default cube is #var[oll-cube].
#let draw_pll(
  /// The algorithm to apply.
  /// -> str
  alg,

  /// The cube to draw.
  /// -> cube
  cube: solved-cube,

  /// Whether to show or not the lateral faces.
  /// See @cmd:draw_face
  /// -> bool
  lateral-faces: false,

  /// Whether to show or not arrows representing the moves.
  /// -> bool
  arrows: true,

  /// The length of the side of the cube.
  /// See @cmd:draw_cube.
  /// -> length
  length: 60pt,
) = {
  let initial_state = apply(
    (
      size: 3,
      f: 9 * (none,),
      r: 9 * (none,),
      u: (0, 1, 2, 3, 4, 5, 6, 7, 8),
      b: 9 * (none,),
      l: 9 * (none,),
      d: 9 * (none,),
    ),
    alg,
  )

  let arrows = ()
  for (i, sticker) in initial_state.u.enumerate() {
    if sticker != none and i != sticker {
      arrows.push((i, sticker))
    }
  }

  box(
    inset: 1em,
    grid(
      align: center,
      row-gutter: 2em,
      columns: 2 * length,
      draw_face(
        apply(
          cube,
          alg,
          inverted: true,
        ),
        length: length,
        lateral-faces: lateral-faces,
        "u",
        _arrows: arrows,
      ),
      text(alg),
    ),
  )
}
