-- LÖVE geomath demo script.

local geomath = require "geomath"
local lg = love.graphics

local rectangle = {50, 50, 300, 200}
local circle = {600, 200, 120}
local ellipse = {240, 480, 160, 70}
local polygon = {580, 360, 720, 440, 730, 500, 550, 550, 470, 430}
local line = {120, 380, 330, 270}

local probe = {360, 300, 440, 390}

local function rgba(r, g, b, a)
  return {r / 255, g / 255, b / 255, a or 1}
end

local color = {
  white = rgba(255, 255, 255),
  transparentWhite = rgba(255, 255, 255, 0.5),
  dark = rgba(48, 50, 72),
  green = rgba(60, 188, 158),
  blue = rgba(86, 86, 180),
  yellow = rgba(230, 206, 106),
  orange = rgba(230, 160, 90),
  red = rgba(240, 80, 50, 1),
  transparentRed = rgba(240, 80, 50, 0.5)
}

-- Draw a dashed line.
local function dashedLine(ax, ay, bx, by, dashLength, gapLength)
  local dirX, dirY = bx - ax, by - ay
  local length = math.sqrt(dirX ^ 2 + dirY ^ 2)
  local segmentLength = dashLength + (gapLength or dashLength)

  if length == 0 then
    return
  end
  
  dirX, dirY = dirX / length, dirY / length

  for i = 1, math.floor(length / segmentLength) do
    lg.line(ax, ay, ax + dirX * dashLength, ay + dirY * dashLength)
    ax, ay = ax + dirX * segmentLength, ay + dirY * segmentLength
  end
  
  lg.line(ax, ay, bx, by)
end

local function drawIntersectionMarker(x, y, color)
  lg.setColor(color)
  lg.circle("line", x, y, 6)
end

local function drawIntersections(px1, py1, px2, py2, px3, py3, px4, py4)
  if px1 then
    drawIntersectionMarker(px1, py1, color.white)
    drawIntersectionMarker(px2, py2, color.white)
  end

  if px3 then
    drawIntersectionMarker(px3, py3, color.red)
  end

  if px4 then
    drawIntersectionMarker(px4, py4, color.red)
  end
end

-- Draw the line and its intersection points.
local function lineIntersections()
  lg.setColor(color.white)
  lg.line(line)

  local px1, py1 = geomath.line.lineSegIntersection(
    probe[1], probe[2], probe[3], probe[4], unpack(line)
  )

  if px1 then
    drawIntersectionMarker(px1, py1, color.white)
  end

  local px2, py2 = geomath.line.segSegIntersection(
    probe[1], probe[2], probe[3], probe[4], unpack(line)
  )

  if px2 then
    drawIntersectionMarker(px2, py2, color.red)
  end
end

-- Draw the rectangle and its intersection points.
local function rectangleIntersections()
  lg.setColor(color.green)
  lg.rectangle("fill", unpack(rectangle))
  lg.setColor(color.white)
  lg.rectangle("line", unpack(rectangle))

  local px1, py1, px2, py2 = geomath.rect.lineIntersection(
    rectangle[1], rectangle[2], rectangle[3], rectangle[4], unpack(probe)
  )

  local px3, py3, px4, py4 = geomath.rect.segIntersection(
    rectangle[1], rectangle[2], rectangle[3], rectangle[4], unpack(probe)
  )

  drawIntersections(px1, py1, px2, py2, px3, py3, px4, py4)
end

-- Draw the polygon and its intersection points.
local function polygonIntersections()
  lg.setColor(color.blue)
  lg.polygon("fill", polygon)
  lg.setColor(color.white)
  lg.polygon("line", polygon)

  local px1, py1, px2, py2 = geomath.polygon.lineIntersection(polygon, unpack(probe))
  local px3, py3, px4, py4 = geomath.polygon.segIntersection(polygon, unpack(probe))

  drawIntersections(px1, py1, px2, py2, px3, py3, px4, py4)
end

-- Draw the circle and its intersection points.
local function circleIntersections()
  lg.setColor(color.yellow)
  lg.circle("fill", unpack(circle))
  lg.setColor(color.white)
  lg.circle("line", unpack(circle))

  local px1, py1, px2, py2 = geomath.circle.lineIntersection(
    circle[1], circle[2], circle[3], unpack(probe)
  )

  local px3, py3, px4, py4 = geomath.circle.segIntersection(
    circle[1], circle[2], circle[3], unpack(probe)
  )

  drawIntersections(px1, py1, px2, py2, px3, py3, px4, py4)

  -- Calculate tangents from probe point to circle.

  local tx1, ty1, tx2, ty2 = geomath.circle.tangentsFromPoint(
    circle[1], circle[2], circle[3], probe[1], probe[2]
  )

  if tx1 then
    lg.setColor(color.transparentWhite)
    dashedLine(probe[1], probe[2], tx1, ty1, 4, 8)
    dashedLine(probe[1], probe[2], tx2, ty2, 4, 8)
  end
end

-- Draw the ellipse and its intersection points.
local function ellipseIntersections()
  lg.setColor(color.orange)
  lg.ellipse("fill", unpack(ellipse))
  lg.setColor(color.white)
  lg.ellipse("line", unpack(ellipse))

  local px1, py1, px2, py2 = geomath.ellipse.lineIntersection(
    ellipse[1], ellipse[2], ellipse[3], ellipse[4], unpack(probe)
  )

  local px3, py3, px4, py4 = geomath.ellipse.segIntersection(
    ellipse[1], ellipse[2], ellipse[3], ellipse[4], unpack(probe)
  )

  drawIntersections(px1, py1, px2, py2, px3, py3, px4, py4)
end

-- Draw the probing line.
local function drawProbe()
  local screenWidth, screenHeight = lg.getDimensions()
  local sx1, sy1, sx2, sy2 = geomath.rect.lineIntersection(
    0, 0, screenWidth, screenHeight, unpack(probe)
  )

  if sx1 and sx2 then
    lg.setColor(color.transparentRed)
    dashedLine(sx1, sy1, sx2, sy2, 4, 8)
  end

  lg.setColor(color.red)
  lg.line(probe)
end

function love.load()
  assert((love.getVersion()) == 11, "This demo requires LÖVE 11.x")
end

function love.draw()
  lg.setBackgroundColor(color.dark)
  lg.setLineWidth(2)

  rectangleIntersections()
  polygonIntersections()
  circleIntersections()
  ellipseIntersections()
  lineIntersections()

  drawProbe()

  local screenWidth, screenHeight = lg.getDimensions()
  lg.setColor(color.white)
  lg.print("geomath " .. geomath._VERSION, screenWidth - 100, screenHeight - 24)
  lg.print("Press left/right mouse button to move the red line", 10, screenHeight - 24)
end

function love.mousepressed(x, y, button)
  if button == 1 then
    probe[1], probe[2] = x, y
  elseif button == 2 then
    probe[3], probe[4] = x, y
  end
end