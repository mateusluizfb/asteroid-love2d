local ship = require("ship")
local bullet = require("bullet") 
local asteroid = require("asteroid")
local shapes = require("shapes")

local dispatchTable = {
  ship = ship,
  bullet = bullet,
  asteroid = asteroid
}

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
    updateFn = dispatchTable[object.type].update
    updateFn(dt, object)
  end
end

function love.draw()
  for _, object in ipairs(objects) do
    drawFn = dispatchTable[object.type].draw
    drawFn(object)
  end
end
