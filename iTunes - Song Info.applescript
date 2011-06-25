-- https://gist.github.com/275067/3acc381e6c830e059607f84aa9db31f4ed222290
-- by mfilej
--
-- changed to show rating 
-- better display for streams … espescially radio streaming  
-- by Ptujec

-- Display the track if iTunes is running
on run
	if appIsRunning("iTunes") then
		tell application "iTunes"
			if exists name of current track then
				set aTrack to the current track
				set aDescription to the name of aTrack
				
				-- Podcast
				if aTrack is podcast then
					set aTitle to the name of aTrack
					set aDescription to the description of aTrack
					
					
				else if artist of aTrack is not "" then
					set aTitle to the artist of aTrack
					
					
					-- Stream
				else if artist of aTrack is "" then
					set aTitle to aDescription
					if current stream URL contains "http" then
						set aDescription to current stream title
					end if
					
				end if
				
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
					set anArtwork to data of artwork 1 of aTrack
					my growlRegister()
					tell application "GrowlHelperApp" to notify with name "Song Info" title aTitle description aDescription & rating_ application name "iTunes - Song Info" priority 0 pictImage anArtwork
				else
					my growlRegister()
					tell application "GrowlHelperApp" to notify with name "Song Info" title aTitle description aDescription & rating_ application name "iTunes - Song Info" priority 0
				end if
			else
				my growlRegister()
				tell application "GrowlHelperApp" to notify with name "Error" title "Error" description "No song playing" application name "iTunes - Song Info" priority 2
			end if
		end tell
	else
		my growlRegister()
		tell application "GrowlHelperApp" to notify with name "Error" title "Error" description "iTunes not running" application name "iTunes - Song Info" priority 2
	end if
end run

-- Check if application is running
on appIsRunning(appName)
	tell application "System Events" to (name of processes) contains appName
end appIsRunning

-- Register with Growl
on growlRegister()
	tell application "GrowlHelperApp"
		register as application "iTunes - Song Info" all notifications {"Song Info", "Error"} default notifications {"Song Info", "Error"} icon of application "iTunes"
	end tell
end growlRegister