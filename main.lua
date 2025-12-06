function love.load()
end

function love.update(dt)
end

function drawSpaceship(x, y)
  local width = 15
  local heigth = 30

  local centerX = x - (width / 2)
  local centerY = y - (heigth / 2)

  local px1, py1 = centerX, centerY
  local px2, py2 = centerX + width, centerY
  local px3, py3 = centerX + (width / 2), centerY + heigth

  love.graphics.polygon("fill", px1, py1, px2, py2, px3, py3)
end

function love.draw()
  local width, height = love.graphics.getDimensions()
  local centerX, centerY = width / 2, height / 2

  print(love.mouse.getPosition())

  love.graphics.setColor(0, 0.4, 0.4)
  drawSpaceship(centerX, centerY)
end
