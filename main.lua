local World = require "world"

function love.load()
    world = World:new()

    earth = world:newBody(0, 0, 5.972e24, 6371e3)  -- earth at origin
    moon = world:newBody(384400e3, 0, 7.348e22, 1737e3)  -- moon at ~384,400 km

    moon.vx = 0
    moon.vy = 1022

    world:setTimeMultiplier(100000)
end

function love.update(dt)
    world:updateBodies(earth, moon, dt)
end

function love.draw()
    love.graphics.setColor(0, 0, 1) -- Blue for Earth
    love.graphics.circle("fill", earth.x * 1e-6 + 400, earth.y * 1e-6 + 300, 10)

    love.graphics.setColor(1, 1, 1) -- White for Moon
    love.graphics.circle("fill", moon.x * 1e-6 + 400, moon.y * 1e-6 + 300, 5)
end