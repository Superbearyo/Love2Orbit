
Body = {}
Body.__index = Body

function Body:new(x, y, mass, radius)
    local body = {
        x = x, y = y,   -- x, y position | distance from the origin in meters | m
        vx = 0, vy = 0, -- x, y velocity | velocity in meters per second | m/s
        ax = 0, ay = 0, -- x, y acceleration | acceleration in meters per second squared | m/s^2
        mass = mass,    -- mass | mass in kilograms | kg
        radius = radius -- radius | radius in meters | m
    }
    setmetatable(body, Body)
    return body
end

return Body