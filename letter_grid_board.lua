module(...,package.seeall)


function new(width,height,numX,numY)
	print("letter_grid_board :: new");
	local grid = {};

	grid.itemSelected = nil
	grid.itemSelected2 = nil

	grid.width = width;		-- grid width in pixels
	grid.height = height; -- grid height in pixels
	grid.sizeX = numX;	-- number of items horizontally
	grid.sizeY = numY;	-- number of items vertically
	grid.items = {};	-- table of grid letter items

	grid.wordsFoundAtIndices = {};

	--create/setup our game piece
	--numX & numY = number of horizinal, vertical grid pieces, width + height = game board width/height in pixels
	function grid:setup()
		print("letter_grid_board :: setup "..grid.width..","..grid.height..","..grid.sizeX..",",grid.sizeY);

		-- calculate item size
		grid.itemWidth = grid.width/grid.sizeX;
		grid.itemHeight = grid.height/grid.sizeY;

		grid.distanceDelta = grid.itemWidth*1.5;

		--create our group
		grid.group = display.newGroup(0,0,grid.width,grid.height);
		grid.group:setReferencePoint(display.TopLeftReferencePoint); --Top left reference point
		-----------------------------------
		-- create our item gride
		-----------------------------------

		local index=1;
		--setup our letters initially
		for y=1,grid.sizeY do
			for x=1,grid.sizeX do
				print(" .. creating "..x..","..y)

				--create grid letter
				grid.items[index] = require("letter_game_piece").newCube(grid.itemWidth-2,grid.itemWidth-2);

				--random letter with predefined distribution
				local rndLetter = dictionary:randomLetter():upper();
				grid.items[index]:setup(rndLetter,index);	--index passed to piece.group.name

				-- add item to the letterboard group
				grid.group:insert(grid.items[index].group);

				-- position group
				grid.items[index].group.x = grid.itemWidth*(x-1)+grid.itemWidth/2; --add half width b/c of centered reference point
				grid.items[index].group.y = grid.itemHeight*(y-1)+grid.itemHeight/2; -- add half height b/c of centered reference point

				grid.items[index]:setSelected(false);

				index = index+1;
			end
		end

		--add touch events to each grid item

		for x = 1, #grid.items do
			grid.items[x].group:addEventListener("touch",itemTouched);
		end

		-- make sure there are no words generated on game start
		grid:removeAnyWords()

		grid:gamePieceAt(5,3)
	end

	function grid:removeAnyWords()

		local setupDone = false;

		local breakIndex = 0;

		-- keep looping util no words are found
		while(setupDone == false) do
			local wordsFound = false;

			--check every row for words
			for rowX=0,grid.sizeY-1 do

				local found = grid:checkRowForWords(rowX,false);

				if(found == true) then
					wordsFound = true;
					break;
				end
			end

			-- no words found? fantastic, exit this function
			if(wordsFound == false) then
				setupDone = true;
				print("No words found on game board. Start game!")
			else
				print("Words found on game board, randomize these letters");

				-- words found so rerandomize those letters
				for i=1,#grid.wordsFoundAtIndices do
					--grid.items[grid.wordsFoundAtIndices[i]]:randomizeLetter()
					local indexer = grid.wordsFoundAtIndices[i];
					print("Randomize letters - "..indexer);
					grid.items[indexer]:randomizeLetter();
				end
			end

			-- force a break if we haven't found a board without words after (x) iterations
			breakIndex = breakIndex + 1;
			if(breakIndex > 5000) then 
				setupDone = true;
			end
		end
	end

	------------------------------------
	-- TOUCH EVENT
	------------------------------------
	function itemTouched(evt)
		if(evt==nil) then
			print("evt = nil wtf");
		end
		--make sure touch event is only fired on touch ended
		if evt.phase == 'ended' then
			print("itemTouched - ended - "..evt.target.name)
			print("itemTouched - obj = ")
			local item = grid.items[evt.target.name] -- get the item OBJECT not just the evt target .GROUP

			-- make sure this isn't a non-movable piece
			if item.type ~=4 then
				grid:swapper(item);
			end
		end
	end

	--swap the gems
	function grid:swapper(obj)

		-- same object? fail swapper
		if obj == grid.itemSelected then
			--reset items
			print("grid.swapper obj == itemSelected (tapped same item twice)");
			grid.resetSelectedItems()
			return
		end

		-- first item not selected yet
		if (grid.itemSelected == nil) then
			print("no previous item selected")
			grid.itemSelected = obj
			obj:setSelected(true)
			return true

		-- first item selected, try to do swap
		else
			print("there is a previous item selected")
			grid.itemSelected2 = obj

			-- make sure itemSelected2 is adj to itemSelected
			if grid.itemsSelectedAreAdj() then

				-- swap our grid indices and grid items
				-- basically updates our grid to reflect the current letters displayed - not the originally created grid
				local s1Index = obj.group.name;
				local s2Index = grid.itemSelected.group.name;

				print("i1="..s1Index..",s2="..s2Index)

				obj.group.name = s2Index;
				grid.itemSelected.group.name = s1Index;

				grid.items[s2Index] = obj;
				grid.items[s1Index] = grid.itemSelected;

				transition.to(obj.group, {time=200, x = grid.itemSelected.group.x, y = grid.itemSelected.group.y, transition = easing.inOutExpo,onComplete=grid.checkForLegitWord})
				transition.to(grid.itemSelected.group, {time=200, x = obj.group.x, y = obj.group.y, transition = easing.inOutExpo})
				grid.itemSelected:setSelected(false)
			else
				grid.resetSelectedItems();
			end

			return true
		end
	end

	--swap the gems
	function grid:swapBack()
		print("swapBack")

		local s1Index = grid.itemSelected2.group.name;
		local s2Index = grid.itemSelected.group.name;

		print("i1="..s1Index..",s2="..s2Index)

		grid.itemSelected2.group.name = s2Index;
		grid.itemSelected.group.name = s1Index;

		grid.items[s2Index] = grid.itemSelected2;
		grid.items[s1Index] = grid.itemSelected;

		transition.to(grid.itemSelected2.group, {time=200, x = grid.itemSelected.group.x, y = grid.itemSelected.group.y, transition = easing.inOutExpo})
		transition.to(grid.itemSelected.group, {time=200, x = grid.itemSelected2.group.x, y = grid.itemSelected2.group.y, transition = easing.inOutExpo})
		grid.resetSelectedItems()
	end

	function grid:checkForLegitWord()
		print("checkForLegitWord");

		-- reset words found (letter index)
		grid.wordsFoundAtIndices = {};

		local foundWord = false;
		foundWord = false;

		--check every row for words
		for rowX=0,grid.sizeY-1 do
			local found = grid:checkRowForWords(rowX,true); -- passing true b/c we want letters to pop on words found

			if(found == true) then
				foundWord = true;
			end
		end

		-- no words were found
		if(foundWord == false) then
			print("No words found with this swap.")
			-- no we did not find a legitimate word on the board, swap pieces back
			grid:swapBack();
			-- deselect letters
			grid:resetSelectedItems()
		else

			-- words were found in this swap
			-- fill in the holes
			print("Word found in this swap");

			-- deselect letters
			grid:resetSelectedItems()

			-- fill in holes
			grid:fillInHoles();
		end
	end

	--returns true if itemSelected && itemSelected2 are adjacent to eachother
	-- hack using piece distance rather than checking top,left,right,bottom,horz grid
	function grid:itemsSelectedAreAdj()
		local deltaX = math.abs(grid.itemSelected.group.x - grid.itemSelected2.group.x)
		local deltaY = math.abs(grid.itemSelected.group.y - grid.itemSelected2.group.y)

		-- get the distance between the two pieces
		local distance = math.sqrt(deltaX*deltaX+deltaY*deltaY);

		print("grid max distance = "..grid.distanceDelta);
		print("item distance = "..distance);

		-- distance is too great. these pieces are not adj
		if distance < grid.distanceDelta then
			return true
		end

		return false
	end

	--resets any selected states back to original
	function grid:resetSelectedItems()
		if grid.itemSelected then grid.itemSelected.setSelected(true) end
		if grid.itemSelected2 then grid.itemSelected2.setSelected(false) end

		grid.itemSelected = nil;
		grid.itemSelected2 = nil;
	end

	function grid:gamePieceAt(xer,yer)
		local index = yer * grid.sizeX + xer
		print("gamePieceAt - "..xer..","..yer.." index:"..index)


	end

	-- checks entire grid for words
	-- use this when generating grids
	-- use any time swap occurs
	-- use after any words are accepted, tiles are destroyed and new letters drop
	function grid:checkRowForWords(rowIndex,doPopOnFind)
		-- get the grid index for start and end of this row
		local startIndex = rowIndex*grid.sizeX+1;
		local endIndex = rowIndex*grid.sizeX+grid.sizeX;

		--print("rowIndexForItem (row index) "..rowIndex);
		--print(" .. rowIndexForItem (starting grid index) "..startIndex);
		--print(" .. rowIndexForItem (ending grid index) "..endIndex);

		-- generate our string to pass to word checkers
		local rowString="";
		local i=0

		for i=startIndex,endIndex do
			rowString = rowString..grid.items[i].letterString;
		end

		local largestWord = "";
		local largestWordStart = -1;
		local largestWordEnd = -1;

		-- now iterate through every column
		for col=1,grid.sizeX-2 do
			--print(" .. checking "..rowString.." starting at "..col)
			--iterate from start+3 to end indices of string
			for colEnd=col+2,grid.sizeX do
				local checkWord = rowString:sub(col,colEnd);
				print(" .. checking "..rowString.." starting at "..col.." to " ..colEnd.." which = "..checkWord)
				-- check for word in dictionary

				-- does word exist in dictionary?
				if dictionary:word_exists(checkWord) then
					print("WORD EXISTS! - "..checkWord .." len="..checkWord:len() );

					-- if it's the largest word in the row, then use it
					if checkWord:len() > largestWord:len() then
						print("\n\n .. SETTING NEW LARGEST WORD - "..checkWord.."\n\n");
						largestWord = checkWord;
						largestWordStart = startIndex + col-1;
						largestWordEnd = startIndex + colEnd-1;
					end
				end
			end
		end

		--print(" .. rowString - "..rowString)

		if largestWord:len() > 0 then

			-- Should we pop the letters? Only do this when actually playing game, not board setup
			
				--print("FOUND LARGEST WORD IN ROW "..largestWord);
				-- push our indicies to our word grid (remove these letters)
				for f=largestWordStart,largestWordEnd do 
					--print("removing letter .. "..f)
					if(doPopOnFind== true) then
						grid.items[f].group.isVisible = false;
					end
					print("set wordsFoundAtIndices at "..#grid.wordsFoundAtIndices.." to "..f)
					grid.wordsFoundAtIndices[#grid.wordsFoundAtIndices+1] = f; --store index to letters that form words
				end

			

			return true -- word found in this row
		end

		-- no word found in this row
		return false
	end

	--checks the column for any empty spaces and returns the number of "holes" (empty spaces)
	function grid:holeCountForColumn(colIndex)
		print("letter_grid_board:holeCountForColumn : "..colIndex);
		local numHoles = 0;

		-- iterate through every row in the column
		for i=0,(grid.sizeY-1) do
			local letter = grid.items[colIndex+(i*grid.sizeX)].letterString;
			print(" checking item "..(colIndex+(i*grid.sizeX)) .." = "..letter);

			-- check for hidden letter
			if grid.items[colIndex+(i*grid.sizeX)].group.isVisible == false then
				print("FOUND HOLE IN COLUMN");
				numHoles = numHoles+1;
			end
		end

		return numHoles;
	end

	--fill in holes
	function grid:fillInHoles()
		print("fillInHoles")

		-- check every column for holes
		for col=1,grid.sizeX do
			local numHoles = grid:holeCountForColumn(col);
			print("numHoles for col("..col..") = "..numHoles);

			if numHoles > 0 then
				grid:fillColumnHoles(col);
			end
		end

	end

	--fill holes in particular column
	function grid:fillColumnHoles(colIndex)
		print("fillColumnHoles : "..colIndex)

		-- iterate through every row in the column starting from the bottom
		for i=(grid.sizeY-1),0 do
			local letter = grid.items[colIndex+(i*grid.sizeX)].letterString;
			print("fillColumnHoles : letter = "..letter);
		end

	end

	return grid;
end
