module(...,package.seeall);

local storyboard = require("storyboard")
local scene = storyboard.newScene()

-- DICTIONARY TEST SHIT | DELETE WHEN FINISHED
local wordTest = "testers";
local exists = dictionary:word_exists(wordTest);
print("exists - "..wordTest.." - ");
if(exists) then print("exists");
else print(" does NOT exist"); end
-- END DICTIONARY TEST SHIT

-- grid vars
local gameBoard;
local hud;

--animate the background
local function animateBg()
	bgImage.x = 0;
	transition.to(bgImage,{x=-(1400-display.contentWidth),time=140000,onComplete=animateBg});
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view;

	--setup our background
	local rndBg = math.random(1,5);
	bgImage = display.newImageRect("assets/main menu/bg"..rndBg..".jpg",1400,960);
	bgImage:setReferencePoint(display.TopLeftReferencePoint);
	bgImage.x, bgImage.y = 0,0;
	animateBg();

	group:insert(bgImage);

	
	--create the game board and add to scene
	gameBoard = require("letter_grid_board").new(display.contentWidth,display.contentWidth,8,8);
	gameBoard.setup();
	group:insert(gameBoard.group);

	--create hud and add to scene
	hud = require("hud").newHUD(display.contentWidth,100);
	hud:setup();
	group:insert(hud.group);

end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view;
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view;
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view;
end

-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene