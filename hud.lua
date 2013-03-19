--[[

HUD contains all major layers of heads up display including:
current score
current level
amount of time left
bonus bar, etc

--]]
module(...,package.seeall);

local storyboard = require( "storyboard" )




function newHUD(width,height)

	local startPosition = display.contentHeight - 80
	local hud = {};
	hud.width = width;
	hud.height = height;
	hud.timeLeftInt = 360 -- amount of time for each "blitz" game

	--create our group
	hud.group = display.newGroup(0,0,width,height);
	hud.group:setReferencePoint(display.TopLeftReferencePoint);


	function hud:setup()
		print("hud::setup");
		-- create score labels
		hud.createScoreLabels();
		--create level labels
		--hud.createLevelLabels()
		--create time left hud
		hud.createTimeLeft()

		hud.startGameTimer()
	end


	function hud:createScoreLabels()
		hud.scoreLabel = display.newText("Score: 102,234",10,startPosition,"Akzidenz-Grotesk BQ Bold",15);
		hud.scoreLabel:setTextColor(255,255,255);
		hud.scoreLabel:setReferencePoint(display.TopLeftReferencePoint);
		hud.group:insert(hud.scoreLabel);
	end

	-- don't think we need time if we do "blitz" style

	--[[
	function hud:creatLevelLabels()
		hud.levelLabel = display.newText("Level: 5",0,20,"Akzidenz-Grotesk BQ Bold",15);
		hud.levelLabel:setTextColor(255,255,255);
		hud.levelLabel:setReferencePoint(display.TopLeftReferencePoint);
		hud.group:insert(hud.levelLabel);
	end
	--]]
	
	function hud:createTimeLeft()
		hud.timeLeft = display.newText("Time Left: "..hud.timeLeftInt,10,startPosition+20,"Akzidenz-Grotesk BQ Bold",15);
		hud.timeLeft:setTextColor(255,255,255);
		hud.timeLeft:setReferencePoint(display.TopLeftReferencePoint);
		hud.group:insert(hud.timeLeft);
	end

	--starts the game timer
	-- updates our time icon / label
	function hud:startGameTimer()
		timer.performWithDelay(1000,hud.updateTimer,1);
	end

	function hud:updateTimer(e)
		--print("game clock fired");
		hud.timeLeftInt = hud.timeLeftInt - 1
		hud.timeLeft.text = "Time Left: "..hud.timeLeftInt

		-- is the game over yet?
		if(hud.timeLeftInt > 0) then
			timer.performWithDelay(1000,hud.updateTimer,1);
		else
			--game over
			print("GAME OVER")
			hud:displayGameOverScreen()
		end

	end

	--game over screen
	function hud:displayGameOverScreen()
		--[[local bk = display.newRect(0,0,display.contentWidth,display.contentHeight)
		bk:setFillColor(0,0,0)
		bk.alpha = 0.5

		bk:addEventListener('touch',bkClicked);
		--hud.group:insert(bk)--]]

		--go to game over scene
		-- go to game scene
		storyboard.gotoScene("game_over_scene","crossFade",2000)
	end

	function bkClicked(evt)
		print('bk clicked');
		return true -- block this event from traveling upstream
	end

	return hud;
end