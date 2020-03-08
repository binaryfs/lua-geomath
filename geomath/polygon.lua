--- Geometric calculations for concave polygons.
--
-- @module geomath.polygon
-- @author Fabian Staacke
-- @copyright 2020
-- @license https://opensource.org/licenses/MIT

local BASE = (...):gsub("%.[^%.]+$", "")
local vector = require(BASE .. ".vector")
local line = require(BASE .. ".line")
local utils = require(BASE .. ".utils")
local abs = math.abs

--- Get the intersection points of a convex polygon and a line or line segment.
-- This function is meant to be used internally and not part of the public API.
--
-- @param polygon A table that holds the polygon points
-- @param ax The first point of the line or line segment
-- @param ay
-- @param bx The second point of the line or line segment
-- @param by
-- @param inside True if a line segment is used and its start or end point
--   is inside the polygon.
-- @param intersectionTest The function to use for the intersection tests.
--
-- @return One or two intersection points (x1, y1, x2, y2) or nil
-- @local
local function intersectionPoints(polygon, ax, ay, bx, by, inside, intersectionTest)
  -- First intersection point.
  local px, py, pf
  -- Second intersection point.
  local px2, py2

  for i = 0, #polygon - 2, 2 do
    local cx, cy = polygon[i + 1], polygon[i + 2]
    local dx, dy = polygon[i + 3] or polygon[1], polygon[i + 4] or polygon[2]
    local tx, ty, tf = intersectionTest(ax, ay, bx, by, cx, cy, dx, dy)
    
    if tx then
      if px then
        -- Ignore the intersection if it is almost equal to the first one.
        -- We have probably just hit a junction of two adjacent polygon edges.
        if not utils.nearlyEqual(px, tx) or not utils.nearlyEqual(py, ty) then
          if tf < pf then
            -- Swap the intersection points if the second one is closer to
            -- the start point of the line.
            px, py, px2, py2 = tx, ty, px, py
          else
            px2, py2 = tx, ty
          end
          -- Second intersection point found.
          break
        end
      else
        -- First intersection point found.
        px, py, pf = tx, ty, tf
        if inside then break end
      end
    elseif not inside and not px and i == #polygon - 4 then
      -- We can skip the last iteration if we are looking for two intersection
      -- points but haven't found any so far.
      break
    end
  end
  
  return px, py, px2, py2
end

--- Test if a given point is contained within a polygon (excluding its borders).
--
-- @param polygon A table that holds the polygon points
-- @param px The point
-- @param py
--
-- @return True if the point is contained, false otherwise
local function containsPoint(polygon, px, py)
  local prevSide = false
  
  for i = 0, #polygon - 2, 2 do
    local ax, ay = polygon[i + 1], polygon[i + 2]
    local bx, by = polygon[i + 3] or polygon[1], polygon[i + 4] or polygon[2]
    local side = vector.side(bx - ax, by - ay, px - ax, py - ay)
    
    if side == 0 then
      return false
    elseif not prevSide then
      prevSide = side
    elseif side ~= prevSide then
      return false
    end
  end
  
  return true
end

--- Get the intersection points of a convex polygon and a line.
--
-- @param polygon A table that holds the polygon points.
-- @param ax The first point of the line
-- @param ay
-- @param bx The second point of the line
-- @param by
--
-- @return The two intersection points (x1, y1, x2, y2) or nil
local function lineIntersection(polygon, ax, ay, bx, by)
  return intersectionPoints(polygon, ax, ay, bx, by, false, line.lineSegIntersection)
end

--- Get the intersection points of a convex polygon and a line segment.
--
-- @param polygon A table that holds the polygon points.
-- @param ax The first point of the line segment
-- @param ay
-- @param bx The second point of the line segment
-- @param by
--
-- @return One or two intersection points (x1, y1, x2, y2) or nil
local function segIntersection(polygon, ax, ay, bx, by)
  local pointsInside = 0
  
  if containsPoint(polygon, ax, ay) then
    pointsInside = pointsInside + 1
  end
  
  if containsPoint(polygon, bx, by) then
    pointsInside = pointsInside + 1
  end
  
  if pointsInside == 2 then
    return nil
  end
  
  return intersectionPoints(polygon, ax, ay, bx, by, pointsInside == 1, line.segSegIntersection)
end

return {
  intersectionPoints = intersectionPoints,
  containsPoint = containsPoint,
  lineIntersection = lineIntersection,
  segIntersection = segIntersection
}