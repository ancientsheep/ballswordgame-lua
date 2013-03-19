module(...,package.seeall);

-- score keeper, game settings, state, etc

function new()
	local score_keeper = {};

	score_keeper.team1_score = 0;
	score_keeper.team2_score = 0;

	score_keeper.current_word = "--";

	function score_keeper:randomizeCurrentWord()
		
	end
	

	return score_keeper;
end