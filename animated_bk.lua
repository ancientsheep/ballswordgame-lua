module(...,package.seeall);

local bgScaler=1; -- clean this shit up and get moving bg stuff into another lua file

function new()
	local bg = {};
		
	print("animated_bk :: new");

	--create our group
		bg.group = display.newGroup(0,0,1400*bgScaler,960*bgScaler);
		bg.group:setReferencePoint(display.TopLeftReferencePoint);
		bg.group.x,bg.group.y=0,0

	function bg:setup()
		--generate random bk
		local rndBg = math.random(1,5);

		-- display a background image
		bg.bgImage  = display.newImageRect( "assets/main menu/bg"..rndBg..".jpg",1400*bgScaler,960*bgScaler);
		bg.bgImage:setReferencePoint(display.TopLeftReferencePoint)
		bg.bgImage.x,bg.bgImage.y = 0,0;
		bg.animateBg(); --animate the background
		--bg.group:insert(bg.bgImage);
	end

	--animate the background
	function bg:animateBg()
		bg.bgImage.x = 0;
		transition.to(bg.bgImage,{x=-(1400-display.contentWidth),time=140000,onComplete=bg.animateBg});
	end

	return bg;
end