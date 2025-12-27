-- Entity Component System core
local ECS = {}

-- Entity ID counter
local nextEntityId = 1

-- Storage
ECS.entities = {}
ECS.components = {}
ECS.systems = {}

-- Create a new entity and return its ID
function ECS.createEntity()
  local id = nextEntityId
  nextEntityId = nextEntityId + 1
  ECS.entities[id] = true
  return id
end

-- Remove an entity and all its components
function ECS.removeEntity(entityId)
  ECS.entities[entityId] = nil
  for componentType, _ in pairs(ECS.components) do
    if ECS.components[componentType][entityId] then
      ECS.components[componentType][entityId] = nil
    end
  end
end

-- Add a component to an entity
function ECS.addComponent(entityId, componentType, componentData)
  if not ECS.components[componentType] then
    ECS.components[componentType] = {}
  end
  ECS.components[componentType][entityId] = componentData
end

-- Get a component from an entity
function ECS.getComponent(entityId, componentType)
  if ECS.components[componentType] then
    return ECS.components[componentType][entityId]
  end
  return nil
end

-- Check if entity has a component
function ECS.hasComponent(entityId, componentType)
  return ECS.components[componentType] and ECS.components[componentType][entityId] ~= nil
end

-- Remove a component from an entity
function ECS.removeComponent(entityId, componentType)
  if ECS.components[componentType] then
    ECS.components[componentType][entityId] = nil
  end
end

-- Get all entities with specific components
function ECS.getEntitiesWith(...)
  local componentTypes = {...}
  local result = {}
 
  -- TODO: This is slow, we can check the intersection of entities for each component type for better performance
  for entityId, _ in pairs(ECS.entities) do
    local hasAll = true
    for _, componentType in ipairs(componentTypes) do
      if not ECS.hasComponent(entityId, componentType) then
        hasAll = false
        break
      end
    end
    if hasAll then
      table.insert(result, entityId)
    end
  end
  
  return result
end

-- Get one entity with specific components
function ECS.getOneEntityWith(...)
  local componentTypes = {...}

  -- TODO: This is slow, we can check the intersection of entities for each component type for better performance
  for entityId, _ in pairs(ECS.entities) do
    local hasAll = true
    for _, componentType in ipairs(componentTypes) do
      if not ECS.hasComponent(entityId, componentType) then
        hasAll = false
        break
      end
    end
    if hasAll then
      return entityId
    end
  end

  return nil
end

-- Register a system
function ECS.addSystem(name, system)
  ECS.systems[name] = system
end

-- Update all systems
function ECS.updateSystems(dt)
  for name, system in pairs(ECS.systems) do
    if system.update then
      system.update(dt)
    end
  end
end

-- Draw all systems
function ECS.drawSystems()
  for name, system in pairs(ECS.systems) do
    if system.draw then
      system.draw()
    end
  end
end

-- Clear all data
function ECS.clear()
  ECS.entities = {}
  ECS.components = {}
  nextEntityId = 1
end

return ECS
