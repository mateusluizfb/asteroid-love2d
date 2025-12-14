local bullet = require("bullet")
local shapes = require("shapes") 

local ship = {}

local pressedKeys = {}

function ship.new(x, y)
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

function ship.update(dt, instance)
  local moveAmount = instance.speed * dt

  if love.keyboard.isDown("up") then
    instance.x = instance.x + math.cos(instance.angle) * moveAmount
    instance.y = instance.y + math.sin(instance.angle) * moveAmount
  end

  if love.keyboard.isDown("down") then
    instance.x = instance.x - math.cos(instance.angle) * moveAmount
    instance.y = instance.y - math.sin(instance.angle) * moveAmount
  end

  local turn = instance.turnSpeed * dt

  if love.keyboard.isDown("left") then 
    instance.angle = instance.angle - turn
  end

  if love.keyboard.isDown("right") then
    instance.angle = instance.angle + turn
  end

  local keys = {"space"}

  -- There might be an improvement here by using love.keypressed callback
  -- It isn't needed to check all keys every frame
  for _, key in ipairs(keys) do
    local isDown = love.keyboard.isDown(key)
    if isDown and not pressedKeys[key] then
      if key == "space" then
        local bullet = bullet.new(
          instance.x + (instance.width / 2) * math.cos(instance.angle),
          instance.y + (instance.height / 2) * math.sin(instance.angle),
          instance.angle
        )

        table.insert(objects, bullet)
      end
    end
    pressedKeys[key] = isDown
  end
end

function ship.draw(instance)
  love.graphics.setColor(0, 0.4, 0.4)
  shapes.drawTriangle(instance.x, instance.y, instance.width, instance.height, instance.angle)
end 

return ship
