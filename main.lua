function newShip(x, y)
  return {
    x = x,
    y = y,
    width = 30,
    height = 15,
    angle = 0,
    speed = 50,
    turnSpeed = 2,
  }
end

function newAsteroid(x, y)
  return {
    x = x,
    y = y,
    angle = math.random() * 2 * math.pi,
  }
end

function love.load() 
  local width, height = love.graphics.getDimensions()
  windowCenterX = width / 2
  windowCenterY = height / 2

  ship = newShip(windowCenterX, windowCenterY)

  asteroids = {}
  asteroids_timer = 0
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

function updateAsteroids(dt)
  asteroids_timer = asteroids_timer + dt

  if asteroids_timer >= 2 then
    asteroids_timer = 0

    local asteroid = newAsteroid(
      math.random(0, love.graphics.getWidth()),
      math.random(0, love.graphics.getHeight())
    )

    table.insert(asteroids, asteroid)
  end

  for _, asteroid in ipairs(asteroids) do
    asteroid.x = asteroid.x + math.cos(asteroid.angle) * 20 * dt
    asteroid.y = asteroid.y + math.sin(asteroid.angle) * 20 * dt
  end
end

function love.update(dt)
  updateSpaceship(dt, ship)
  updateAsteroids(dt)
end

function drawTriangle(x, y, width, height, angle)
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

function drawDecagon(x, y, angle)
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

function love.draw()
  love.graphics.setColor(0, 0.4, 0.4)
  drawTriangle(ship.x, ship.y, ship.width, ship.height, ship.angle)
  
  for _, asteroid in ipairs(asteroids) do
   love.graphics.setColor(0.5, 0.5, 0.5)
   drawDecagon(asteroid.x, asteroid.y, asteroid.angle)
  end
end
