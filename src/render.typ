#import "deps.typ": cetz

/// Draws a flat cube.
#let draw_flat(
  /// The cube to draw. -> cube
  cube,
  length: 20pt,
) = {
  let size = cube.size
  cetz.canvas(
    length: 3 / size * length,
    {
      import cetz.draw: rect

      let gap = size / 3 * 0.2
      let k = 0.015
      k = 0

      for i in range(size) {
        for j in range(size) {
          rect(
            (j + k, size - i - k),
            (j + 1 - k, size - i - 1 + k),
            fill: cube.f.at(i * size + j),
            stroke: 0.3mm,
          )
          rect(
            (size + gap + j + k, size - i - k),
            (size + gap + j + 1 - k, size - i - 1 + k),
            fill: cube.r.at(i * size + j),
            stroke: 0.3mm,
          )
          rect(
            (j + k, size + gap + size - i - k),
            (j + 1 - k, size + gap + size - i - 1 + k),
            fill: cube.u.at(i * size + j),
            stroke: 0.3mm,
          )
          rect(
            (2 * (size + gap) + j + k, size - i - k),
            (2 * (size + gap) + j + 1 - k, size - i - 1 + k),
            fill: cube.b.at(i * size + j),
            stroke: 0.3mm,
          )
          rect(
            (-size - gap + j + k, size - i - k),
            (-size - gap + j + 1 - k, size - i - 1 + k),
            fill: cube.l.at(i * size + j),
            stroke: 0.3mm,
          )
          rect(
            (j + k, -size - gap + size - i - k),
            (j + 1 - k, -size - gap + size - i - 1 + k),
            fill: cube.d.at(i * size + j),
            stroke: 0.3mm,
          )
        }
      }
    },
  )
}

#let _face(cube, index) = {
  let size = cube.size
  let k = 0.015
  k = 0
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
        (j + k - size / 2, size / 2 - i - k),
        (j + 1 - k - size / 2, size / 2 - i - 1 + k),
        fill: cube.at(index).at(l),
        stroke: 0.3mm,
      )
    }
  }
}

/// Draws a cube
#let draw_cube(
  /// the cube to draw. -> cube
  cube,

  /// the x angle. -> angle
  x: 35.264deg,

  /// the y angle. -> angle
  y: 45deg,

  /// the z angle. -> angle
  z: 0deg,
  length: 20pt,
) = {
  let size = cube.size
  cetz.canvas(
    length: 3 / size * length,
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
