-- Component definitions
-- Components are pure data with no behavior

local Components = {}

-- Health component
function Components.Health(maxHealth)
  return {
    maxHealth = maxHealth or 100,
    currentHealth = maxHealth or 100
  }
end

-- Damage component
function Components.Damage(amount)
  return {
    amount = amount or 10
  }
end

-- Position component
function Components.Position(x, y)
  return {
    x = x or 0,
    y = y or 0
  }
end

-- Velocity component
function Components.Velocity(dx, dy, angle)
  return {
    dx = dx or 0,
    dy = dy or 0,
    angle = angle or 0,
    speed = 0
  }
end

-- Rotation component
function Components.Rotation(angle, turnSpeed)
  return {
    angle = angle or 0,
    turnSpeed = turnSpeed or 0
  }
end

-- Colliding component
function Components.Colliding(isColliding)
  return {
    isColliding = isColliding or false
  }
end

-- Circle collider component
function Components.CircleCollider(radius)
  return {
    type = "circle",
    radius = radius or 10
  }
end

-- Triangle collider component
function Components.TriangleCollider(width, height)
  return {
    type = "triangle",
    width = width or 30,
    height = height or 15
  }
end

-- Renderable components for different shapes
function Components.CircleRenderable(radius, r, g, b)
  return {
    shape = "circle",
    radius = radius or 5,
    color = {r or 1, g or 1, b or 1}
  }
end

function Components.TriangleRenderable(width, height, r, g, b)
  return {
    shape = "triangle",
    width = width or 30,
    height = height or 15,
    color = {r or 1, g or 1, b or 1}
  }
end

function Components.DecagonRenderable(r, g, b)
  return {
    shape = "decagon",
    color = {r or 0.5, g or 0.5, b or 0.5}
  }
end

-- Player input component (marks entity as player-controlled)
function Components.PlayerInput(speed, turnSpeed)
  return {
    speed = speed or 50,
    turnSpeed = turnSpeed or 2,
    pressedKeys = {}
  }
end

-- Tag components (no data, just markers)
function Components.Ship()
  return {tag = "ship"}
end

function Components.Bullet()
  return {tag = "bullet"}
end

function Components.Asteroid()
  return {tag = "asteroid"}
end

return Components
