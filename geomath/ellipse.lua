--- Geometric calculations for ellipses.
--
-- @module geomath.ellipses
-- @author Fabian Staacke
-- @copyright 2020
-- @license https://opensource.org/licenses/MIT

local BASE = (...):gsub("%.[^%.]+$", "")
local circle = require(BASE .. ".circle")

--- Test if a given point is contained within an ellipse (excluding its borders).
--
-- @param x The center of the ellipse
-- @param y
-- @param rx The horizontal radius of the ellipse
-- @param ry The verical radius of the ellipse
-- @param px The point
-- @param py
--
-- @return True if the point is contained, false otherwise
local function containsPoint(x, y, rx, ry, px, py)
  local scale = ry / rx
  return circle.containsPoint(x * scale, y, rx * scale, px * scale, py)
end

--- Get the intersection points of an ellipse and a line.
--
-- @param x The center of the ellipse
-- @param y
-- @param rx The horizontal radius of the ellipse
-- @param ry The verical radius of the ellipse
-- @param ax The first point of the line
-- @param ay
-- @param bx The second point of the line
-- @param by
--
-- @return The two intersection points (x1, y1, x2, y2) or nil
local function lineIntersection(cx, cy, rx, ry, ax, ay, bx, by)
  -- Scale the ellipse so that it becomes a circle and perform
  -- a circle-line intersection test.
  local scale = ry / rx
  local px1, py1, px2, py2 = circle.lineIntersection(
    cx * scale, cy, rx * scale, ax * scale, ay, bx * scale, by
  )
  
  if not px1 then
    return nil
  end
  
  return px1 / scale, py1, px2 / scale, py2
end

--- Get the intersection points of an ellipse and a line segment.
--
-- @param x The center of the ellipse
-- @param y
-- @param rx The horizontal radius of the ellipse
-- @param ry The verical radius of the ellipse
-- @param ax The first point of the line segment
-- @param ay
-- @param bx The second point of the line segment
-- @param by
--
-- @return One or two intersection points (x1, y1, x2, y2) or nil
local function segIntersection(cx, cy, rx, ry, ax, ay, bx, by)
  -- Scale the ellipse so that it becomes a circle and perform
  -- a circle-line intersection test.
  local scale = ry / rx
  local px1, py1, px2, py2 = circle.segIntersection(
    cx * scale, cy, rx * scale, ax * scale, ay, bx * scale, by
  )
  
  if px1 then
    px1 = px1 / scale
  end
  
  if px2 then
    px2 = px2 / scale
  end
  
  return px1, py1, px2, py2
end

return {
  containsPoint = containsPoint,
  lineIntersection = lineIntersection,
  segIntersection = segIntersection
}