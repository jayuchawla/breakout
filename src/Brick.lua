
--to spawn particle system around brick when hit
paletteColors = {
    [1] = {
        ['r'] = (99/255),
        ['g'] = (155/255),
        ['b'] = (255/255)
    },
    [2] = {
        ['r'] = (106/255),
        ['g'] = (190/255),
        ['b'] = 47/255
    },
    [3] = {
        ['r'] = (217/255),
        ['g'] = (87/255),
        ['b'] = (99/255)
    },
    [4] = {
        ['r'] = (215/255),
        ['g'] = (123/255),
        ['b'] = (186/255)
    },
    [5] = {
        ['r'] = (251/255),
        ['g'] = (242/255),
        ['b'] = (54/255)
    }
}



Brick = Class{}

function Brick:init(x, y)

    self.x = x
    self.y = y
    self.width = 32
    self.height = 16

    self.inPlay = true

    self.tier = 0
    self.color = 1

    self.psystem = love.graphics.newParticleSystem(gTextures['particle'], 32)
    self.psystem:setParticleLifetime(0.5, 0.7)
    self.psystem:setLinearAcceleration(-15, -80, 15, 80)
    self.psystem:setAreaSpread('normal', 8, 8)
end

function Brick:hit()

    self.psystem:setColors(
        paletteColors[self.color]['r'], 
        paletteColors[self.color]['g'], 
        paletteColors[self.color]['b'], 
        20 * (self.tier + 1), --higher this value higher is opacity
        paletteColors[self.color]['r'], 
        paletteColors[self.color]['g'], 
        paletteColors[self.color]['b'],
        0 --bring down the opacity to 0 
        )
    
    self.psystem:emit(32)

    gSounds['brick-hit-2']:stop()
    gSounds['brick-hit-2']:play()

    --self.tier > 0 it means it is a not a plain/solid brick
    --after hit if colr is blue only then make it plain/solid and give it color 5 and keep on reducing color at each hit if color is not blue i.e 1
    if self.tier > 0 then
        if self.color == 1 then 
            self.tier = self.tier - 1
            self.color = 5
        else
            self.color = self.color - 1
        end
    else
        if self.color == 1 then
            self.inPlay = false
        else
            self.color = self.color - 1
        end
    end
    
    if not self.inPlay then
        gSounds['brick-hit-1']:stop()
        gSounds['brick-hit-1']:play()
    end
end

function Brick:render()
    if self.inPlay then
        --- look breakout.png 5 color bricks available and for each color we have powerups poerups are accesed using tier 
        love.graphics.draw(gTextures['main'],gFrames['bricks'][1 + (self.color - 1)*4 + self.tier], self.x, self.y)
    end
    
end

function Brick:update(dt)
    self.psystem:update(dt)
end

function Brick:renderParticles()
    love.graphics.draw(self.psystem, self.x + 16, self.y + 8)
end