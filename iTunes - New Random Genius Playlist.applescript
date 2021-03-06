-- Play New Random Genius Playlist in iTunes by Ptujec
-- The script will use a random song as the basis for a new genius playlist. 
-- See http://ptujec.tumblr.com/post/2874324070/itunes-new-random-genius-playlist-script for more information
--
-- source: http://www.macosxhints.com/article.php?story=20090805072808180
-- last edited 2011-10-05
--
-- !!! Mac sure the playlist name is right (engl.: "Music", ger.: "Musik")  !!!

tell application "iTunes"
	try
		repeat
			set aTrack to some file track of playlist "Musik" whose shufflable is true
			if video kind of aTrack is none then exit repeat
		end repeat
		
		play aTrack
		activate -- window 1
		reveal aTrack
		
		my _action()
		
		tell application "System Events" to set visible of process "iTunes" to false
		
		set aDescription to the name of aTrack
		set aTitle to the artist of aTrack
		
		-- rating 
		if rating of aTrack is 100 then
			set rating_ to " ★★★★★"
			-- else if rating of aTrack is 80 then
			--	set rating_ to " ★★★★"
			-- else if rating of aTrack is 60 then
			--	set rating_ to " ★★★"
			-- else if rating of aTrack is 40 then
			--	set rating_ to " ★★"
			-- else if rating of aTrack is 20 then
			--	set rating_ to " ★"
		else
			set rating_ to " "
		end if
		
		-- User artwork as icon if available otherwise default icon (iTunes icon)
		if (count of artwork of aTrack) ≥ 1 then
			set _artist to the artist of aTrack
			set _name to the name of aTrack
			
			
			set _home to POSIX path of (path to home folder)
			set pathToNewFile to (_home & "TMP/" & _artist & "_" & _name & ".jpg") as string
			tell me to set file_reference to (open for access pathToNewFile with write permission)
			tell application id "com.apple.iTunes" to write (get raw data of artwork 1 of aTrack) to file_reference starting at 0
			tell me to close access file_reference
			-- delay 0.5
			
			my growlRegister()
			tell application "Growl" to notify with name "Song Info" title aTitle description aDescription & rating_ application name "iTunes - Song Info" priority 0 image from location pathToNewFile
		else
			my growlRegister()
			tell application "Growl" to notify with name "Song Info" title aTitle description aDescription & rating_ application name "iTunes - Song Info" priority 0
		end if
		
		
	on error e
		my growlRegister()
		tell application "Growl" to notify with name "Error" title "Error" description e application name "iTunes - Song Info" priority 2
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
	tell application "Growl"
		register as application "iTunes - Song Info" all notifications {"Song Info", "Error"} default notifications {"Song Info", "Error"} icon of application "iTunes"
	end tell
end growlRegister