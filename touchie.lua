local ball = {}
local ballColors = { "yellow", "red", "yellow", "yellow", "red", "red", "yellow", "red", "yellow", "yellow", "black", "red", "red", "yellow", "red" }

local ballBody = { density=0.8, friction=0.2, bounce=0.5, radius=15 }

local n = 0

-- Arrange balls in triangle formation
for i = 1, 5 do
        for j = 1, (6-i) do
                n = n + 1
                ball[n] = display.newImage( "ball_" .. ballColors[n] .. ".png" )
                ball[n].x = 279 + (j*30) + (i*15)
                ball[n].y = 185 + (i*26)

                physics.addBody( ball[n], ballBody )
                ball[n].linearDamping = 0.3 -- simulates friction of felt
                ball[n].angularDamping = 0.8 -- stops balls from spinning forever
                ball[n].id = "ball" -- store object type as string attribute
                ball[n].color = ballColors[n] -- store ball color as string attribute
        end
end

-- Create cueball
local cueball = display.newImage( "ball_white.png" )
cueball.x = display.contentWidth/2; cueball.y = 780

physics.addBody( cueball, ballBody )
cueball.linearDamping = 0.3
cueball.angularDamping = 0.8
cueball.isBullet = true -- force continuous collision detection, to stop really fast shots from passing through other balls
cueball.color = "white"

target = display.newImage( "target.png" )
target.x = cueball.x; target.y = cueball.y; target.alpha = 0


local function resetCueball()
        cueball.alpha = 0
        cueball.x = 384
        cueball.y = 780
        cueball.xScale = 2.0; cueball.yScale = 2.0
        local dropBall = transition.to( cueball, { alpha=1.0, xScale=1.0, yScale=1.0, time=400 } )
end

local function updateScores()
        redScore.text = "RED - " .. redTotal
        yellowScore.text = "YELLOW - " .. yellowTotal
end

-- Handler for ball in pocket
local gameOver -- forward declaration; function is below
local function inPocket( self, event )
        event.other:setLinearVelocity( 0, 0 )
        local fallDown = transition.to( event.other, { alpha=0, xScale=0.3, yScale=0.3, time=200 } )

        if ( event.other.color == "white" ) then
                timer.performWithDelay( 50, resetCueball )
        elseif ( event.other.color == "red" ) then
                redTotal = redTotal + 1
                updateScores()
        elseif ( event.other.color == "yellow" ) then
                yellowTotal = yellowTotal + 1
                updateScores()
        elseif ( event.other.color == "black" ) then
                gameOver()
        end
end

-- Create pockets
local pocket = {}
for i = 1, 3 do
        for j = 1, 2 do
                local index = j + ((i-1) * 2) -- a counter from 1 to 6

                -- Add objects to use as collision sensors in the pockets
                local sensorRadius = 20
                pocket[index] = display.newCircle( -389 + (515*j), -436 + (474*i), sensorRadius )

                -- (Uncomment the line below to make the pocket sensors visible)
                --pocket[index]:setFillColor( 255, 0, 255 )

                physics.addBody( pocket[index], { radius=sensorRadius, isSensor=true } )
                pocket[index].id = "pocket"
                pocket[index].collision = inPocket
                pocket[index]:addEventListener( "collision", pocket[index] ) -- add table listener to each pocket sensor

        end
end

