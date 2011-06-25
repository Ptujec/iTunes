-- iTunes - New Genius Playlist
--
-- source: http://www.macosxhints.com/article.php?story=20090805072808180
-- The script will use the currently selected song as the basis for your genius playlist. 
-- Checks if iTunes is hidden and keeps that way after script is done.
--
-- edited by ptujec
-- last edited 2011-01-20

on open (f)
	tell application "iTunes"
		play f
		activate
		reveal current track
	end tell
	my _action()
	tell application "System Events" to set visible of process "iTunes" to false
end open

on run
	tell application "System Events"
		try
			if visible of process "iTunes" is true then
				set okflag to true
			else
				set okflag to false
			end if
			
			
			tell application "iTunes"
				activate
				reveal current track
			end tell
		end try
		
		my _action()
		
		if okflag is false then
			set visible of process "iTunes" to false
		end if
		
	end tell --
end run

on _action()
	try
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
	end try
end _action