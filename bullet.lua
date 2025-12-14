local bullet = {}

function bullet.new(x, y, angle)
  return {
    type = "bullet",
    x = x,
    y = y,
    angle = angle,
    speed = 100,
  }
end

function bullet.update(dt, instance)
  instance.x = instance.x + math.cos(instance.angle) * instance.speed * dt
  instance.y = instance.y + math.sin(instance.angle) * instance.speed * dt
end

function bullet.draw(instance)
  love.graphics.setColor(1, 1, 0)
  love.graphics.circle("fill", instance.x, instance.y, 5)
end

return bullet

