#import "@local/mantys:1.0.2": * // I have applied PR#35 locally
#import "../src/exports.typ" as magic-cubes: *
#import "@preview/valkyrie:0.2.2" as z

#set scale(reflow: true)
#set text(hyphenate: false)

// {{{
#show: mantys(
  ..toml("../typst.toml"),
  themes: themes.default,
  //title: "magic-cubes",
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
// }}}

= Examples // {{{

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
#draw_flat(apply(cube(size: 6), "f r b u r f r u d b l f r l u r l u f z"))
#draw_flat(rotate_cube(
  apply(cube(), "f r b u r f r u d b l f r l u r l u f "),
  "z",
))

#draw_cube(cube(size: 3))
// }}}

= Guide

== Creating cubes // {{{
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

It is also possible to specify a face manually, in that case the corresponding value in #arg[colors] is ignored.
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
                inset: 0.4em,
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
                inset: 0.4em,
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
                inset: 0.4em,
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
                inset: 0.4em,
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
                inset: 0.4em,
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
                inset: 0.4em,
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
  length: 45pt,
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

There are also some useful predefined cubes: `f2l-cube` and `oll-cube`.

#grid(
  columns: 2,
  column-gutter: 2mm,
  [
    ```example
    #draw_cube(f2l-cube, length: 30pt)
    ```
  ],
  [
    ```example
    #draw_cube(oll-cube, length: 30pt)
    ```
  ],
)
// TODO: change second example to draw_oll
// }}}

== Applying algorithms // {{{

One of the main features of magic-cubes is the possibility to apply algorithms to the cubes.
Algorithms are written following the standard notation that is fully documented on @sec:notation.

The function @cmd:apply receives a cube and an algorithm as a #typ.t.str.
It is also possible, through the #arg[inverted] argument to apply the inverse algorithm.
This results in a cube that, after applying the specified algorithm, will result in the original cube.

#grid(
  columns: 2,
  column-gutter: 2mm,
  [
    ```side-by-side
    #draw_cube(
      apply(
        cube(),
        "F"
      )
    )
    ```
  ],
  [
    ```side-by-side
    #draw_cube(
      apply(
        cube(),
        "M2 E2 S2"
      )
    )
    ```
  ],

  [
    ```side-by-side
    #draw_cube(
      apply(
        cube(size: 4),
        "2R L' 2-3u'"
      )
    )
    ```
  ],
  [
    ```side-by-side
    #draw_cube(
      apply(
        f2l-cube,
        inverted: true,
        "U R U' R'"
      )
    )
    ```
  ],
)

#alert("info")[
  There are also two alternative functions that lets you modify the cube: @cmd:rotate_layer and @cmd:rotate_cube.
]

// }}}

== Rendering cubes

= Cube notation // {{{
<sec:notation>

== 1-layer moves // {{{
<sec:1-layer>

The basic moves are represented with one uppercase letter.
There are six moves, one for each face of the cube: *F* (front), *R* (right), *U* (up), *B* (back), *L* (left) and *D* (down).
Each represents a single clockwise rotation.
Double and counterclockwise rotations are explained in @sec:modifiers.

// {{{
#grid(
  columns: 3,
  column-gutter: 2mm,
  row-gutter: 2mm,
  example(side-by-side: true)[
    ```typ
    F
    ```
  ][
    #draw_cube(
      apply(
        cube(),
        "F",
      ),
      length: 36pt,
    )
  ],
  example(side-by-side: true)[
    ```typ
    R
    ```
  ][
    #draw_cube(
      apply(
        cube(),
        "R",
      ),
      length: 36pt,
    )
  ],
  example(side-by-side: true)[
    ```typ
    U
    ```
  ][
    #draw_cube(
      apply(
        cube(),
        "U",
      ),
      length: 36pt,
    )
  ],

  example(side-by-side: true)[
    ```typ
    B
    ```
  ][
    #draw_cube(
      apply(
        cube(),
        "B",
      ),
      length: 36pt,
    )
  ],
  example(side-by-side: true)[
    ```typ
    L
    ```
  ][
    #draw_cube(
      apply(
        cube(),
        "L",
      ),
      length: 36pt,
    )
  ],
  example(side-by-side: true)[
    ```typ
    D
    ```
  ][
    #draw_cube(
      apply(
        cube(),
        "D",
      ),
      length: 36pt,
    )
  ],
)
// }}}

