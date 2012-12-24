debug = false

function newFood(position)
    local t = 5 * scale
    local c = { x=math.random(0, (love.graphics.getWidth()-5)  / t) * t,
                y=math.random(0, (love.graphics.getHeight()-5) / t) * t }
    return c
end

function newColor(red, green, blue)
    return { r=red, g=green, b=blue }
end

function love.init()
    position = { x=love.graphics.getWidth()  / 2,
                 y=love.graphics.getHeight() / 2,
                 tail=nil }
    heading = { x=0, y=1 }

    food = newFood(position)

    clock = 0
    moved = false
    speed = 3
    speedInc = 0.25
    foodCount = 0
end

function love.load()
    bgcolor = newColor(138, 191, 156)
    fgcolor = newColor(242, 237, 167)

    font = love.graphics.newFont("assets/font.ttf", 14 * scale)
    love.graphics.setFont(font)

    love.init()
end

function love.draw()
    -- Draw background
    love.graphics.setColor(bgcolor.r, bgcolor.g, bgcolor.b)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    -- Setup graphics for snake and food
    love.graphics.setColor(fgcolor.r, fgcolor.g, fgcolor.b)
    love.graphics.setPoint(4 * scale, "rough")

    -- Draw the snake
    local current = position
    while current do
        if current.x ~= nil and current.y ~= nil then
            love.graphics.point(current.x + 2.5 * scale, current.y + 2.5 * scale)
        end
        current = current.tail
    end

    -- Draw food
    if food then
        love.graphics.setColor(242, 75, 75)
        love.graphics.point(food.x + 2.5 * scale, food.y + 2.5 * scale)
    end

    love.graphics.printf("" .. foodCount, -2 * scale, scale, love.graphics.getWidth(), "right")
end

function love.update(dt)
    clock = clock + dt
    if clock >= 1/speed then
        local current = position
        while current.tail do
            current.x = current.tail.x
            current.y = current.tail.y
            current = current.tail
        end
        current.x = current.x + heading.x * 5 * scale
        current.y = current.y + heading.y * 5 * scale

        if current.x > love.graphics.getWidth() - 5 * scale then
            current.x = 0
        elseif current.x < 0 then
            current.x = love.graphics.getWidth() - 5 * scale
        end

        if current.y > love.graphics.getHeight() - 5 * scale then
            current.y = 0
        elseif current.y < 0 then
            current.y = love.graphics.getHeight() - 5 * scale
        end

        if food and current.x == food.x and current.y == food.y then
            position = { x=nil, y=nil, tail=position }
            speed = speed + speedInc
            foodCount = foodCount + 1
            food = newFood()
        end

        -- Check for collision
        local collision = false
        local tmp = position
        while tmp do
            if tmp ~= current and tmp.x == current.x and tmp.y == current.y then
                collision = true
                break
            end
            tmp = tmp.tail
        end
        
        if collision then
            love.init()
        else
            clock = clock - 1/speed
            moved = false
        end
    end
end

function love.keypressed(key)
    if moved == false then
        if key == "up" and heading.y == 0 then
            heading.x = 0
            heading.y = -1
            moved = true
        elseif key == "right" and heading.x == 0 then
            heading.x = 1
            heading.y = 0
            moved = true
        elseif key == "down" and heading.y == 0 then
            heading.x = 0
            heading.y = 1
            moved = true
        elseif key == "left" and heading.x == 0 then
            heading.x = -1
            heading.y = 0
            moved = true
        end
    end

    if key == "escape" then
        love.event.push("quit")
    elseif key == "+" and speed < 10 then
        speed = speed + 1
    elseif key == "-" and speed > 1 then
        speed = speed - 1
    end
end
