local ship = require("ship")
local bullet = require("bullet") 
local asteroid = require("asteroid")
local shapes = require("shapes")

function love.load() 
  local width, height = love.graphics.getDimensions() 
  local windowCenterX = width / 2
  local windowCenterY = height / 2
  local player = ship.new(windowCenterX, windowCenterY)

  asteroids_timer = 0
  objects = {player}
end

function love.update(dt)
  -- Handle asteroid spawning
  asteroids_timer = asteroids_timer + dt

  if asteroids_timer >= 2 then
    asteroids_timer = 0

    local asteroid = asteroid.new(
      math.random(0, love.graphics.getWidth()),
      math.random(0, love.graphics.getHeight())
    )

    table.insert(objects, asteroid)
  end

  -- Update all objects
  for _, object in ipairs(objects) do
    if object.type == "ship" then
      ship.update(dt, object)
    end

    if object.type == "asteroid" then
      asteroid.update(dt, object)
    end

    if object.type == "bullet" then
      bullet.update(dt, object)
    end
  end
end

function love.draw()
  for _, object in ipairs(objects) do
    if object.type == "ship" then
      ship.draw(object)
    end

    if object.type == "asteroid" then
      asteroid.draw(object)
    end

    if object.type == "bullet" then
      bullet.draw(object)
    end
  end
end
