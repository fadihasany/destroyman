_G.love = love

love.window.setFullscreen(true)

local sprites = require "sprites"
local creatures = {}
local increasing = {}
local current = 1
local background = true

local windowX, windowY = love.graphics.getDimensions()

function love.load()
    for i, v in pairs({ "red", "yellow", "green", "blue", "purple" }) do
        table.insert(creatures, sprites.new(love.graphics.newImage("creature_" .. v .. ".png"),  i * windowX/6, windowY/2 + 55, nil, 0.5, 0.5, nil, 220))
        table.insert(increasing, false)
    end
    love.graphics.setBackgroundColor(255, 255, 255)
end

function love.keypressed(key)
    if key == "escape" then love.event.quit() end
    if key == "space" then
        increasing[current] = true
        current = (current == 5) and 1 or current + 1
    elseif key == "z" then
        background = not background
        love.graphics.setBackgroundColor(background and 255 or 0, background and 255 or 0, background and 255 or 0)
    end
end

function love.update(deltaTime)
    for i, v in pairs(creatures) do
        if increasing[i] then
            v.Scale.Y = v.Scale.Y + deltaTime * 5
            if v.Scale.Y >= 1 then increasing[i] = false end
        else
            v.Scale.Y = v.Scale.Y - (deltaTime * 2.5)
            v.Scale.Y = ((v.Scale.Y > 1) and 1) or ((v.Scale.Y < 0.5) and 0.5) or v.Scale.Y
        end

    end
end

function love.draw()
    sprites.Render()
end
