--- Geometric calculations for rectangles.
--
-- @module geomath.rect
-- @author Fabian Staacke
-- @copyright 2020
-- @license https://opensource.org/licenses/MIT

local BASE = (...):gsub("%.[^%.]+$", "")
local line = require(BASE .. ".line")
local polygon = require(BASE .. ".polygon")

-- Internally used rectangle.
local rect = {0, 0, 0, 0, 0, 0, 0, 0}

--- Test if a given point is contained within a rectangle (excluding its borders).
--
-- @param x The top-left corner of the rectangle
-- @param y
-- @param w The width of the rectangle
-- @param h The height of the rectangle
-- @param px The point
-- @param py
--
-- @return True if the point is contained, false otherwise
local function containsPoint(x, y, w, h, px, py)
  return px > x and px < x + w and py > y and py < y + h
end

--- Get the intersection points of a rectangle and a line.
--
-- @param x The top-left corner of the rectangle
-- @param y
-- @param w The width of the rectangle
-- @param h The height of the rectangle
-- @param ax The first point of the line
-- @param ay
-- @param bx The second point of the line
-- @param by
--
-- @return The two intersection points (x1, y1, x2, y2) or nil
local function lineIntersection(x, y, w, h, ax, ay, bx, by)
  rect[1], rect[2] = x, y
  rect[3], rect[4] = x + w, y
  rect[5], rect[6] = x + w, y + h
  rect[7], rect[8] = x, y + h
  return polygon.intersectionPoints(rect, ax, ay, bx, by, false, line.lineSegIntersection)
end

--- Get the intersection points of a rectangle and a line segment.
--
-- @param x The top-left corner of the rectangle
-- @param y
-- @param w The width of the rectangle
-- @param h The height of the rectangle
-- @param ax The first point of the line segment
-- @param ay
-- @param bx The second point of the line segment
-- @param by
--
-- @return One or two intersection points (x1, y1, x2, y2) or nil
local function segIntersection(x, y, w, h, ax, ay, bx, by)
  local pointsInside = 0

  if containsPoint(x, y, w, h, ax, ay) then
    pointsInside = pointsInside + 1
  end
  
  if containsPoint(x, y, w, h, bx, by) then
    pointsInside = pointsInside + 1
  end
  
  if pointsInside == 2 then
    return nil
  end
  
  rect[1], rect[2] = x, y
  rect[3], rect[4] = x + w, y
  rect[5], rect[6] = x + w, y + h
  rect[7], rect[8] = x, y + h
  
  return polygon.intersectionPoints(rect, ax, ay, bx, by, pointsInside == 1, line.segSegIntersection)
end

return {
  containsPoint = containsPoint,
  lineIntersection = lineIntersection,
  segIntersection = segIntersection
}