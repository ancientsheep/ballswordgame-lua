-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- load our game dictionary
-- global variable
dictionary = require("dictionary").new();
dictionary:load("en.txt");

-- load preferences
preference = require("preference");

-- global audio manager
audioManager = require("audio_manager").new();
audioManager:preloadSFX();

--seed random num generator
math.randomseed(os.time());

-- include the Corona "storyboard" module
local storyboard = require("storyboard");

-- load menu screen
storyboard.gotoScene("menu");
