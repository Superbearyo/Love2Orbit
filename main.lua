local World = require "world"

function love.load()
    world = World:new()

    earth = world:newBody(0, 0, 5.972e24, 6371e3, {0, 0, 1})  -- earth at origin
    moon = world:newBody(384400e3, 0, 7.348e22, 1737e3, {1, 1, 1})  -- moon at ~384,400 km

    moon.vx = 0
    moon.vy = 1022

    world:setTimeMultiplier(100000)

    world.camera.scale = 2e-6
end

function love.keypressed(key)
    if key == "up" then
        world.camera.scale = world.camera.scale * 1.2
    elseif key == "down" then
        world.camera.scale = world.camera.scale / 1.2
    end
end

function love.update(dt)
    world:update(dt)
    world:updateBodies(earth, moon, dt)
    world.camera:focus(earth)
end

function love.draw()
    world:draw()
end
