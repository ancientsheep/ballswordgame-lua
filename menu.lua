-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require("storyboard")
local scene = storyboard.newScene()

--test the scoring
--local scoring = require("scoring")

-- include Corona's "widget" library
local widget = require("widget");


-- audio manager / play menu music
--audioManager:playMusic("main_menu.mp3");

-- magical dropping letters
local magic;

--scoring.saveWord("test")
--------------------------------------------

-- forward declarations and other locals
local playBtn, musicButton,sfxButton;

-- 'onRelease' event listener for playBtn
local function onPlayBtnRelease()
	--gc magic
	magic.destroy()
	magic = nil

	-- go to game scene
	storyboard.gotoScene("game_scene","crossFade",500)

	return true	-- indicates successful touch
end




-- Music button clicked
local function musicClicked(event)
	local music_off = audioManager.music_disabled;

	print("musicClicked - "..tostring(music_off));

	-- music is currently off, turn it on
	if(music_off==false) then
		audioManager:stopMusicChannel();
		event.target:setLabel("Music On");
	-- music is on, turn if off
	else
		audioManager:resumeMusicChannel();
		event.target:setLabel("Music Off");
	end

end

-- Testing dictionary
local function dictionaryClick(event)

	print("dictioanryClicked - ");

	for i=0,5000 do
		dictionary:word_exists("AUNT");
		--print("hey");
	end
end

-- Audio buttons
local function createAudioButtons(group)

	--get audio preferences
	local music_off = audioManager.music_disabled;
	local sfx_off = audioManager.sfx_diabled;

	print("menu :: createAudioButtons");

	-- setup music label
	local musicLabel;

	-- music is on
	if(music_off==false) then
		musicLabel = "Music Off";
	else
		musicLabel = "Music On";
	end

	--create music button
	--[[musicButton = widget.newButton{
		label=musicLabel,
		labelColor = { default={255}, over={128} },
		default="button.png",
		over="button-over.png",
		width=100, height=40,
		onRelease = musicClicked
	}
	musicButton:setReferencePoint(display.CenterReferencePoint);
	musicButton.x = display.contentWidth*0.5;
	musicButton.y = display.contentHeight - 250;

	--group:insert(musicButton);--]]




	--test dictionary
	dictButton = widget.newButton{
		label="Test Dictionary",
		labelColor = { default={255}, over={128} },
		default="button.png",
		over="button-over.png",
		width=100, height=40,
		onRelease = dictionaryClick
	}
	dictButton:setReferencePoint(display.CenterReferencePoint);
	dictButton.x = display.contentWidth*0.5;
	dictButton.y = display.contentHeight - 50;

	group:insert(dictButton);

end

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
--
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
--
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	local bk = require("animated_bk").new();
	bk.setup();
	group:insert(bk.bgImage);

	local scaler=0.53;

	-- create/position logo/title image on upper-half of the screen
	local titleLogo = display.newImageRect( "assets/main menu/logo.png", 640*scaler,192*scaler);
	titleLogo:setReferencePoint( display.CenterReferencePoint )
	titleLogo.x = display.contentWidth * 0.5
	titleLogo.y = 100

	-- create a widget button (which will loads level1.lua on release)
	playBtn = widget.newButton{
		label="Play Now",
		labelColor = { default={255}, over={128} },
		default="button.png",
		over="button-over.png",
		width=154, height=40,
		onRelease = onPlayBtnRelease	-- event listener function
	}
	playBtn:setReferencePoint(display.CenterReferencePoint);
	playBtn.x = display.contentWidth*0.5
	playBtn.y = display.contentHeight - 125

	-- create the magical dropping letters
	magic = require("fx_letter_drop").new();
	group:insert(magic.group);

	createAudioButtons(group);

	-- add menu buttons as collision objects
	magic:addCollisionObject(playBtn);
	magic:addCollisionObject(musicButton);

	-- all display objects must be inserted into group
	group:insert( titleLogo )
	group:insert( playBtn )

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
