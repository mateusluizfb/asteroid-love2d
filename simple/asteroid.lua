local shapes = require("shapes")

local asteroid = {}

function asteroid.new(x, y)
  return {
    type = "asteroid",
    collider = "circle",
    x = x,
    y = y,
    radius = 10,
    angle = math.random() * 2 * math.pi,
  }
end

function asteroid.collide(instance, other)
  print("Asteroid collided with " .. other.collider)
end

function asteroid.update(dt, instance)
  instance.x = instance.x + math.cos(instance.angle) * 20 * dt
  instance.y = instance.y + math.sin(instance.angle) * 20 * dt
end

function asteroid.draw(instance)
  love.graphics.setColor(0.5, 0.5, 0.5)
  shapes.drawDecagon(instance.x, instance.y, instance.angle)
end

return asteroid
