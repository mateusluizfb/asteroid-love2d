-- Systems contain behavior and operate on entities with specific components
local ECS = require("ecs")
local Components = require("components")

local Systems = {}

-- Movement System: Updates position based on velocity
Systems.Movement = {}
function Systems.Movement.update(dt)
  local entities = ECS.getEntitiesWith("Position", "Velocity")
  
  for _, entityId in ipairs(entities) do
    local pos = ECS.getComponent(entityId, "Position")
    local vel = ECS.getComponent(entityId, "Velocity")
    
    pos.x = pos.x + vel.dx * dt
    pos.y = pos.y + vel.dy * dt
  end
end

-- Player Input System: Handles keyboard input for player-controlled entities
Systems.PlayerInput = {}
function Systems.PlayerInput.update(dt)
  local entities = ECS.getEntitiesWith("Position", "Rotation", "PlayerInput")
  
  for _, entityId in ipairs(entities) do
    local pos = ECS.getComponent(entityId, "Position")
    local rot = ECS.getComponent(entityId, "Rotation")
    local input = ECS.getComponent(entityId, "PlayerInput")
    
    local moveAmount = input.speed * dt
    
    if love.keyboard.isDown("up") then
      pos.x = pos.x + math.cos(rot.angle) * moveAmount
      pos.y = pos.y + math.sin(rot.angle) * moveAmount
    end
    
    if love.keyboard.isDown("down") then
      pos.x = pos.x - math.cos(rot.angle) * moveAmount
      pos.y = pos.y - math.sin(rot.angle) * moveAmount
    end
    
    local turn = input.turnSpeed * dt
    
    if love.keyboard.isDown("left") then
      rot.angle = rot.angle - turn
    end
    
    if love.keyboard.isDown("right") then
      rot.angle = rot.angle + turn
    end
    
    -- Handle shooting
    local isDown = love.keyboard.isDown("space")
    if isDown and not input.pressedKeys["space"] then
      -- Create bullet entity
      local triangle = ECS.getComponent(entityId, "TriangleCollider")
      local bulletOffset = 15
      
      local bulletX = pos.x + ((triangle.width / 2) + bulletOffset) * math.cos(rot.angle)
      local bulletY = pos.y + ((triangle.height / 2) + bulletOffset) * math.sin(rot.angle)
      
      Systems.PlayerInput.createBullet(bulletX, bulletY, rot.angle)
    end
    input.pressedKeys["space"] = isDown
  end
end

function Systems.PlayerInput.createBullet(x, y, angle)
  local bulletId = ECS.createEntity()
  ECS.addComponent(bulletId, "Position", Components.Position(x, y))
  ECS.addComponent(bulletId, "Velocity", {
    dx = math.cos(angle) * 100,
    dy = math.sin(angle) * 100,
    angle = angle,
    speed = 100
  })
  ECS.addComponent(bulletId, "Rotation", Components.Rotation(angle, 0))
  ECS.addComponent(bulletId, "CircleCollider", Components.CircleCollider(5))
  ECS.addComponent(bulletId, "CircleRenderable", Components.CircleRenderable(5, 1, 1, 0))
  ECS.addComponent(bulletId, "Bullet", Components.Bullet())
  ECS.addComponent(bulletId, "Damage", Components.Damage(25))
end

-- Collision System: Detects and handles collisions
Systems.Collision = {}

local function checkCircleCircle(posA, colA, posB, colB)
  local dx = posA.x - posB.x
  local dy = posA.y - posB.y
  local distance = math.sqrt(dx * dx + dy * dy)
  return distance < (colA.radius + colB.radius)
end

local function clamp(value, min, max)
  if value < min then
    return min
  elseif value > max then
    return max
  else
    return value
  end
end

