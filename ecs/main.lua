-- Entity Component System based asteroid game
local ECS = require("ecs")
local Components = require("components")
local Systems = require("systems")

function love.load() 
  local width, height = love.graphics.getDimensions() 
  local windowCenterX = width / 2
  local windowCenterY = height / 2
  
  -- Register all systems
  ECS.addSystem("PlayerInput", Systems.PlayerInput)
  ECS.addSystem("Movement", Systems.Movement)
  ECS.addSystem("AsteroidSpawner", Systems.AsteroidSpawner)
  ECS.addSystem("Collision", Systems.Collision)
  ECS.addSystem("HandleCollisions", Systems.HandleCollisions)
  ECS.addSystem("BoundaryRemoval", Systems.BoundaryRemoval)
  ECS.addSystem("Rendering", Systems.Rendering)
  
  -- Create player entity
  local playerId = ECS.createEntity()
  ECS.addComponent(playerId, "Position", Components.Position(windowCenterX, windowCenterY))
  ECS.addComponent(playerId, "Rotation", Components.Rotation(0, 2))
  ECS.addComponent(playerId, "TriangleCollider", Components.TriangleCollider(30, 15))
  ECS.addComponent(playerId, "TriangleRenderable", Components.TriangleRenderable(30, 15, 0, 0.4, 0.4))
  ECS.addComponent(playerId, "PlayerInput", Components.PlayerInput(50, 2))
  ECS.addComponent(playerId, "Ship", Components.Ship())
  ECS.addComponent(playerId, "Health", Components.Health(100))
end

function love.update(dt)
  -- Update all systems
  ECS.updateSystems(dt)
end

function love.draw()
  -- Draw all systems
  ECS.drawSystems()
end
