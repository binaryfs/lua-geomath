--- Geometric calculations for circles.
--
-- @module geomath.circles
-- @author Fabian Staacke
-- @copyright 2020
-- @license https://opensource.org/licenses/MIT

local BASE = (...):gsub("%.circle$", "")
local vector = require(BASE .. ".vector")

local abs, sqrt = math.abs, math.sqrt

--- Test if a given point is contained within a circle (excluding its borders).
--
-- @param x The center of the circle
-- @param y
-- @param r The radius of the circle
-- @param px The point
-- @param py
--
-- @return True if the point is contained, false otherwise
local function containsPoint(x, y, r, px, py)
  return (x - px) ^ 2 + (y - py) ^ 2 < r * r
end

-- Compute the intersection factors of a circle-line intersection.
-- The intersection factors determine the positions of the intersection
-- points on the line. 0 = on the start point of the line, 1 = on the
-- end point of the line.
--
-- @param x The center of the circle
-- @param y
-- @param r The radius of the circle
-- @param ax The first point of the line or line segment
-- @param ay
-- @param bx The second point of the line or line segment
-- @param by
--
-- @return The two intersection factors (f1, f3) or nil
-- @local
local function intersectionFactors(cx, cy, r, ax, ay, bx, by)
  local abx, aby = bx - ax, by - ay
  local cax, cay = ax - cx, ay - cy
  
  local a = vector.dot(abx, aby, abx, aby)
  local b = vector.dot(cax, cay, abx, aby) * 2
  local c = vector.dot(cax, cay, cax, cay) - r * r
  
  local disc = b^2 - 4 * a * c
  
  if disc < 0 then
    return nil
  end
  
  disc = sqrt(disc)
  
  local f1 = (-b + disc) / (2 * a)
  local f2 = (-b - disc) / (2 * a)
  
  -- Swap the factors if the second intersection comes first.
  if f2 < f1 then
    f1, f2 = f2, f1
  end
  
  return f1, f2
end

--- Get the intersection points of two circle.
--
-- This algorithm is based on an article of Paul Bourke:
-- http://paulbourke.net/geometry/circlesphere/
--
-- @param cx1 The center of the first circle
-- @param cy1
-- @param cr1 The radius of the first circle
-- @param cx2 The center of the second circle
-- @param cy2
-- @param cr2 The radius of the second circle
--
-- @return The two intersection points (x1, y1, x2, y2) or nil
local function circleIntersection(cx1, cy1, cr1, cx2, cy2, cr2)
  local dx, dy = cx2 - cx1, cy2 - cy1
  local dist = dx^2 + dy^2

  -- Check if circles are separate or coincident.
  if dist > (cr1 + cr2) ^ 2 or dist == 0 then
    return nil
  end

  -- Check if one circle is contained within the other.
  if dist < abs(cr1 - cr2) ^ 2 then
    return nil
  end

  dist = sqrt(dist)

  local a = (cr1^2 - cr2^2 + dist^2) / (2 * dist)

  -- Get the intermediate point between the intersection points.
  local px = cx1 + dx * a / dist
  local py = cy1 + dy * a / dist

  local h = sqrt(cr1^2 - a^2)

  -- Offset of intersection points from the intermediate point.
  local ox = -dy * (h / dist)
  local oy = dx * (h / dist)

  return px - ox, py - oy, px + ox, py + oy
end

--- Get the intersection points of a circle and a line.
--
-- @param x The center of the circle
-- @param y
-- @param r The radius of the circle
-- @param ax The first point of the line
-- @param ay
-- @param bx The second point of the line
-- @param by
--
-- @return The two intersection points (x1, y1, x2, y2) or nil
local function lineIntersection(cx, cy, r, ax, ay, bx, by)
  local abx, aby = bx - ax, by - ay
  local f1, f2 = intersectionFactors(cx, cy, r, ax, ay, bx, by)
  
  if not f1 then
    return nil
  end
  
  return ax + abx * f1, ay + aby * f1,
    ax + abx * f2, ay + aby * f2
end

--- Get the intersection points of a circle and a line segment.
--
-- @param x The center of the circle
-- @param y
-- @param r The radius of the circle
-- @param ax The first point of the line segment
-- @param ay
-- @param bx The second point of the line segment
-- @param by
--
-- @return One or two intersection points (x1, y1, x2, y2) or nil
local function segIntersection(cx, cy, r, ax, ay, bx, by)
  local abx, aby = bx - ax, by - ay
  local f1, f2 = intersectionFactors(cx, cy, r, ax, ay, bx, by)
  
  if not f1 then
    return nil
  end
  
  local px1, py1, px2, py2
  
  -- Is the second intersection point on the line segment?
  if f2 >= 0 and f2 <= 1 then
    px2, py2 = ax + abx * f2, ay + aby * f2
  end
  
  -- Is the first intersection point on the line segment?
  if f1 >= 0 and f1 <= 1 then
    px1, py1 = ax + abx * f1, ay + aby * f1
  else
    px1, py1 = px2, py2
  end
  
  return px1, py1, px2, py2
end

--- Get the tangent points from an external point to a circle.
--
-- @param x The center of the circle
-- @param y
-- @param r The radius of the circle
-- @param px The external point
-- @param py
-- @param[opt] dist The distance between the point and the circle's center.
--   If omitted, the distance is calculated automatically.
--
-- @return One or two tangent points on the circle (x1, y1, x2, y2).
--   nil if the external point is inside the circle.
local function tangentsFromPoint(cx, cy, r, px, py, dist)
  local dirX, dirY = (cx - px) * 0.5, (cy - py) * 0.5
  dist = dist or math.sqrt(dirX ^ 2 + dirY ^ 2)

  local tx1, ty1, tx2, ty2 = circleIntersection(
    px + dirX, py + dirY, dist, cx, cy, r
  )

  if not tx1 then
    -- The point is inside the circle.
    return nil
  end

  return tx1, ty1, tx2, ty2
end

return {
  containsPoint = containsPoint,
  circleIntersection = circleIntersection,
  lineIntersection = lineIntersection,
  segIntersection = segIntersection,
  tangentsFromPoint = tangentsFromPoint
}