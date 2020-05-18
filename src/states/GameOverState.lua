GameOverState = Class{__includes = BaseState}

function GameOverState:enter(params)
    self.score = params.score
    self.highScores = params.highScores
    self.scoreIndex = -1
end

function GameOverState:update(dt)

    if self:checkIfHighScore() > 0 then
        gStateMachine:change('enter-high-score',{
            score = self.score,
            highScores = self.highScores,
            scoreIndex = self.scoreIndex
        })    
    end
    
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('start',{
            highScores = self.highScores
        })
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function GameOverState:checkIfHighScore()
    for i = 10, 1, -1 do
        if self.score > self.highScores[i].score then
            self.scoreIndex = i
        end
    end
    return self.scoreIndex
end

function GameOverState:render()
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('GAME OVER', 0, VIRTUAL_HEIGHT / 3, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('FINAL SCORE: ' .. tostring(self.score), 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')
end