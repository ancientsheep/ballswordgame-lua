module(...,package.seeall);

local expectedSize = 40;

function newCube(width, height)
	local piece = {};
	piece.width = width;
	piece.height = height;
	piece.letterString = "empty";


	--create/setup our game piece
	function piece:setup(strLetter,index)
		--print("letter_game_piece :: setup - index: "..index);

		--create our group
		piece.group = display.newGroup(0,0,piece.width,piece.height);
		piece.group:setReferencePoint(display.TopLeftReferencePoint);
		piece.group.name = index;
		piece.letterString = strLetter;

		-- one in 15 chance of being a black brick
		--[[if math.random(1,30) > 29 then
			piece.type = 4
		else--]]
			piece.type = math.random(1,3);
		--end

		

		--selected stuff
		piece.group.isSelected = false;

		--create our background
		piece.bg = display.newImageRect("assets/game pieces/cubes/"..piece.type..".png",piece.width,piece.height);
		piece.bg:setReferencePoint(display.TopLeftReferencePoint);
		piece.bg.x, piece.bg.y = 0,0;
		piece.group:insert(piece.bg);

		--create our SELECTED background
		piece.bg_selected = display.newImageRect("assets/game pieces/cubes/"..piece.type.."_on.png",piece.width,piece.height);
		piece.bg_selected:setReferencePoint(display.TopLeftReferencePoint);
		piece.bg_selected.x, piece.bg_selected.y = 0,0;
		piece.group:insert(piece.bg_selected);
		piece.bg_selected.isVisible = false;

		--create and add our letter to group
		-- make sure this piece type has a letter
		if piece.type==4 then		-- 4 = blank board piece

		else
			piece.letter = display.newText(strLetter,50,10,"Akzidenz-Grotesk BQ Bold",30*(width/expectedSize));
			piece.letter:setTextColor(0,0,0);
			piece.letter:setReferencePoint(display.TopLeftReferencePoint);
			piece.letter.x,piece.letter.y=piece.width/2-piece.letter.width/2,piece.height/2-piece.letter.height/2;
			piece.group:insert(piece.letter);
		end

		--set the group reference point to the center
		piece.group:setReferencePoint(display.CenterReferencePoint);

	end

	function piece:setCenterAlign()

		piece.group:setReferencePoint(display.TopLeftReferencePoint);
		piece.bg:setReferencePoint(display.TopLeftReferencePoint);
		piece.bg_selected:setReferencePoint(display.TopLeftReferencePoint);

		--reposition b/c physics objects are meant to be centered
		piece.bg.x,piece.bg.y = -piece.width/2,-piece.height/2;
		piece.bg_selected.x, piece.bg_selected.y = -piece.width/2,-piece.height/2;

		if piece.type~=4 then
			--piece.letter:setReferencePoint(display.CenterReferencePoint);
			piece.letter.x=-8;
			piece.letter.y=-20;
			
		end
		
	end

	function piece:randomizeLetter()

		local strLetter = dictionary.randomLetter();
		string.upper(strLetter);
		print("randomizeLetter "..strLetter);
		piece.letterString = strLetter;
		piece.letter.text = strLetter;
	end

	function piece:setSelected(selected)
		--print("piece:setSelected "..tostring(selected));
		if selected==true then
			piece.group.alpha = 0.5
		else
			piece.group.alpha = 1.0
		end

	end

	function piece:setBk(imgPath)
		piece.bg = display.newImageRect(imgPath,piece.width,piece.height);
		piece.bg:setReferencePoint(display.TopLeftReferencePoint);
	end


	return piece;
end