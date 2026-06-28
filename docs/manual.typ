#import "@local/mantys:1.0.2": * // I have applied PR#35 locally
#import "../src/exports.typ" as magic-cubes: *
#import "@preview/valkyrie:0.2.2" as z

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
            //   "U' L' U' F' R2 B' R F U B2 U B' L U' F U R F'",
            "y' R2 B2 F2 D R2 D2 R2 B2 L D F' L' F' D2 L B2 U' F' U R",
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
Years later, in 1980, the puzzle was renamed the _Rubik's Cube_, the name by which it is now known.
Today, it is considered to be the world's bestselling puzzle game.

magic-cubes is a package built on top of CeTZ that allows you to create, manipulate and render Rubik's cubes of any size.

= Examples

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
<sec:creating-cubes>

A cube is represented as a dictionary, and can be easily created with the @cmd:cube function.
It should not be created or modified manually.

The size of the cube can be specified with the #arg[size] argument (default is 3).
The face colors can be changed with the #arg[colors] argument, specifying the faces to change.
The default colors are:

#frame(
  raw(
    "(
  f: red,
  r: blue,
  u: white,
  b: orange,
  l: green,
  d: yellow
)
",
  ),
  [This colors are the Typst #link("https://typst.app/docs/reference/visualize/color/#predefined-colors")[predefined colors].],
)

It is also possible to specify a face manually, in that case the corresponding value in #arg[colors] will be ignored.
When specifying the colors manually, all the pieces in the face must be determined.

The order of the pieces in a face is the following:

#frame(
  {
    // {{{
    let size = 3
    cetz.canvas(
      length: 3 / size * 15pt,
      {
        import cetz.draw: content, rect

        let gap = size / 3 * 0.2
        let k = 0.015
        k = 0

        for i in range(size) {
          for j in range(size) {
            content(
              (j + k, size - i - k),
              (j + 1 - k, size - i - 1 + k),
              box(
                str(3 * i + j),
                stroke: 0.3mm + red,
                width: 100%,
                height: 100%,
                inset: 0.5em,
              ),
            )
            content(
              (size + gap + j + k, size - i - k),
              (size + gap + j + 1 - k, size - i - 1 + k),
              box(
                str(3 * i + j),
                stroke: 0.3mm + blue,
                width: 100%,
                height: 100%,
                inset: 0.5em,
              ),
            )
            content(
              (j + k, size + gap + size - i - k),
              (j + 1 - k, size + gap + size - i - 1 + k),
              box(
                str(3 * i + j),
                stroke: 0.3mm,
                width: 100%,
                height: 100%,
                inset: 0.5em,
              ),
            )
            content(
              (2 * (size + gap) + j + k, size - i - k),
              (2 * (size + gap) + j + 1 - k, size - i - 1 + k),
              box(
                str(3 * i + j),
                stroke: 0.3mm + orange,
                width: 100%,
                height: 100%,
                inset: 0.5em,
              ),
            )
            content(
              (-size - gap + j + k, size - i - k),
              (-size - gap + j + 1 - k, size - i - 1 + k),
              box(
                str(3 * i + j),
                stroke: 0.3mm + green,
                width: 100%,
                height: 100%,
                inset: 0.5em,
              ),
            )
            content(
              (j + k, -size - gap + size - i - k),
              (j + 1 - k, -size - gap + size - i - 1 + k),
              box(
                str(3 * i + j),
                stroke: 0.3mm + yellow,
                width: 100%,
                height: 100%,
                inset: 0.5em,
              ),
            )
          }
        }
      },
    )
    // }}}
  },
  [
    Each face is represented with the default color previously explained, except the up face that is in black.
  ],
)

#alert("info")[
  Note that this way of creating cubes may result in an impossible cube state (you can even use more than six colors!).
  This can be useful, for example, to add a gray color to the non relevant pieces.
]

This order is also used in other size cubes, for example, if we want to create a 2x2x2 cube with a custom color in front face and custom up and right faces we can do:
```side-by-side
#draw_flat(
  length: 15pt,
  cube(
    size: 2,
    colors: (f: maroon),
    state: (
      u: (
        red,
        orange,
        green,
        blue,
      ),
      r: (
        yellow,
        white,
        black,
        gray,
      ),
    )
  )
)
```

There are also some useful predefined cubes:

#grid(
  columns: 2,
  column-gutter: 10mm,
  [
    ```example
    #draw_cube(f2l-cube, length: 10pt)
    ```
  ],
  [
    ```example
    #draw_cube(oll-cube, length: 10pt)
    ```
  ],
)
// TODO: change second example to draw_oll

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

= Reference


== Custom types

=== @type:cube

@type:cube is the main type in this package, as it represents the state of a cube.
However, you should not create or modify instances manually, as functions such as @cmd:draw_cube require the cube to be in a consistent state.
Instead, use @cmd:cube to create instances and `parse` to manipulate them. // TODO: add @cmd:parse reference

#frame(
  schema("cube", z.dictionary((
    size: z.integer(),
    f: z.array(z.color(), default: none),
    r: z.array(z.color(), default: none),
    u: z.array(z.color(), default: none),
    b: z.array(z.color(), default: none),
    l: z.array(z.color(), default: none),
    d: z.array(z.color(), default: none),
  ))),
  [The length of the dictionaries must be equal to the square of the size.],
)

=== @type:cube-colors

This type is used when creating a cube to specify the color of each face.
#frame(
  schema("cube-colors", color: red.lighten(60%), z.dictionary((
    f: z.color(),
    r: z.color(),
    u: z.color(),
    b: z.color(),
    l: z.color(),
    d: z.color(),
  ))),
  [Not all keys neet to be present for a valid @type:cube-colors element.],
)

=== @type:cube-state

This type is used when creating a cube to specify the pieces of each face.
#frame(
  schema("cube-state", color: green.lighten(60%), z.dictionary((
    f: z.array(z.color(), default: none),
    r: z.array(z.color(), default: none),
    u: z.array(z.color(), default: none),
    b: z.array(z.color(), default: none),
    l: z.array(z.color(), default: none),
    d: z.array(z.color(), default: none),
  ))),
  [Not all keys need to be present for a valid @type:cube-state element.],
)


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

= Examples
#draw_flat(apply(cube(size: 6), "f r b u r f r u d b l f r l u r l u f z"))
#draw_flat(rotate_cube(
  apply(cube(), "f r b u r f r u d b l f r l u r l u f "),
  "z",
))

#pagebreak()
#draw_cube(cube(size: 3)),

