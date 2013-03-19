module(...,package.seeall);

require "sqlite3"

-- loads and creates dictionary based as well as dictionary config
function new()

	print("dictionary :: new");
	local dictionary = {};

	dictionary.path="";
	dictionary.table={};
	dictionary.letterDistString = "AAAAAAAAABBCCDDDDEEEEEEEEEEEEFFGGGHHIIIIIIIIIJKLLLLMMNNNNNNOOOOOOOOPPQRRRRRRSSSSTTTTTTUUUUVVWWXYYZ";
	dictionary.letterDist ={};
	dictionary.dbPath = system.pathForFile("assets/dictionaries/en.sqlite",system.ResourceDirectory)
	dictionary.db = sqlite3.open(dictionary.dbPath);
	dictionary.dictionarySub = 2; -- number of letters to break dictionary up into (so 3 could have a table index of 'AUN' and then AUR, etc)

	-- load a dictionary from inside assets/dictionaries
	function dictionary:load(file)
		-- create our sql table
		--local tablesetup = [[CREATE TABLE IF NOT EXISTS dictionary (id INTEGER PRIMARY KEY autoincrement, word);]]
		--dictionary.db:exec(tablesetup);

		print("dictionary :: load "..file);
		local path = system.pathForFile("assets/dictionaries/"..file,system.ResourceDirectory);
		print("path - "..path);
		--open file
		--add each word to our dictionary table / array

		local lastStartingLetter = '';

		for word in io.lines(path) do
		    
		    -- get first letter of word
		  	local startsWith = word:sub(0,dictionary.dictionarySub);
		  	--print("Found word that starts with - "..startsWith.." compared to last word found "..lastStartingLetter);

		  	-- if they do not match, create a new table since this is a different letter
		  	if(startsWith ~= lastStartingLetter) then
		  		dictionary.table[startsWith]={}; --create the table
		  	end

		    dictionary.table[startsWith][#dictionary.table[startsWith]+1]=word:upper();
		    lastStartingLetter = startsWith;
		    
		end
	end

	--does word exist
	function dictionary:word_exists(wordCheck)

		local firstLetters = wordCheck:sub(0,dictionary.dictionarySub);
		print("Checking for word.. "..wordCheck.. " - first letter ="..firstLetters);
		--[[for row in dictionary.db:nrows("SELECT * FROM dictionary WHERE word='"..wordCheck.."'") do
		  --print(row.id.." - "..row.word);
		  print("WORD FOUND");
		  return true;
		end--]]

		local exists = table.indexOf(dictionary.table[firstLetters],wordCheck:upper());

		if(exists==nil) then
			--print(" .. "..wordCheck.." NOT found in <Dictionary>")
			return false;

		else
			--print(" .. "..wordCheck.." FOUND in <Dictionary>")
			return true;
		end
	end

	--generate letter distribution array
	function generateLetterDistArray()
		print("generateLetterDistArray");
		for i=1,dictionary.letterDistString:len() do
			local letter = dictionary.letterDistString:sub(i,i);
			dictionary.letterDist[#dictionary.letterDist+1]=letter;
		end
	end

	--returns random letter based on letter distribtion
	function dictionary:randomLetter()
		local rndLetter = dictionary.letterDist[math.random(1,#dictionary.letterDist)];

		--print("randomLetter - "..rndLetter);
		return rndLetter;
	end

	--generate our letter dist
	generateLetterDistArray();

	return dictionary;
end