It is also possible to move an inner layer.
To do so, precede the letter with the depth of the layer.
The outermost layer has a depth of 1 and layer numbering always starts from the referenced face.

#alert(
  "info",
)[
  It is not necessary to specify the depth for the moves of the outermost layer.
  For example, 1U is equivalent to U in all cubes.
]

#alert(
  "warning",
)[
  The maximum depth is the cube size minus 1.
  If you want to rotate the opposite face use the corresponding notation, i.e., in a 4x4x4 cube a 4F rotation is not allowed, the correct notation is B'.
]

// {{{
#grid(
  columns: 2,
  column-gutter: 2mm,
  row-gutter: 2mm,
  example(side-by-side: true)[
    ```typ
    F (or 1F)
    ```
  ][
    #draw_cube(
      apply(
        cube(size: 4),
        "F",
      ),
      length: 45pt,
    )
  ],
  example(side-by-side: true)[
    ```typ
    2R
    ```
  ][
    #draw_cube(
      apply(
        cube(size: 5),
        "2R",
      ),
      length: 45pt,
    )
  ],

  example(side-by-side: true)[
    ```typ
    3U
    ```
  ][
    #draw_cube(
      apply(
        cube(size: 4),
        "3U",
      ),
      length: 45pt,
    )
  ],
  example(side-by-side: true)[
    ```typ
    2D
    ```
  ][
    #draw_cube(
      apply(
        cube(size: 4),
        "2D",
      ),
      length: 45pt,
    )
  ],
)
// }}}
// }}}

== Central moves // {{{

The central layers have a special notation:
- *M*: "middle", between L and R following L.
- *E*: "equator", between U and D following D.
- *S*: "standing", between F and B following F.

// {{{
#grid(
  columns: 3,
  column-gutter: 2mm,
  row-gutter: 2mm,
  example(side-by-side: true)[
    ```typ
    M
    ```
  ][
    #draw_cube(
      apply(
        cube(),
        "M",
      ),
      length: 36pt,
    )
  ],
  example(side-by-side: true)[
    ```typ
    E
    ```
  ][
    #draw_cube(
      apply(
        cube(),
        "E",
      ),
      length: 36pt,
    )
  ],
  example(side-by-side: true)[
    ```typ
    S
    ```
  ][
    #draw_cube(
      apply(
        cube(),
        "S",
      ),
      length: 36pt,
    )
  ],
)
// }}}

#alert("error")[Central moves are only available on cubes with odd size.]

// }}}

== Wide moves // {{{

It is also possible to rotate more than one layer at the same time.
This is especially useful for big cubes, but it is also used sometimes on a 3x3x3.

There are two equivalent notations: using lowercase letters or appending a *w* after the corresponding uppercase letter.
By default, all layers between the outermost layer and the center (if the cube has odd size) are rotated, but this can be specified with a number before the move.
For example, *3f* (or *3Fw*) rotates the first three front layers.

#alert(
  "info",
)[
  Just as before with the depth parameter, the maximum number of layers that can be moved with a wide move is equal to size - 1.
  A specific notations exists for rotating the entire cube that will be explained next.
]

// {{{
#grid(
  columns: 3,
  column-gutter: 2mm,
  row-gutter: 2mm,
  example(side-by-side: true)[
    ```typ
    f / Fw
    ```
  ][
    #draw_cube(
      apply(
        cube(),
        "f",
      ),
      length: 36pt,
    )
  ],
  example(side-by-side: true)[
    ```typ
    r / Rw
    ```
  ][
    #draw_cube(
      apply(
        cube(size: 4),
        "r",
      ),
      length: 36pt,
    )
  ],
  example(side-by-side: true)[
    ```typ
    4u / 4Uw
    ```
  ][
    #draw_cube(
      apply(
        cube(size: 5),
        "4u",
      ),
      length: 36pt,
    )
  ],
)
// }}}

It is also possible to rotate multiple inner layers.
To do so, write the first and last layers before the move separated with a dash.

