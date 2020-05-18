EnterHighScoreState = Class{__includes = BaseState}

--v r doing this in arcade style hence you change char by pressing up and down
local chars = {
    [1] = 65,
    [2] = 65,
    [3] = 65
}

local highlightedChar = 1

function EnterHighScoreState:enter(params)
    self.highScores = params.highScores
    self.score = params.score
    self.scoreIndex = params.scoreIndex
end

function EnterHighScoreState:update(dt)

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        --since we wanna type cast number to chars i.e 65 to A 66 to B and so on
        local name = string.char(chars[1]) .. string.char(chars[2]) .. string.char(chars[3])

        for i = 9,self.scoreIndex, -1 do
            --shifting entries down
            self.highScores[i+1].name = self.highScores[i].name
            self.highScores[i+1].score = self.highScores[i].score
        end

        self.highScores[self.scoreIndex].name = name
        self.highScores[self.scoreIndex].score = self.score

        --write to file
        local temp = ''

        for i = 1,10 do
            temp = temp .. self.highScores[i].name .. '\n'
            temp = temp .. tostring(self.highScores[i].score) .. '\n'
        end

        love.filesystem.write('breakout.lst', temp)

        gStateMachine:change('high-score',{
            highScores = self.highScores
        })
    end

    if love.keyboard.wasPressed('up') then
        chars[highlightedChar] = chars[highlightedChar] + 1
        if chars[highlightedChar] > 90 then
            chars[highlightedChar] = 65
        end
    elseif love.keyboard.wasPressed('down') then
        chars[highlightedChar] = chars[highlightedChar] - 1
        if chars[highlightedChar] < 65 then
            chars[highlightedChar] = 90
        end
    end

    if love.keyboard.wasPressed('left') then
        if highlightedChar == 1 then
            highlightedChar = 3
        else
            highlightedChar = highlightedChar - 1
        end
    elseif love.keyboard.wasPressed('right') then
        if highlightedChar == 3 then
            highlightedChar = 1
        else
            highlightedChar = highlightedChar + 1
        end
    end
end

function EnterHighScoreState:render()
    
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Your Score: '..tostring(self.score), 0, 30, VIRTUAL_WIDTH, 'center')

    if highlightedChar == 1 then
        love.graphics.setColor(103/255, 1, 1, 1)
    end
    love.graphics.print(string.char(chars[1]),VIRTUAL_WIDTH/2 - 28, VIRTUAL_HEIGHT / 2)
    love.graphics.setColor(1, 1, 1, 1)

    if highlightedChar == 2 then
        love.graphics.setColor(103/255, 1, 1, 1)
    end
    love.graphics.print(string.char(chars[2]),VIRTUAL_WIDTH/2 - 6, VIRTUAL_HEIGHT / 2)
    love.graphics.setColor(1, 1, 1, 1)
    
    if highlightedChar == 3 then
        love.graphics.setColor(103/255, 1, 1, 1)
    end
    love.graphics.print(string.char(chars[3]),VIRTUAL_WIDTH/2 + 20, VIRTUAL_HEIGHT / 2)
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.setFont(gFonts['small'])
    love.graphics.printf('Tap Enter to confirm!',0, VIRTUAL_HEIGHT - 18,VIRTUAL_WIDTH,'center')

end
