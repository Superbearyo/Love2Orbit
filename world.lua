local Body = require "body"
local Camerae = require "camera"

G = 6.674e-11

World = {}
World.__index = World

function World:new()
    local world = setmetatable({}, World)  -- create a new table and set its metatable
    world.bodies = {}  -- initialize bodies list
    world.camera = Camera:new(world, 0, 0, 1)
    world.timeMultiplier = 1
    return world
end

function World:newBody(x, y, mass, radius, color)
    local body = Body:new(x, y, mass, radius, color)
    table.insert(self.bodies, body)
    return body
end

function World:computeGravitationalForce(body1, body2)
    local dx = body2.x - body1.x -- get distance between bodies in the x direction
    local dy = body2.y - body1.y -- get distance between bodies in the y direction
    local r = math.sqrt(dx * dx + dy * dy) -- calculate the distance between the bodies using the pythagorean theorem

    if r == 0 then return 0, 0 end -- account for edge case to prevent division by zero

    local F = G * ((body1.mass * body2.mass) / (r * r)) -- calculate the gravitational force between the bodies using newton's law of universal gravitation
    local Fx = F * (dx / r) -- calculate the force in the x direction
    local Fy = F * (dy / r) -- calculate the force in the y direction

    return Fx, Fy -- return both force vectors
end

function World:computeAcceleration(body1, body2)
    local Fx, Fy = self:computeGravitationalForce(body1, body2) -- Compute force vectors
    body1.ax = Fx / body1.mass -- change acceleration for body #1 in the x direction
    body1.ay = Fy / body1.mass -- change acceleration for body #1 in the y direction

    -- take into account negative force due to newtons third law

    body2.ax = -Fx / body2.mass -- change acceleration for body #2 in the x direction 
    body2.ay = -Fy / body2.mass -- change acceleration for body #2 in the y direction
end

function World:updateVelocity(body, dt) -- update new velocity using simple euler integration
    body.vx = body.vx + body.ax * dt
    body.vy = body.vy + body.ay * dt
end

function World:updatePosition(body, dt) -- update new position
    body.x = body.x + body.vx * dt
    body.y = body.y + body.vy * dt
end

function World:updateBodies(body1, body2, dt)

    local scaled_dt = self.timeMultiplier * dt

    self:computeAcceleration(body1, body2)
    self:updateVelocity(body1, scaled_dt)
    self:updateVelocity(body2, scaled_dt)
    self:updatePosition(body1, scaled_dt)
    self:updatePosition(body2, scaled_dt)
end

function World:setTimeMultiplier(multiplier)
    self.timeMultiplier = multiplier
end

function World:update(dt)
    self.camera:update(dt)
end

function World:draw()
    local windowWidth, windowHeight = love.graphics:getDimensions()

    local cx, cy = windowWidth/2, windowHeight/2
    for _, body in ipairs(self.bodies) do
        local screenX = (body.x - self.camera.x) * self.camera.scale + cx
        local screenY = (body.y - self.camera.y) * self.camera.scale + cy

        love.graphics.setColor(body.color[1], body.color[2], body.color[3])
        love.graphics.circle("fill", screenX, screenY, body.radius * self.camera.scale)
    end
end

return World