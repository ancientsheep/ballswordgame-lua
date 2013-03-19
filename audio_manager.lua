module(...,package.seeall);

function new()
	print("audio_manager :: new");

	audioman = {};
	audioman.musicChannel = nil;
	audioman.sfxChannel = nil;

	--sound effects
	audioman.piece_selected = nil;

	--load the audio preferences
	function audioman:loadAudioPreferences()
		print("loadAudioPreferences :");
		preference.printAll();	-- print all preferences DELETE ME

		audioman.music_disabled = preference.getValue("music_enabled");
		audioman.sfx_disabed = preference.getValue("sfx_enabled");

		if audioman.music_disabled==nil then audioman.music_disabled=false; end
		if audioman.sfx_disabled==nil then audioman.sfx_disabled=false; end

		--print("music : "..audioman.music_enabled.." sfx: "..audioman.sfx_enabled);
	end

	function audioman:setMusicEnabled(enabled)
		-- save settings to disc
		preference.save({music_disabled=2});
		preference:printAll();
	end

	-- pause the music
	function audioman:stopMusicChannel()
		print("stopMusicChannel");

		audio.pause(audioman.musicChannel);
		audioman.setMusicEnabled(false);
		audioman.music_disabled = true;
	end

	-- resume the music channel
	function audioman:resumeMusicChannel()
		print("resumeMusicChannel");
		audio.resume(audioman.musicChannel);
		audioman.setMusicEnabled(true);
		audioman.music_disabled = false;
	end

	--load audio preferences
	audioman:loadAudioPreferences();

	--preload small sound effects
	function audioman:preloadSFX()
		print("audioman:preloadSFX");
		audioman.piece_selected = audio.loadSound("assets/audio/piece_selected.mp3");
	end

	function audioman:playMusic(file)
		print("audio_manager:playMusic - "..file);
		print("audioman.music_disabled = "..tostring(audioman.music_disabled));

		if audioman.music_disabled==false then
			bgMusic = audio.loadStream("assets/audio/"..file);
			audioman.musicChannel = audio.play(bgMusic,{
													channel=1,
													loops=-1,
													fadein=5000});
		else
			bgMusic = audio.loadStream("assets/audio/"..file);
			audioman.musicChannel = audio.play(bgMusic,{
													channel=1,
													loops=-1,
													fadein=5000});
		end
	end

	function audioman:playSfx(snd)
		print("audio_manager:playSfx - "..snd);


			if snd=="piece_selected" then
				audioman.sfxChannel = audio.play(audioman.piece_selected,{
								channel=2,
								loops=0
								});
			end


	end

	return audioman;

end
