# lua-geomath
A collection of functions for 2D geometrical calculations in Lua.

This module was written for a game to implement simple collision detection. Therefore only a certain set of geometric calculations are covered, such as intersection tests between lines and geometric shapes.

## Features

The following geometric calculations are implemented:

* Lines
  * Intersection between two lines
  * Intersection between a line and a line segment
  * Intersection between two line segments
  * Closest point on a line or line segment to another point
  * Shortest distance between a point and a line or line segment
* Circles
  * Intersection between two circles
  * Tangents from an external point to a circle
  * Intersection between a circle and a line or line segment
* Ellipses
  * Intersection between an ellipse and a line or line segment
  * Containment of a point in an ellipse
* Rectangles
  * Intersection between an rectangle and a line or line segment
* Convex polygons
  * Intersection between a polygon and a line or line segment
  * Containment of a point in a polygon

## Demo

The module ships with in interactive demo, written with [LÖVE](https://love2d.org/).

![geomath demo image](demoscreen.png?raw=true)

## Usage

Include the module and do an intersection test between two line segments:

```lua
local geomath = require "geomath"

local px, py = geomath.line.segSegIntersection(
  10, 10, 50, 50, -- First line segment
  10, 50, 50, 10  -- Second line segment
)

if px then
  print("Intersection point: " .. px .. "," .. py)
else
  print("The line segments do not intersect")
end
```

## License

MIT License (see LICENSE file in project root)