-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require("storyboard")
local scene = storyboard.newScene()

-- include Corona's "widget" library
local widget = require("widget");

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
--
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
--
-----------------------------------------------------------------------------------------
local bgScaler=0.66; -- clean this shit up and get moving bg stuff into another lua file
--animate the background
local function animateBg()
	bgImage.x = 0;
	transition.to(bgImage,{x=-(1400*bgScaler-display.contentWidth),time=120000,onComplete=animateBg});
end

-- Called when the scene's view does not exist:
function scene:createScene(event)
	print("game over scene created");

	local group = self.view

	-- add our background
	local bg = require("animated_bk").new()
	bg.setup()
	group:insert(bg.group);

	--add main menu button
	local menuBtn = widget.newButton{
		label="Main Menu",
		labelColor = { default={255}, over={128} },
		default="button.png",
		over="button-over.png",
		width=154, height=40,
		onRelease = onPlayBtnRelease	-- event listener function
	}
	menuBtn:setReferencePoint(display.CenterReferencePoint);
	menuBtn.x = display.contentWidth*0.5
	menuBtn.y = display.contentHeight - 125

	group:insert(menuBtn)

	menuBtn.addEventListener('touch',menuClick)

	function menuClick(evt)
		print('main menu clicked')
		
	end

end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view

	-- INSERT code here (e.g. start timers, load audio, start listeners, etc.)

end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view

	-- INSERT code here (e.g. stop timers, remove listenets, unload sounds, etc.)
	print("menu :: exitScene");
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view

	print("menu :: destroyScene");

	if playBtn then
		playBtn:removeSelf()	-- widgets must be manually removed
		playBtn = nil
	end
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
