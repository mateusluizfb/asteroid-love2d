function love.load() 
  local width, height = love.graphics.getDimensions()
  windowCenterX = width / 2
  windowCenterY = height / 2

  SpaceShip = {
    x = windowCenterX,
    y = windowCenterY,
    width = 30,
    height = 15,
    angle = 0,
    speed = 20,
    turnSpeed = 2,
  }
end

function updateSpaceship(dt, spaceShip)
  local moveAmount = spaceShip.speed * dt

  if love.keyboard.isDown("up") then
    spaceShip.x = spaceShip.x + math.cos(spaceShip.angle) * moveAmount
    spaceShip.y = spaceShip.y + math.sin(spaceShip.angle) * moveAmount
  end

  if love.keyboard.isDown("down") then
    spaceShip.x = spaceShip.x - math.cos(spaceShip.angle) * moveAmount
    spaceShip.y = spaceShip.y - math.sin(spaceShip.angle) * moveAmount
  end

  local turn = spaceShip.turnSpeed * dt

  if love.keyboard.isDown("left") then 
    spaceShip.angle = spaceShip.angle - turn
  end

  if love.keyboard.isDown("right") then
    spaceShip.angle = spaceShip.angle + turn
  end
end

function love.update(dt)
 updateSpaceship(dt, SpaceShip)
end

function drawSpaceshipLove(spaceShip)
  local width = spaceShip.width
  local height = spaceShip.height
  local half_width = width / 2

  love.graphics.push()

  love.graphics.translate(spaceShip.x, spaceShip.y)
  love.graphics.rotate(spaceShip.angle)

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

function love.draw()
  love.graphics.setColor(0, 0.4, 0.4)
  drawSpaceshipLove(SpaceShip)
end
