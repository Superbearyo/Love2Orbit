Camera = {}
Camera.__index = Camera

function Camera:new(world, x, y, scale)
    local cam = {
        world = world,
        x = x,
        y = y,
        scale = scale,
    }
    setmetatable(cam, Camera)
    return cam
end

function Camera:update(dt)

end

function Camera:focus(body)
    self.x = body.x
    self.y = body.y
end

function Camera:focusMass()
    local totalMass = 0
    local centerX, centerY = 0, 0

    for _, body in ipairs(self.world.bodies) do
        totalMass = totalMass + body.mass
        centerX = centerX + body.x * body.mass
        centerY = centerY + body.y * body.mass
    end

    self.x = centerX / totalMass
    self.y = centerY / totalMass
end

return Camera