--- 2D vector math utility functions.
--
-- @module geomath.vector
-- @author Fabian Staacke
-- @copyright 2020
-- @license https://opensource.org/licenses/MIT

local M = {}

--- Compute the dot product of two vector.
--
-- @param ax The first vector
-- @param ay
-- @param bx The second vector
-- @param by
--
-- @return The dot product
function M.dot(ax, ay, bx, by)
  return ax * bx + ay * by
end

--- Return the factor for the projection of vector A onto vector B.
--
-- @param ax Vector A
-- @param ay
-- @param bx Vector B
-- @param by
--
-- @return The projection factor
function M.projectionFactor(ax, ay, bx, by)
  local dot = ax * bx + ay * by
  local squaredLength = bx * bx + by * by
  if squaredLength <= 0 then
    return nil
  end
  return dot / squaredLength
end

--- Determine if vector B is on the left or right of vector A.
--
-- @param ax Vector A
-- @param ay
-- @param bx Vector B
-- @param by
--
-- @return -1 if B is on the left of A.
--   +1 if B is on the right of A.
--   0 if A and B are parallel or antiparallel.
function M.side(ax, ay, bx, by)
  local cross = ax * by - ay * bx
  if cross < 0 then
    return -1
  elseif cross > 0 then
    return 1
  end
  return 0
end

return M