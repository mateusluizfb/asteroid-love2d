local shapes = require("shapes")

local bullet = {}

function bullet.new(x, y, angle)
  return {
    type = "bullet",
    collider = "circle", 
    x = x,
    y = y,
    angle = angle,
    radius = 5,
    speed = 100,
  }
end

function bullet.collide(instance, other)
  print("Bullet collided with " .. other.collider)
end 

function bullet.update(dt, instance)
  instance.x = instance.x + math.cos(instance.angle) * instance.speed * dt
  instance.y = instance.y + math.sin(instance.angle) * instance.speed * dt
end

function bullet.draw(instance)
  love.graphics.setColor(1, 1, 0)
  shapes.drawCircle(instance.x, instance.y, instance.radius)
end

return bullet

