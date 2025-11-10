local sprites = {}
local currentSprites = {}

local function updateAbsolute(sprite)
    sprite.ReadOnly.AbsoluteSize = {
        X = sprite.Image.getWidth() * sprite.Scale.X,
        Y = sprite.Image.getHeight() * sprite.Scale.Y
    }
    sprite.ReadOnly.AbsolutePivotPosition = {
        X = sprite.Pivot.X * sprite.Scale.X,
        Y = sprite.Pivot.Y * sprite.Scale.Y
    }
end

local metaTable = {
    __newIndex = function(table, i, v)
        rawset(table, i, v)
        updateAbsolute(table.Parent)
    end
}

sprites.new = function(image, x, y, r, sx, sy, px, py, --[[t,]] v)
    x = x or 0
    y = y or 0
    r = r or 0
    sx = sx or 1
    sy = sy or sx
    px = px or image:getWidth() / 2
    py = py or image:getHeight() / 2
    -- t = t or 0
    if not v then
        v = true
    end
    
    local parent = {}
    parent = {
        ReadOnly = {
            Index = #currentSprites + 1,
            AbsoluteSize = {
                X = image:getWidth() * sx,
                Y = image:getHeight() * sy
            },
            AbsolutePivotPosition = {
                X = px * sx,
                Y = py * sy
            }
        },
        Image = image,
        Position = {
            X = x,
            Y = y,
            Parent = parent
        },
        Rotation = r,
        Scale = {
            X = sx,
            Y = sy,
            Parent = parent
        },
        Pivot = {
            X = px,
            Y = py,
            Parent = parent
        },
        -- Transparency = t,
        Visible = v
    }
    table.insert(currentSprites, parent)
    
    setmetatable(currentSprites[#currentSprites].Position, metaTable)
    setmetatable(currentSprites[#currentSprites].Scale, metaTable)
    setmetatable(currentSprites[#currentSprites].Pivot, metaTable)
    
    return currentSprites[#currentSprites]
end

sprites.Delete = function(sprite)
    table.remove(currentSprites, sprite.ReadOnly.Index)
end

sprites.Render = function()
    for _, v in pairs(currentSprites) do
        if v.Visible then
            love.graphics.draw(v.Image, v.Position.X, v.Position.Y, v.Rotation, v.Scale.X, v.Scale.Y, v.Pivot.X, v.Pivot.Y)
        end
    end
end



return sprites
