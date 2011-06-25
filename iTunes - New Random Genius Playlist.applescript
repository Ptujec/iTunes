-- Play New Random Genius Playlist in iTunes by Ptujec
-- The script will use a random song as the basis for a new genius playlist. 
-- See http://ptujec.tumblr.com/post/2874324070/itunes-new-random-genius-playlist-script for more information
--
-- source: http://www.macosxhints.com/article.php?story=20090805072808180
-- last edited 2011-01-22
--
-- !!! Mac sure the playlist name is right (engl.: "Music", ger.: "Musik")  !!!

tell application "iTunes"
	try
		repeat
			set _track to some file track of playlist "Musik" whose shufflable is true
			if video kind of _track is none then exit repeat
		end repeat
		
		play _track
		activate -- window 1
		reveal _track
		
		my _action()
		
		tell application "System Events" to set visible of process "iTunes" to false
		
		set aDescription to the name of _track
		set aTitle to the artist of _track
		
		-- rating 
		if rating of _track is 100 then
			set rating_ to " ★★★★★"
			-- else if rating of _track is 80 then
			--	set rating_ to " ★★★★"
			-- else if rating of _track is 60 then
			--	set rating_ to " ★★★"
			-- else if rating of _track is 40 then
			--	set rating_ to " ★★"
			-- else if rating of _track is 20 then
			--	set rating_ to " ★"
		else
			set rating_ to " "
		end if
		
		-- User artwork as icon if available otherwise default icon (iTunes icon)
		if (count of artwork of _track) ≥ 1 then
			set anArtwork to data of artwork 1 of _track
			my growlRegister()
			tell application "GrowlHelperApp" to notify with name "Song Info" title aTitle description aDescription & rating_ application name "iTunes - Song Info" priority 0 pictImage anArtwork
		else
			my growlRegister()
			tell application "GrowlHelperApp" to notify with name "Song Info" title aTitle description aDescription & rating_ application name "iTunes - Song Info" priority 0
		end if
		
	on error e
		my growlRegister()
		tell application "GrowlHelperApp" to notify with name "Error" title "Error" description e application name "iTunes - Song Info" priority 2
	end try
	
end tell

-- Genius (Ui Scripting)
on _action()
	
	tell application "System Events"
		
		tell process "iTunes"
			repeat with the_button in every button of window 1
				set the_props to properties of the_button
				if description of the_props is "genius" then
					click the_button
					-- return
				end if
			end repeat
		end tell
	end tell
	
end _action

-- Register with Growl
on growlRegister()
	tell application "GrowlHelperApp"
		register as application "iTunes - Song Info" all notifications {"Song Info", "Error"} default notifications {"Song Info", "Error"} icon of application "iTunes"
	end tell
end growlRegister