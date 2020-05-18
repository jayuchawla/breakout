---patterns
NONE = 1
SINGLE_PYRAMID = 2
MULTI_PYRAMID = 3

---pattern in each row
SOLID = 1
ALTERNATE = 2
SKIP = 3
NONE = 4

LevelMaker = Class{}

function LevelMaker:createMap(level)

    local bricks = {}
    local numRows = math.random(1,5)
    --numCols has to be odd
    local numCols = math.random(7,13)
    numCols = numCols % 2 == 0 and (numCols + 1) or numCols

    --we have different types of bricks some break at first collision some require 2 some 3 and some 4
    --as level increases 2 collision bricks occur if further level increase 3 collision brick occur
    --hence we use tier to know all types of brick that can be spawned
    local highestTier = math.min(3, math.floor(level/5))

    ---each level has min 3 and max 5 color blocks 
    local highestColor = math.min(5, level % 5 + 3)
    
    for y = 1,numRows do

        --this row follows skipping pattern or not
        local skipPattern = math.random(1,2) == 1 and true or false
        local alternatePattern = math.random(1,2) == 1 and true or false

        local alternateColor1 = math.random(1,highestColor)
        local alternateColor2 = math.random(1,highestColor)
        local alternateTier1 = math.random(0,highestTier)
        local alternateTier2 = math.random(0,highestTier)
        
        local skipFlag = math.random(1,2) == 1 and true or false
        local alternateFlag = math.random(1,2) == 1 and true or false

        local solidColor = math.random(1,highestColor)
        local solidTier = math.random(1,highestTier)

        for x = 1,numCols do
            
            --if skipPattern is false we always go to else block and the brick is
            --always created in simple terms if skipPattern is false if block is always
            --false and hence directly going to label is not allowed 
            if skipPattern and skipFlag then
                --disable skip for next block
                skipFlag = not skipFlag
                goto label
            else
                skipFlag = not skipFlag
            end
            
            b = Brick((x-1)*32 + 8 + (13-numCols) * 16, y * 16) --(13-numCols) * 16??? when num of cols < 13 we wanna keep center alignment
            
            if alternatePattern and alternateFlag then
                b.color = alternateColor1
                b.tier = alternateTier1
                alternateFlag = not alternateFlag
            else
                b.color = alternateColor2
                b.tier = alternateTier2
                alternateFlag = not alternateFlag
            end

            if not alternatePattern then
                b.color = solidColor
                b.tier = solidTier
            end

            table.insert(bricks, b)
            
            ::label::
        end
    end
    
    if #bricks == 0 then
        return self:createMap(level)
    else
        return bricks
    end
end