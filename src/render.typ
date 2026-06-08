#import "deps.typ": cetz

#let draw_flat(cube) = {
  cetz.canvas({
    import cetz.draw: rect

    let size = cube.size
    let gap = 0.2
    let k = 0.015

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
  })
}

#let face(cube, index) = {
  let size = cube.size
  let k = 0.015
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
        (j + k, size - i - k),
        (j + 1 - k, size - i - 1 + k),
        fill: cube.at(index).at(l),
        stroke: 0.3mm,
      )
    }
  }
}

#let draw_cube(cube, x: 35.264deg, y: 45deg, z: 0deg) = {
  cetz.canvas({
    import cetz.draw: *

    let size = cube.size

    ortho(x: x, y: y, z: z, {
      on-xy(z: size, {
        face(cube, "f")
      })

      on-zy(x: size, {
        face(cube, "r")
      })

      on-xz(y: size, {
        face(cube, "u")
      })

      on-xy({
        face(cube, "b")
      })

      on-zy({
        face(cube, "l")
      })

      on-xz({
        face(cube, "d")
      })
    })
  })
}
