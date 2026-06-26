#import "@local/mantys:1.0.2": * // I have applied PR#35 locally
#import "../src/exports.typ" as magic-cubes: *

#set scale(reflow: true)

#show: mantys(
  ..toml("../typst.toml"),
  themes: themes.default,
  title: "magic-cubes",
  abstract: [
    #align(
      center + horizon,
      grid(
        columns: (3cm, 3cm),
        column-gutter: 4cm,
        row-gutter: 0.5cm,
        align: center + horizon,
        figure(
          draw_cube(apply(
            cube(),
            "U' L' U' F' R2 B' R F U B2 U B' L U' F U R F'",
          )),
        ),
        figure(
          draw_cube(apply(
            cube(size: 4),
            "F U2 L F L' B L U B' R' L' U R' D' F' B R2",
          )),
        ),

        "U' L' U' F' R2 B' R F U B2 U B' L U' F U R F'",
        "F U2 L F L' B L U B' R' L' U R' D' F' B R2",
      ),
    )
  ],
  examples-scope: (
    scope: (
      pkg: magic-cubes,
    ),
    imports: (
      pkg: "*",
    ),
  ),
)

#set text(hyphenate: true)
#show "magic-cubes": package
#show "CeTZ": package

= About

In 1974, Ernő Rubik invented a mechanical puzzle and called it the _Magic Cube_.
Years later, in 1980, the puzzle was renamed the _Rubik's Cube_, name by which it is now known.
Today, it is considered to be the world's bestselling puzzle game.

magic-cubes is a package built on top of CeTZ that allows you to create, manipulate and render Rubik's cubes of any size.

```side-by-side
#draw_cube(
  apply(
    cube(),
    "F2 B2 R2 L2 U2 D2"
  )
)
```

```side-by-side
#draw_cube(
  apply(
    cube(size: 4),
    "R2 3R2 F2 3F2 R2 3R2"
  )
)
```

```side-by-side
#draw_cube(
  apply(
    inverted: true,
    f2l-cube,
    "R2 U R2 U R2 U2 R2"
  )
)
```
= Guide

== Creating cubes

Cubes can be created using the "cube" function...

== Applying algorithms

=== Moves
The following moves are supported, more will be added in future updates:
- F: front face
- R: right face
- U: up face
- B: back face
- L: left face
- D: down face

All of them represent a single *clockwise* turn in the respective face.

=== Modifiers

Adding an apostrophe (#sym.quote.single) or a "2" after the move will cause an anticlockwise turn or a double one (180º) respectively.


== Rendering cubes

= Full reference

== Types

#schema("cube", (
  "f": (:),
  "r": (:),
))

== Functions

#tidy-module(
  "main",
  (
    read("../src/parser.typ"),
    read("../src/moves.typ"),
    read("../src/render.typ"),
    read("../src/cube.typ"),
  ).join("\n"),
  omit-private-definitions: true,
)

#pagebreak()

#draw_flat(apply(cube(size: 6), "f r b u r f r u d b l f r l u r l u f z"))
#draw_flat(rotate_cube(
  apply(cube(), "f r b u r f r u d b l f r l u r l u f "),
  "z",
))

#pagebreak()
#draw_cube(cube(size: 3)),

