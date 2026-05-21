local Body = require "body"
local Camera = require "camera"

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

function World:computeGravitationalForce(bodies)
    local forces = {}
    for i, bodyI in ipairs(bodies) do
        local Fx = 0
        local Fy = 0
        for j, bodyJ in ipairs(bodies) do
            if bodyI ~= bodyJ then
                local dx = bodyJ.x - bodyI.x -- get distance between bodies in the x direction
                local dy = bodyJ.y - bodyI.y -- get distance between bodies in the y direction
                local r = math.sqrt(dx * dx + dy * dy) -- calculate the distance between the bodies using the pythagorean theorem

                if r ~= 0 then 
                    local F = G * ((bodyI.mass * bodyJ.mass) / (r * r)) -- calculate the gravitational force between the bodies using newton's law of universal gravitation
                    Fx = Fx + (F * (dx / r)) -- calculate the force in the x direction
                    Fy = Fy + (F * (dy / r)) -- calculate the force in the y direction
                end
            end
        end
        table.insert(forces, {Fx, Fy})
    end
    return forces
end

function World:computeAcceleration(bodies)
    local forces = self:computeGravitationalForce(bodies) -- Compute force vectors
    for i, body in ipairs(bodies) do
        body.ax = forces[i][1] / body.mass
        body.ay = forces[i][2] / body.mass
    end
end

function World:updateVelocity(body, dt) -- update new velocity using simple euler integration
    body.vx = body.vx + body.ax * dt
    body.vy = body.vy + body.ay * dt
end

function World:updatePosition(body, dt) -- update new position
    body.x = body.x + body.vx * dt
    body.y = body.y + body.vy * dt
end

function World:updateBodies(dt)

    local scaled_dt = self.timeMultiplier * dt
    self:computeAcceleration(self.bodies)

    for i, body in ipairs(self.bodies) do
        self:updateVelocity(body, scaled_dt)
        self:updatePosition(body, scaled_dt)
    end
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