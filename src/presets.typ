#import "cube.typ": cube

#let f2l-cube = cube(
  f: 3 * (gray,) + 6 * (red,),
  r: 3 * (gray,) + 6 * (blue,),
  u: 9 * (gray,),
  b: 3 * (gray,) + 6 * (orange,),
  l: 3 * (gray,) + 6 * (green,),
  d: 9 * (yellow,),
)

#let oll-cube = cube(
  f: 9 * (gray,),
  r: 9 * (gray,),
  u: 9 * (yellow,),
  b: 9 * (gray,),
  l: 9 * (gray,),
  d: 9 * (gray,),
)
