HighScoreState = Class{__includes = BaseState}

function HighScoreState:enter(params)
    self.highScores = params.highScores
end

function HighScoreState:update(dt)
    if love.keyboard.wasPressed('escape') then
        gSounds['wall-hit']:play()

        gStateMachine:change('start', {
            highScores = self.highScores
        })
    end
end

function HighScoreState:render()

    local counter = 1
    local y = VIRTUAL_HEIGHT / 8
    --local x = 0

    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('High Scores', 0, y, VIRTUAL_WIDTH, 'center')

    y = y + 50

    love.graphics.setFont(gFonts['medium'])
    love.graphics.print('Name', VIRTUAL_WIDTH / 2 - 40, y)
    love.graphics.print('Score', VIRTUAL_WIDTH / 2 +10, y)
    
    love.graphics.setFont(gFonts['small'])
    y = y + 20

    for i = 1,10 do
        love.graphics.print(tostring(self.highScores[counter].name), VIRTUAL_WIDTH / 2 - 25, y)
        love.graphics.print(tostring(self.highScores[counter].score), VIRTUAL_WIDTH / 2 + 20, y)
        counter = counter + 1
        y = y + 10
    end
end