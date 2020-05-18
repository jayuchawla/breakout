ServeState = Class{__includes = BaseState}

function ServeState:enter(params)
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.level = params.level
    self.highScores = params.highScores

    --why are we not passing ball through params ? because user has facility to choose paddle of his choice not vall of his choice the padle user chose is passed through params
    self.ball = Ball(math.random(7))
    --self.ball.skin = math.random(7)
end

function ServeState:update(dt)
    self.paddle:update(dt)
    self.ball.x = self.paddle.x + (self.paddle.width / 2) - self.ball.width / 2
    self.ball.y = self.paddle.y - self.ball.height + 2

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play', {
            paddle = self.paddle,
            bricks = self.bricks,
            health = self.health,
            score = self.score,
            ball = self.ball,
            level = self.level,
            highScores = self.highScores
        })
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
    
end

function ServeState:render()
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Enter to Serve!',0,(2*VIRTUAL_HEIGHT)/3,VIRTUAL_WIDTH,'center')
    
    for k, brick in pairs(self.bricks) do
        brick:render()
    end
    
    self.paddle:render()
    self.ball:render()

    renderHealth(self.health)
    renderScore(self.score)
end