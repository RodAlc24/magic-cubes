#import "deps.typ": cetz
#import "parser.typ": apply

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
  /// -> str
  face,

  /// The face that will be displayed above the main face.
  /// It defines the orientation of the cube.
  /// If set to #typ.t.auto, the logical default is used:
  /// - For `"f", "r", "b"` and `"l"`: `"u"`.
  /// - For `"u"`: `"b"`.
  /// - For `"d"`: `"f"`.
  ///
  /// Valid values are #typ.t.auto and any face except the selected in #arg[face] and its opposite.
  /// -> str | auto
  up-face: auto,

  /// The length of the side of the cube.
  /// -> length
  length: 60pt,

  /// Whether lateral faces will appear or not.
  /// -> bool
  lateral-faces: true,
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
