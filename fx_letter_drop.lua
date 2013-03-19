module(...,package.seeall)

-- add physics

local physics = require("physics")
physics.start();
physics.pause();
--physics.setDrawMode("hybrid");

local randomTimerCount = 400;
local tileSize = 30;
local shouldDropCrates = false;

--[[
local centerX = display.contentWidth / 2
local centerY = display.contentHeight / 2
--]]

function generateLetterCrate(group)
	--print("generateLetterCrate");

	local letterSize,halfSize = 30,15;

	-- create random letter grid
	local newCrate = require("letter_game_piece").newCube(letterSize,letterSize);
	local rndLetter = dictionary:randomLetter():upper();
	newCrate:setup(rndLetter,1);
	newCrate:setCenterAlign();
	-- position new crate
	newCrate.group.y = -20;
	newCrate.group.x = math.random(1,320);
	newCrate.group.rotation = math.random()*360;

	--physics.setDrawMode('hybrid');

	--center body
	newCrate.group:setReferencePoint(display.CenterReferencePoint);

	physics.addBody(newCrate.group,{
							density=1.0,
							friction=0.3,
							bounce=0.3,
							--shape = {0,0, letterSize,0, letterSize,letterSize, 0,letterSize} -- create our own shape since default is screwing up
							});
	group:insert(newCrate.group);
end


-- creates new group with letter drop magic

function new()

	print("menu_letter_drop :: new");

	local letterDrop = {};

	--create our group to return
	letterDrop.group = display.newGroup(0,0,display.contentWidth,display.contentHeight);
	
	generateLetterCrate(letterDrop.group);

	physics.start();


	function newCrate(e)
    	--print("timer fired");
    	generateLetterCrate(letterDrop.group);

    	if shouldDropCrates==true then
    		-- start our timer again
			timer.performWithDelay(
	    	math.random()*randomTimerCount,newCrate,1);
		end
    end

    shouldDropCrates = true;
	-- start our timer
	localTimer = timer.performWithDelay(
    math.random()*randomTimerCount,newCrate,1);

--[[    function shakieShake(e)
    	if (letterDrop.group.numChildren) then
    		for i = 1, letterDrop.group.numChildren do
    			print("the child"..tostring(letterDrop.group[i]))
    			letterDrop.group[i]:applyTorque(400)
    		end
    	end
    	-- letterDrop.group.x = centerX + (centerX / 2 * e.xGravity)
     --    letterDrop.group.y = centerY / 2 + (centerY / 2 * e.yGravity * -1)
    end
    --]]

	-- create an invisible collision object with bounds of display object passed
	function letterDrop:addCollisionObject(obj)
		print("addCollisionObject "..obj.x..","..obj.y);
		local halfW,halfH = obj.width/2,obj.height/2;
		-- define a shape that's slightly shorter than image bounds (set draw mode to "hybrid" or "debug" to see)
		local invisibleShape = display.newRect(obj.x-halfW,obj.y-halfH,obj.width,obj.height);
		invisibleShape:setReferencePoint(display.TopLeftReferencePoint);
		invisibleShape.alpha = 0;
		physics.addBody(invisibleShape,"static",{friction=0.3});
	end

	-- this code f's up the editor
	--Runtime:addEventListener ("accelerometer", shakieShake);

	-- End our physics engine, remove bodies, kill event listeners
	function letterDrop:destroy()
		print("fx_letter_drop :: destroy");
		timer.pause(localTimer);
		shouldDropCrates = false;
		physics.stop();
	end

	return letterDrop;
end

