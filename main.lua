function newShip(x, y)
  return {
    type = "ship",
    x = x,
    y = y,
    width = 30,
    height = 15,
    angle = 0,
    speed = 50,
    turnSpeed = 2,
  }
end

function newBullet(x, y, angle)
  return {
    type = "bullet",
    x = x,
    y = y,
    angle = angle,
    speed = 100,
  }
end

function newAsteroid(x, y)
  return {
    type = "asteroid",
    x = x,
    y = y,
    angle = math.random() * 2 * math.pi,
  }
end

function love.load() 
  local width, height = love.graphics.getDimensions()
  windowCenterX = width / 2
  windowCenterY = height / 2

  pressedKeys = {}

  local ship = newShip(windowCenterX, windowCenterY)
  bullets = {}

  asteroids_timer = 0

  objects = {ship}
end

function updateSpaceship(dt, ship)
  local moveAmount = ship.speed * dt

  if love.keyboard.isDown("up") then
    ship.x = ship.x + math.cos(ship.angle) * moveAmount
    ship.y = ship.y + math.sin(ship.angle) * moveAmount
  end

  if love.keyboard.isDown("down") then
    ship.x = ship.x - math.cos(ship.angle) * moveAmount
    ship.y = ship.y - math.sin(ship.angle) * moveAmount
  end

  local turn = ship.turnSpeed * dt

  if love.keyboard.isDown("left") then 
    ship.angle = ship.angle - turn
  end

  if love.keyboard.isDown("right") then
    ship.angle = ship.angle + turn
  end

  local keys = {"space"}

  for _, key in ipairs(keys) do
    local isDown = love.keyboard.isDown(key)
    if isDown and not pressedKeys[key] then
      if key == "space" then
        local bullet = newBullet(
          ship.x + (ship.width / 2) * math.cos(ship.angle),
          ship.y + (ship.height / 2) * math.sin(ship.angle),
          ship.angle
        )

        table.insert(bullets, bullet)
      end
    end
    pressedKeys[key] = isDown
  end
end

function updateBullets(dt)
   -- TODO: When bullets go off screen, remove them from the table
  for _, bullet in ipairs(bullets) do
    bullet.x = bullet.x + math.cos(bullet.angle) * bullet.speed * dt
    bullet.y = bullet.y + math.sin(bullet.angle) * bullet.speed * dt
  end 
end

function updateAsteroid(dt, asteroid)
  asteroid.x = asteroid.x + math.cos(asteroid.angle) * 20 * dt
  asteroid.y = asteroid.y + math.sin(asteroid.angle) * 20 * dt
end

function love.update(dt)
  asteroids_timer = asteroids_timer + dt

  if asteroids_timer >= 2 then
    asteroids_timer = 0

    local asteroid = newAsteroid(
      math.random(0, love.graphics.getWidth()),
      math.random(0, love.graphics.getHeight())
    )

    table.insert(objects, asteroid)
  end

  -- updateAsteroids(dt)
  updateBullets(dt)

  for _, object in ipairs(objects) do
    if object.type == "ship" then
      updateSpaceship(dt, object)
    end

    if object.type == "asteroid" then
      updateAsteroid(dt, object)
    end
  end
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

function drawCircle(x, y, radius)
  love.graphics.circle("fill", x, y, radius)
end

function love.draw()
  for _, object in ipairs(objects) do
    if object.type == "ship" then
      love.graphics.setColor(0, 0.4, 0.4)
      drawTriangle(object.x, object.y, object.width, object.height, object.angle)
    end

    if object.type == "asteroid" then
      love.graphics.setColor(0.5, 0.5, 0.5)
      drawDecagon(object.x, object.y, object.angle)
    end
  end

  for _, bullet in ipairs(bullets) do
    love.graphics.setColor(1, 1, 0)
    drawCircle(bullet.x, bullet.y, 3)
  end 
end
