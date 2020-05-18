--[[In computer graphics, a texture atlas (also called a sprite sheet
or an image sprite) is an image containing multiple smaller images,
usually packed together to reduce overall dimensions.]]

--use to build brick frames since they have constnt width and height
function GenerateQuads(atlas, tilewidth, tileheight)
    --will know how many times to iterate using below vars
    local sheetWidth = atlas:getWidth()/tilewidth
    local sheetHeight = atlas:getHeight()/tileheight

    local sheetCounter = 1
    local spritesheet = {}

    for y = 0, sheetHeight - 1 do
        for x = 0, sheetWidth - 1 do
            --in lua 1 indexing are used by tables
            spritesheet[sheetCounter] = love.graphics.newQuad(x*tilewidth, y*tileheight, tilewidth, tileheight, atlas:getDimensions())
            sheetCounter = sheetCounter + 1
        end
    end
    return spritesheet
end

--by default table does not have slice method we create one
function table.sclice(tbl, first, last, step)
    local sliced = {}
    ---#: len of table
    for i=first or 1, last or #tbl, step or 1 do
        sliced[#sliced+1] = tbl[i]
    end

    return sliced
end

function GenerateQuadsPaddles(atlas) 
    local x = 0
    ---see breakout_big.png in graphics folder first set of paddle has coord as 0,64
    local y = 64

    local counter = 1
    local quads = {}

    for i = 1,4 do
        --for small paddle
        quads[counter] = love.graphics.newQuad(x, y, 32, 16, atlas:getDimensions())
        counter = counter + 1
        --for mdeium paddle
        quads[counter] = love.graphics.newQuad(x+32, y, 64, 16, atlas:getDimensions())
        counter = counter + 1
        --for large paddle
        quads[counter] = love.graphics.newQuad(x+96, y, 96, 16, atlas:getDimensions())
        counter = counter + 1
        --for huge paddle
        quads[counter] = love.graphics.newQuad(x, y+16, 128, 16, atlas:getDimensions())
        counter = counter + 1

        x = 0
        y = y + 32
    end
    return quads
end


function GenerateQuadsBalls(atlas)
    local x = 96
    local y = 48

    local counter = 1
    local quads = {}

    --top row of balls
    for i = 1, 4 do
        quads[counter] = love.graphics.newQuad(x, y, 8, 8, atlas:getDimensions())
        x = x + 8
        counter = counter + 1
    end

    x = 96
    y = 56

    for i =1, 3 do
        quads[counter] = love.graphics.newQuad(x, y, 8, 8, atlas:getDimensions())
        x = x + 8
        counter = counter + 1
    end

    return quads
end

---we no need to write long code generate quads is helpful here, we have 21 brick types
--only 1 to 21 contain bricks throw away rest hence we use slice to extract only some portion of table
function GenerateQuadsBricks(atlas)
    return table.sclice(GenerateQuads(atlas, 32, 16), 1, 21)
end