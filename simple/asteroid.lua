local shapes = require("shapes")

local asteroid = {}

function asteroid.new(x, y)
  return {
    type = "asteroid",
    collider = "circle",
    x = x,
    y = y,
    radius = 20,
    angle = math.random() * 2 * math.pi,
    isDead = false
  }
end

function asteroid.collide(instance, other)
  print("Asteroid collided with " .. other.collider)
end

function asteroid.update(dt, instance)
  instance.x = instance.x + math.cos(instance.angle) * 20 * dt
  instance.y = instance.y + math.sin(instance.angle) * 20 * dt

  if instance.x < globalState.windowWidth * -0.1 or instance.x > globalState.windowWidth * 1.1 or
     instance.y < globalState.windowHeight * -0.1 or instance.y > globalState.windowHeight * 1.1 then
    
    print("Asteroid went out of bounds and is removed")
    instance.isDead = true
  end
end

function asteroid.draw(instance)
  love.graphics.setColor(0.5, 0.5, 0.5)
  shapes.drawDecagon(instance.x, instance.y, instance.angle)
end

return asteroid
