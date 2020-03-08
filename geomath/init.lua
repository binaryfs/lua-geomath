--- 2D math module for geometric calculations
-- @module geomath
-- @author Fabian Staacke
-- @copyright 2020
-- @license https://opensource.org/licenses/MIT

local BASE = (...):gsub("%.[^%.]+$", "")

return {
  _NAME = "geomath",
  _DESCRIPTION = "2D math module for geometric calculations",
  _VERSION = "1.0.0",
  _URL = "https://github.com/binaryfs/lua-geomath",
  _LICENSE = "MIT License",
  _COPYRIGHT = "Copyright (c) 2020 Fabian Staacke",

  circle = require(BASE .. ".circle"),
  ellipse = require(BASE .. ".ellipse"),
  line = require(BASE .. ".line"),
  polygon = require(BASE .. ".polygon"),
  rect = require(BASE .. ".rect"),
  utils = require(BASE .. ".utils"),
  vector = require(BASE .. ".vector")
}