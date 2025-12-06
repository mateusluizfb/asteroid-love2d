function love.load() 
  local width, height = love.graphics.getDimensions()
  windowCenterX = width / 2
  windowCenterY = height / 2

  SpaceShip = {
    x = windowCenterX,
    y = windowCenterY,
    width = 15,
    height = 30,
    angle = 0
  }
end

function updateSpaceship(spaceShip)
  local x, y = love.mouse.getPosition()

  print("mouse x: " .. x )
  print("spaceship x: " .. spaceShip.x)

  local correctionOffset = math.pi / 2
  spaceShip.angle = math.atan2(y - spaceShip.y, x - spaceShip.x) + correctionOffset
end

function love.update(dt)
  updateSpaceship(SpaceShip)
end

function drawSpaceshipMath(spaceShip)
  local width = spaceShip.width
  local height = spaceShip.height
  local angle = spaceShip.angle

  local tip_x, tip_y = 0, -height / 2
  local left_x, left_y = -width / 2, height / 2
  local right_x, right_y = width / 2, height / 2

  local cosA = math.cos(angle)
  local sinA = math.sin(angle)

  local tip_rx = tip_x * cosA - tip_y * sinA + spaceShip.x
  local tip_ry = tip_x * sinA + tip_y * cosA + spaceShip.y

  local left_rx = left_x * cosA - left_y * sinA + spaceShip.x
  local left_ry = left_x * sinA + left_y * cosA + spaceShip.y

  local right_rx = right_x * cosA - right_y * sinA + spaceShip.x
  local right_ry = right_x * sinA + right_y * cosA + spaceShip.y

  love.graphics.polygon("fill",
    tip_rx, tip_ry,
    left_rx, left_ry,
    right_rx, right_ry
  )
end


function drawSpaceshipLove(spaceShip)
  local width = spaceShip.width
  local height = spaceShip.height
  local half_width = width / 2

  love.graphics.push()

  love.graphics.translate(spaceShip.x, spaceShip.y)
  love.graphics.rotate(spaceShip.angle)

  local px1, py1 = 0, -height / 2
  local px2, py2 = -width / 2, height / 2
  local px3, py3 = width / 2, height / 2

  love.graphics.polygon("fill",
    px1, py1,
    px2, py2,
    px3, py3
  )

  love.graphics.pop()
end

function love.draw()
  love.graphics.setColor(0, 0.4, 0.4)
  drawSpaceshipLove(SpaceShip)
end
