--- Geometric calculations for lines and line segments.
--
-- @module geomath.line
-- @author Fabian Staacke
-- @copyright 2020
-- @license https://opensource.org/licenses/MIT

local BASE = (...):gsub("%.[^%.]+$", "")
local vector = require(BASE .. ".vector")

local sqrt = math.sqrt

--- Get the closest point on a line to another point P.
--
-- @param ax The first point of the line
-- @param ay
-- @param bx The second point of the line
-- @param by
-- @param px The point P
-- @param py
--
-- @return The closest point (x, y)
local function closestPointOnLine(ax, ay, bx, by, px, py)
  local abx, aby = bx - ax, by - ay
  local f = vector.projectionFactor(px - ax, py - ay, abx, aby)
  return ax + abx * f, ay + aby * f
end

--- Get the closest point on a line segment AB to another point P.
--
-- @param ax The first point of the line segment
-- @param ay
-- @param bx The second point of the line segment
-- @param by
-- @param px The point P
-- @param py
--
-- @return The closest point (x, y)
local function closestPointOnSeg(ax, ay, by, bx, px, py)
  local abx, aby = bx - ax, by - ay
  local f = vector.projectionFactor(px - ax, py - ay, abx, aby)
  
  if f <= 0 then
    return ax, ay
  elseif f >= 1 then
    return bx, by
  end
  
  return ax + abx * f, ay + aby * f
end

--- Get the shortest distance between a line and a point.
--
-- @param ax The first point of the line
-- @param ay
-- @param bx The second point of the line
-- @param by
-- @param px The point
-- @param py
--
-- @return Shortest distance
local function linePointDistance(ax, ay, bx, by, px, py)
  local cx, cy = closestPointOnLine(ax, ay, bx, by, px, py)
  local cpx, cpy = px - cx, py - cy
  return sqrt(cpx * cpx + cpy * cpy)
end

--- Get the shortest distance between a line segment and a point.
--
-- @param ax The first point of the line segment
-- @param ay
-- @param bx The second point of the line segment
-- @param by
-- @param px The point
-- @param py
--
-- @return Shortest distance
local function segPointDistance(ax, ay, bx, by, px, py)
  local cx, cy = closestPointOnSeg(ax, ay, bx, by, px, py)
  local cpx, cpy = px - cx, py - cy
  return sqrt(cpx * cpx + cpy * cpy)
end

--- Get the intersection point of two line.
--
-- @param ax The first point of the first line
-- @param ay
-- @param bx The second point of the first line
-- @param by
-- @param cx The first point of the second line
-- @param cy
-- @param dx The second point of the second line
-- @param dy
--
-- @return The intersection point (x, y) or nil
local function lineLineIntersection(ax, ay, bx, by, cx, cy, dx, dy)
  local cross1 = (ax - bx) * (cy - dy) - (ay - by) * (cx - dx)
  
  if cross1 == 0 then
    -- Lines are parallel or antiparallel.
    return nil
  end
  
  local cross2 = ax * by - ay * bx
  local cross3 = cx * dy - cy * dx
  local px = (cross2 * (cx - dx) - (ax - bx) * cross3) / cross1
  local py = (cross2 * (cy - dy) - (ay - by) * cross3) / cross1
  
  return px, py
end

--- Get the intersection point of a line and a line segment.
--
-- @param ax The first point of the first line
-- @param ay
-- @param bx The second point of the first line
-- @param by
-- @param cx The first point of the second line segment
-- @param cy
-- @param dx The second point of the second line segment
-- @param dy
--
-- @return[1] The intersection point (x) or nil
-- @return[2] The intersection point (y)
-- @return[3] The projection factor of that point onto the line segment
local function lineSegIntersection(ax, ay, bx, by, cx, cy, dx, dy)
  local px, py = lineLineIntersection(ax, ay, bx, by, cx, cy, dx, dy)
  
  if not px then
    return nil
  end
  
  local f = vector.projectionFactor(px - cx, py - cy, dx - cx, dy - cy)
  
  if f < 0 or f > 1 then
    return nil
  end
  
  return px, py, f
end

--- Get the intersection point of two line segments.
--
-- @param ax The first point of the first line segment
-- @param ay
-- @param bx The second point of the first line segment
-- @param by
-- @param cx The first point of the second line segment
-- @param cy
-- @param dx The second point of the second line segment
-- @param dy
--
-- @return[1] The intersection point (x) or nil
-- @return[2] The intersection point (y)
-- @return[3] The projection factor of that point onto the first line segment
local function segSegIntersection(ax, ay, bx, by, cx, cy, dx, dy)
  local px, py = lineSegIntersection(ax, ay, bx, by, cx, cy, dx, dy)
  
  if not px then
    return nil
  end
  
  local f = vector.projectionFactor(px - ax, py - ay, bx - ax, by - ay)
  
  if f < 0 or f > 1 then
    return nil
  end
  
  return px, py, f
end

return {
  closestPointOnLine = closestPointOnLine,
  closestPointOnSeg = closestPointOnSeg,
  linePointDistance = linePointDistance,
  segPointDistance = segPointDistance,
  lineLineIntersection = lineLineIntersection,
  lineSegIntersection = lineSegIntersection,
  segSegIntersection = segSegIntersection
}