// {{{
#grid(
  columns: 3,
  column-gutter: 2mm,
  row-gutter: 2mm,
  example(side-by-side: true)[
    ```typ
    2-3l / 2-3Lw
    ```
  ][
    #draw_cube(
      apply(
        cube(size: 4),
        "2-3l",
      ),
      length: 45pt,
    )
  ],
  example(side-by-side: true)[
    ```typ
    2-4r / 2-4Rw
    ```
  ][
    #draw_cube(
      apply(
        cube(size: 6),
        "2-4r",
      ),
      length: 45pt,
    )
  ],
)
// }}}
// }}}

== Cube rotations //{{{
<sec:cube-rotations>

For a complete cube rotation the letters *x*, *y* and *z* are used.
This movements do not alter the state of the cube, just the point of view.

- *x*: rotating the whole cube as if performing *R*.
- *y*: rotating the whole cube as if performing *U*.
- *z*: rotating the whole cube as if performing *F*.

// {{{
#grid(
  columns: 2,
  column-gutter: 2mm,
  row-gutter: 2mm,
  example(side-by-side: true)[
    ```typ
    Original state
    ```
  ][
    #draw_cube(
      cube(),
      length: 45pt,
    )
  ],
  example(side-by-side: true)[
    ```typ
    x
    ```
  ][
    #draw_cube(
      apply(
        cube(),
        "x",
      ),
      length: 45pt,
    )
  ],

  example(side-by-side: true)[
    ```typ
    y
    ```
  ][
    #draw_cube(
      apply(
        cube(),
        "y",
      ),
      length: 45pt,
    )
  ],
  example(side-by-side: true)[
    ```typ
    z
    ```
  ][
    #draw_cube(
      apply(
        cube(),
        "z",
      ),
      length: 45pt,
    )
  ],
)
// }}}
// }}}

== Modifiers // {{{
<sec:modifiers>

Appending an apostrophe (*#sym.quote.single*) or a "*2*" to a move denotes an counterclockwise rotation or a double one (180º), respectively.
These modifiers can be applied to any notation described above.

// {{{
#grid(
  columns: 2,
  column-gutter: 2mm,
  row-gutter: 2mm,
  example(side-by-side: true)[
    ```typ
    R'
    ```
  ][
    #draw_cube(
      apply(
        cube(),
        "R'",
      ),
      length: 45pt,
    )
  ],
  example(side-by-side: true)[
    ```typ
    2F2
    ```
  ][
    #draw_cube(
      apply(
        cube(size: 4),
        "2F2",
      ),
      length: 45pt,
    )
  ],

  example(side-by-side: true)[
    ```typ
    3Rw'
    ```
  ][
    #draw_cube(
      apply(
        cube(size: 4),
        "3Rw'",
      ),
      length: 45pt,
    )
  ],
  example(side-by-side: true)[
    ```typ
    x2
    ```
  ][
    #draw_cube(
      apply(
        cube(size: 2),
        "x2",
      ),
      length: 45pt,
    )
  ],
)
// }}}
// }}}
// }}}

= Reference // {{{

== Custom types

=== @type:cube

@type:cube represents the complete state of a Rubik's cube, it it the main element in this package.
However, you should not create or modify instances manually, as functions such as @cmd:draw_cube require the cube to be in a valid, consistent state.
Instead, use @cmd:cube to create instances and @cmd:apply to manipulate them.

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
  [Each array must contain $#arg[size]^2$ elements.],
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
  [Not all keys need to be present for a valid @type:cube-colors value.],
)

#pagebreak(weak: true)

=== @type:cube-state

This type is used when creating a cube to specify the color of the stickers for each face.
All the arrays must have the same length and it must be equal to the square of the size of the cube.
#frame(
  schema("cube-state", color: green.lighten(60%), z.dictionary((
    f: z.array(z.color(), default: none),
    r: z.array(z.color(), default: none),
    u: z.array(z.color(), default: none),
    b: z.array(z.color(), default: none),
    l: z.array(z.color(), default: none),
    d: z.array(z.color(), default: none),
  ))),
  [Not all keys need to be present for a valid @type:cube-state value.],
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
// }}}

