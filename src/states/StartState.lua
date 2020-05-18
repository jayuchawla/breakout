StartState = Class{__includes = BaseState}  --inherit BaseState and override function definition

local highlighted = 1 ---play game or show score

function StartState:enter(params)
    self.highScores = params.highScores
end

function StartState:update(dt)
    if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
        highlighted = highlighted == 1 and 2 or 1
        gSounds['paddle-hit']:play()
    end    

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gSounds['confirm'] : play()
        
        ---state info passign is done below
        if highlighted == 1 then
            local lm = LevelMaker()
            
            gStateMachine:change('paddle-select', {
                highScores = self.highScores,
            })

        elseif highlighted == 2 then
            gStateMachine : change('high-score',{
                highScores = self.highScores
            })
        end
    end
end

function StartState:render()
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('BREAKOUT',0,VIRTUAL_HEIGHT/3,VIRTUAL_WIDTH,'center')
    
    love.graphics.setFont(gFonts['medium'])

    if highlighted == 1 then
        love.graphics.setColor(251/255, 242/255, 54/255, 255/255)
    end
    love.graphics.printf('START',0,VIRTUAL_HEIGHT/2+70,VIRTUAL_WIDTH,'center')

    love.graphics.setColor(255, 255, 255, 255)

    if highlighted == 2 then
        love.graphics.setColor(251/255, 242/255, 54/255, 255/255)
    end
    love.graphics.printf('HIGH SCORES',0,VIRTUAL_HEIGHT/2+90,VIRTUAL_WIDTH,'center')
end