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

  globalState = {
    windowWidth = width,
    windowHeight = height
  }

  astroidsTimer = 0
  objects = {player}
end

function love.update(dt)
  -- Handle asteroid spawning
  astroidsTimer = astroidsTimer + dt

  if astroidsTimer >= 2 then
    astroidsTimer = 0

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

  -- Check for collisions
  -- Naive O(n^2) collision detection for demonstration purposes
  for i = 1, #objects do
    for j = i + 1, #objects do
      local objA = objects[i]
      local objB = objects[j]
      
      if shapes.checkCollision(objA, objB) then
        collideFnA = dispatchTable[objA.type].collide
        collideFnB = dispatchTable[objB.type].collide
      
        if collideFnA then
          collideFnA(objA, objB)
        end

        if collideFnB then
          collideFnB(objB, objA)
        end
      end
    end
  end

  -- Check for dead objects and remove them
  for i = #objects, 1, -1 do
    if objects[i].isDead then
      table.remove(objects, i)
    end
  end

  -- Count fps:
  local fps = love.timer.getFPS()
  love.window.setTitle("Simple Asteroids - FPS: " .. fps)
end

function love.draw()
  for _, object in ipairs(objects) do
    drawFn = dispatchTable[object.type].draw
    drawFn(object)
  end
end
