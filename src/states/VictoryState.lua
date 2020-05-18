VictoryState = Class{__includes = BaseState}

function VictoryState:enter(params)
    self.level = params.level
    self.health = params.health
    self.paddle = params.paddle
    self.ball = params.ball
    self.score = params.score
    self.highScores = params.highScores 
end

function VictoryState:update(dt)
    self.paddle:update(dt)
    self.ball.x = self.paddle.x + (self.paddle.width / 2) - (self.ball.width / 2)
    self.ball.y = self.paddle.y - self.ball.height + 2
    
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('serve',{
            paddle = self.paddle,
            bricks = LevelMaker:createMap(self.level + 1),
            score = self.score,
            health = self.health,
            level = self.level + 1,
            highScores = self.highScores
        })
    end
    
end

function VictoryState:render()
    
    self.paddle:render()
    self.ball:render()

    renderHealth(self.health)
    renderScore(self.score)

    love.graphics.setFont(gFonts['large'])
    love.graphics.printf("Level " .. tostring(self.level) .. " complete ", 0, VIRTUAL_HEIGHT / 4, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf("Tap Enter to Start next level!", 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')
end