local function checkTriangleCircle(posT, rotT, colT, posC, colC)
  local half_width = colT.width / 2
  local half_height = colT.height / 2
  
  local cx = posC.x - posT.x
  local cy = posC.y - posT.y
  
  local cos_angle = math.cos(-rotT.angle)
  local sin_angle = math.sin(-rotT.angle)
  
  local rotated_cx = cx * cos_angle - cy * sin_angle
  local rotated_cy = cx * sin_angle + cy * cos_angle
  
  local closest_x = clamp(rotated_cx, -half_width, half_width)
  local closest_y = clamp(rotated_cy, -half_height, half_height)
  
  local dx = rotated_cx - closest_x
  local dy = rotated_cy - closest_y
  
  return (dx * dx + dy * dy) < (colC.radius * colC.radius)
end

function Systems.Collision.update(dt)
  local allEntities = {}
  
  -- Gather all entities with colliders
  local circleEntities = ECS.getEntitiesWith("Position", "CircleCollider")
  local triangleEntities = ECS.getEntitiesWith("Position", "TriangleCollider", "Rotation")

  -- Check all pairs for collisions
  for i = 1, #circleEntities do
    for j = i + 1, #circleEntities do
      local entityA = circleEntities[i]
      local entityB = circleEntities[j]
      
      local posA = ECS.getComponent(entityA, "Position")
      local colA = ECS.getComponent(entityA, "CircleCollider")
      local posB = ECS.getComponent(entityB, "Position")
      local colB = ECS.getComponent(entityB, "CircleCollider")
      
      if checkCircleCircle(posA, colA, posB, colB) then
        ECS.addComponent(entityA, "Colliding", Components.Colliding(true))
        ECS.addComponent(entityB, "Colliding", Components.Colliding(true))
      end
    end
  end
  
  -- Check triangle vs circle collisions
  for _, triangleEntity in ipairs(triangleEntities) do
    for _, circleEntity in ipairs(circleEntities) do
      local posT = ECS.getComponent(triangleEntity, "Position")
      local rotT = ECS.getComponent(triangleEntity, "Rotation")
      local colT = ECS.getComponent(triangleEntity, "TriangleCollider")
      local posC = ECS.getComponent(circleEntity, "Position")
      local colC = ECS.getComponent(circleEntity, "CircleCollider")

      if checkTriangleCircle(posT, rotT, colT, posC, colC) then
        ECS.addComponent(triangleEntity, "Colliding", Components.Colliding(true))
        ECS.addComponent(circleEntity, "Colliding", Components.Colliding(true))
      end
    end
  end
end

-- Handle Collisions System: Removes non-ship entities that are colliding
Systems.HandleCollisions = {}
function Systems.HandleCollisions.update(dt)
  local collidingEntities = ECS.getEntitiesWith("Colliding")

  for _, entityId in ipairs(collidingEntities) do
    if ECS.hasComponent(entityId, "Ship") == false then 
      ECS.removeEntity(entityId)
    end
  end
end

-- Boundary Removal System: Removes entities that go out of bounds
Systems.BoundaryRemoval = {}
function Systems.BoundaryRemoval.update(dt)
  local entities = ECS.getEntitiesWith("Position")
  local width = love.graphics.getWidth()
  local height = love.graphics.getHeight()

  for _, entityId in ipairs(entities) do
    local pos = ECS.getComponent(entityId, "Position")
  
    if pos.x < -50 or pos.x > width + 50 or pos.y < -50 or pos.y > height + 50 then
      ECS.removeEntity(entityId)
    end
  end
end

-- Asteroid Spawning System: Periodically spawns new asteroids
Systems.AsteroidSpawner = {}
Systems.AsteroidSpawner.timer = 0
Systems.AsteroidSpawner.spawnInterval = 2

