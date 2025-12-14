local shapes = {}

function shapes.drawTriangle(x, y, width, height, angle)
  local half_width = width / 2

  love.graphics.push()

  love.graphics.translate(x, y)
  love.graphics.rotate(angle)

  local px1, py1 = width / 2, 0
  local px2, py2 = -width / 2, height / 2
  local px3, py3 = -width / 2, -height / 2

  love.graphics.polygon("fill",
    px1, py1,
    px2, py2,
    px3, py3
  )

  love.graphics.pop()
end

function shapes.drawDecagon(x, y, angle)
  love.graphics.push()

  love.graphics.translate(x, y)
  love.graphics.scale(10, 10)
  love.graphics.rotate(angle)

  local px1, py1 = 1, 2 
  local px2, py2 = 2, 3
  local px3, py3 = 3, 1
  local px4, py4 = 2, -1
  local px5, py5 = 3, -2
  local px6, py6 = -1, -3
  local px7, py7 = -1, -2
  local px8, py8 = -3, -1
  local px9, py9 = -1, 1
  local px10, py10 = -1, 3

  love.graphics.polygon("fill",
    px1, py1,
    px2, py2,
    px3, py3,
    px4, py4,
    px5, py5,
    px6, py6,
    px7, py7,
    px8, py8,
    px9, py9,
    px10, py10
  )

  love.graphics.pop()
end

function shapes.drawCircle(x, y, radius)
  love.graphics.circle("fill", x, y, radius)
end

return shapes
