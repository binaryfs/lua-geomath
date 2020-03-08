--- Utility functions.
--
-- @module geomath.utils
-- @author Fabian Staacke
-- @copyright 2020
-- @license https://opensource.org/licenses/MIT

local abs = math.abs
local utils = {}
local epsilon = 0.00001

--- Test whether to floating point values are nearly equal.
--
-- The formula used by this method was taken from this page:
-- https://isocpp.org/wiki/faq/newbie#floating-point-arith
--
-- Please note the following (quoted analogously from the above page):
-- This solution is not completely symmetric, meaning it is possible for
-- nearlyEqual(a,b) ~= nearlyEqual(b,a). From a practical standpoint, this
-- does not usually occur when the magnitudes of a and b are significantly
-- larger than epsilon, but your mileage may vary.
--
-- @param a The first value
-- @param b The second value
--
-- @return True if the values are nearly equal, false otherwise
function utils.nearlyEqual(a, b)
  return abs(a - b) <= epsilon * abs(a);
end

--- Specify the error margin allowed for floating point comparisons.
-- @param value The new value for epsilon
-- @raise Epsilon must be a positive number between 0 and 1
function utils.setEpsilon(value)
  if type(value) ~= "number" or value <= 0 or value >= 1 then
    error("Epsilon must be a positive number between 0 and 1")
  end
  epsilon = value
end

return utils