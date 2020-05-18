PlayState = Class{__includes = BaseState}

--[[function PlayState:init()
    self.paddle = Paddle()

    self.ball = Ball(math.random(7))

    self.ball.dx = math.random(-200,200)
    self.ball.dy = math.random(-200,200)
    
    self.ball.x = self.paddle.x + self.paddle.width - self.ball.width
    self.ball.y = self.paddle.y - self.ball.height
    self.paused = false

    self.bricks = LevelMaker.createMap()
end]]

function PlayState:enter(params)
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.ball = params.ball
    self.level = params.level
    self.highScores = params.highScores

    self.ball.dx = math.random(1,2) == 1 and -150 or 150 
    self.ball.dy = -150
end

function PlayState:update(dt)
    if self.paused then
        if love.keyboard.wasPressed('space') then
            self.paused = false
            gSounds['pause'] : play()
        else
            return
        end

    elseif love.keyboard.wasPressed('space') then
        self.paused = true
        gSounds['pause']:play()
        return
    end

    ---below section only runs if above code's elseif is not run 
    self.paddle:update(dt)
    self.ball:update(dt)

    for k, brick in pairs(self.bricks) do
        brick:update(dt)
    end

    if self.ball:collides(self.paddle) then
        self.ball.y = self.paddle.y - 8
        self.ball.dy = -self.ball.dy

        ---enhancing collision of ball and paddle
        --if ball while moving left collides the paddle which is also moving left
        --if they collide at the left corner of paddle there is a sudden huge impact due to which velocity increements highly
        --if they collide at the center small impact hence more diff between center and ball more is impact hence we scale velocity accordingly
        --first check if ball moving left and paddle moving left and ball is wihin left half of paddle

        if self.ball.x <= (self.paddle.x + self.paddle.width / 2) and self.paddle.dx < 0 then
            self.ball.dx = -50 + -(4 * (self.paddle.x + self.paddle.width / 2 - self.ball.x))
        end 

        if self.ball.x > (self.paddle.x + self.paddle.width / 2) and self.paddle.dx > 0 then
            self.ball.dx = 50 + (4 * (self.ball.x - self.paddle.x + self.paddle.width / 2))
        end

        gSounds['paddle-hit']:play()
    end

    for k, brick in pairs(self.bricks) do
        if brick.inPlay and self.ball:collides(brick) then
            self.score = self.score + (brick.tier * 200 + brick.color * 25)
            brick:hit()

            if self:checkCompletion() then
                gSounds['victory']:play()

                gStateMachine:change('victory', {
                    level = self.level,
                    score = self.score,
                    paddle = self.paddle,
                    ball = self.ball,
                    health = self.health,
                    highScores = self.highScores
                })
            end

            ---when ball collides with brick at left edge of brick the ball just deflect in opposite X direction to avoid merging ball into brick change position of ball 
            ---when ball collides with brick at right edge of brick the ball just deflect in opposite X direction to avoid merging ball into brick change position of ball 
            ---when ball collides with brick at upward edge of brick the ball just deflect in opposite Y direction to avoid merging ball into brick change position of ball 
            ---when ball collides with brick at bottom edge of brick the ball just deflect in opposite Y direction to avoid merging ball into brick change position of ball 

            --collision with left edge +2 only to handle corner cases, rough corners of ball
            if self.ball.x + 2 < brick.x and self.ball.dx > 0 then
                self.ball.dx = -self.ball.dx
                self.ball.x = brick.x - 8
            
            --right edge colision 
            elseif self.ball.x + 6 > brick.x + brick.width and self.ball.dx < 0 then
                self.ball.dx = -self.ball.dx
                self.ball.x = brick.x + brick.width

            --collision with upward edge
            elseif self.ball.y < brick.y then
                self.ball.dy = -self.ball.dy
                self.ball.y = brick.y - 8
            
            --collsion with bottom edge
            else
                self.ball.dy = -self.ball.dy
                self.ball.dy = brick.y + 16

            --NOTE:::self.ball.x + 6 > brick.x + brick.width and self.ball.dx > 0 or
            --self.ball.x + 2 < brick.x and self.ball.dx < 0 are  NOT VALID, learn physics dude, it's amazing
            end
            self.ball.dy = self.ball.dy * 1.03
            ---to allow only collision with one brick in a single frame
            break
        end
    end

    if self.ball.y >= VIRTUAL_HEIGHT then
        self.health = self.health - 1
        gSounds['hurt']:play()

        if self.health == 0 then
            gStateMachine:change('game-over', {
                score = self.score,
                highScores = self.highScores
            })
        else
            gStateMachine:change('serve', {
                paddle = self.paddle,
                bricks = self.bricks,
                health = self.health,
                score = self.score,
                highScores = self.highScores,
                level = self.level
            })
        end
    end
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function PlayState:render()
    
    for k, brick in pairs(self.bricks) do
        brick:render()
    end
    
    --for each brick Particle system is initialized but will only run/emit for the brick whose hit method is ran
    for k, brick in pairs(self.bricks) do
        brick:renderParticles()
    end

    self.paddle:render()
    self.ball:render()

    renderHealth(self.health)
    renderScore(self.score)

    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16,VIRTUAL_WIDTH, 'center')
    end
end

function PlayState:checkCompletion()
    for k, brick in pairs(self.bricks) do 
        if brick.inPlay then
            return false
        end
    end
    return true
    --[[if self.score > 600 then
        return true
    end
    return false]]
end