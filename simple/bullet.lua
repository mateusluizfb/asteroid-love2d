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
    isDead = false
  }
end

function bullet.collide(instance, other)
  print("Bullet collided with " .. other.collider)

  if other.type == "asteroid" then
    instance.isDead = true
    other.isDead = true
  end
end 

function bullet.update(dt, instance)
  instance.x = instance.x + math.cos(instance.angle) * instance.speed * dt
  instance.y = instance.y + math.sin(instance.angle) * instance.speed * dt

  if instance.x < 0 or instance.x > globalState.windowWidth or
     instance.y < 0 or instance.y > globalState.windowHeight then
    
    print("Bullet went out of bounds and is removed")

    instance.isDead = true
  end
end

function bullet.draw(instance)
  love.graphics.setColor(1, 1, 0)
  shapes.drawCircle(instance.x, instance.y, instance.radius)
end

return bullet

