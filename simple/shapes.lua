local shapes = {}

function _clamp(value, min, max)
  if value < min then
    return min
  elseif value > max then
    return max
  else
    return value
  end
end

function shapes.checkCollision(objA, objB)
  if objA.collider == "circle" and objB.collider == "circle" then
    local dx = objA.x - objB.x
    local dy = objA.y - objB.y
    local distance = math.sqrt(dx * dx + dy * dy)
    return distance < (objA.radius + objB.radius)
  end

  if objA.collider == "triangle" and objB.collider == "circle" or
    objA.collider == "circle" and objB.collider == "triangle" then

    local triangle, circle

    if objA.collider == "triangle" then
      triangle = objA
      circle = objB
    else
      triangle = objB
      circle = objA
    end

    local half_width = triangle.width / 2
    local half_height = triangle.height / 2

    local cx = circle.x - triangle.x
    local cy = circle.y - triangle.y

    local cos_angle = math.cos(-triangle.angle)
    local sin_angle = math.sin(-triangle.angle)

    local rotated_cx = cx * cos_angle - cy * sin_angle
    local rotated_cy = cx * sin_angle + cy * cos_angle

    local closest_x = _clamp(rotated_cx, -half_width, half_width)
    local closest_y = _clamp(rotated_cy, -half_height, half_height)

    local dx = rotated_cx - closest_x
    local dy = rotated_cy - closest_y

    return (dx * dx + dy * dy) < (circle.radius * circle.radius)
  end

  return false
end

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