function Systems.AsteroidSpawner.update(dt)
  Systems.AsteroidSpawner.timer = Systems.AsteroidSpawner.timer + dt
  
  if Systems.AsteroidSpawner.timer >= Systems.AsteroidSpawner.spawnInterval then
    Systems.AsteroidSpawner.timer = 0
    
    local asteroidId = ECS.createEntity()
    local x = math.random(0, love.graphics.getWidth())
    local y = math.random(0, love.graphics.getHeight())
    local angle = math.random() * 2 * math.pi
    
    ECS.addComponent(asteroidId, "Position", Components.Position(x, y))
    ECS.addComponent(asteroidId, "Velocity", {
      dx = math.cos(angle) * 20,
      dy = math.sin(angle) * 20,
      angle = angle,
      speed = 20
    })
    ECS.addComponent(asteroidId, "Rotation", Components.Rotation(angle, 0))
    ECS.addComponent(asteroidId, "CircleCollider", Components.CircleCollider(30))
    ECS.addComponent(asteroidId, "DecagonRenderable", Components.DecagonRenderable(0.5, 0.5, 0.5))
    ECS.addComponent(asteroidId, "Asteroid", Components.Asteroid())
    ECS.addComponent(asteroidId, "Health", Components.Health(50))
  end
end

-- Rendering System: Draws all renderable entities
Systems.Rendering = {}

-- Local drawing functions
local function drawCircle(x, y, radius)
  love.graphics.circle("fill", x, y, radius)
end

local function drawTriangle(x, y, width, height, angle)
  love.graphics.push()
  love.graphics.translate(x, y)
  love.graphics.rotate(angle)
  
  local px1, py1 = width / 2, 0
  local px2, py2 = -width / 2, height / 2
  local px3, py3 = -width / 2, -height / 2
  
  love.graphics.polygon("fill", px1, py1, px2, py2, px3, py3)
  love.graphics.pop()
end

local function drawDecagon(x, y, angle)
  love.graphics.push()
  love.graphics.translate(x, y)
  love.graphics.scale(10, 10)
  love.graphics.rotate(angle)
  
  local px1, py1 = 1, 2 
  local px2, py2 = 2, 3
  local px3, py3 = 3, 1
  local px4, py4 = 2, -1
  local px5, py5 = 3, -2
  local px6, py6 = -1, -3
  local px7, py7 = -1, -2
  local px8, py8 = -3, -1
  local px9, py9 = -1, 1
  local px10, py10 = -1, 3
  
  love.graphics.polygon("fill",
    px1, py1, px2, py2, px3, py3, px4, py4, px5, py5,
    px6, py6, px7, py7, px8, py8, px9, py9, px10, py10
  )
  love.graphics.pop()
end

function Systems.Rendering.draw()
  -- Draw circles
  local circleEntities = ECS.getEntitiesWith("Position", "CircleRenderable")
  for _, entityId in ipairs(circleEntities) do
    local pos = ECS.getComponent(entityId, "Position")
    local renderable = ECS.getComponent(entityId, "CircleRenderable")
    
    love.graphics.setColor(renderable.color[1], renderable.color[2], renderable.color[3])
    drawCircle(pos.x, pos.y, renderable.radius)
  end
  
  -- Draw triangles
  local triangleEntities = ECS.getEntitiesWith("Position", "Rotation", "TriangleRenderable")
  for _, entityId in ipairs(triangleEntities) do
    local pos = ECS.getComponent(entityId, "Position")
    local rot = ECS.getComponent(entityId, "Rotation")
    local renderable = ECS.getComponent(entityId, "TriangleRenderable")
    
    love.graphics.setColor(renderable.color[1], renderable.color[2], renderable.color[3])
    drawTriangle(pos.x, pos.y, renderable.width, renderable.height, rot.angle)
  end
  
  -- Draw decagons
  local decagonEntities = ECS.getEntitiesWith("Position", "Rotation", "DecagonRenderable")
  for _, entityId in ipairs(decagonEntities) do
    local pos = ECS.getComponent(entityId, "Position")
    local rot = ECS.getComponent(entityId, "Rotation")
    local renderable = ECS.getComponent(entityId, "DecagonRenderable")
    
    love.graphics.setColor(renderable.color[1], renderable.color[2], renderable.color[3])
    drawDecagon(pos.x, pos.y, rot.angle)
  end
end

return Systems
