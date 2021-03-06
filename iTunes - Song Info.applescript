-- https://gist.github.com/275067/3acc381e6c830e059607f84aa9db31f4ed222290
-- by mfilej
--
-- changed to show rating 
-- better display for streams … espescially radio streaming  
-- by Ptujec
--
-- 2011-10-05
-- changed to convert image data to a tempory jpg file (due to changes of iTunes artwork image data)
-- with help of http://dougscripts.com/itunes/scripts/ss.php?sp=savealbumartjpeg

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
					if current stream title is not missing value then
						set aDescription to current stream title as text
					else if current stream URL is not missing value then
						set aDescription to current stream URL as text
					else
						set aDescription to " " as text
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
			else
				my growlRegister()
				tell application "Growl" to notify with name "Error" title "Error" description "No song playing" application name "iTunes - Song Info" priority 2
			end if
		end tell
	else
		my growlRegister()
		tell application "Growl" to notify with name "Error" title "Error" description "iTunes not running" application name "iTunes - Song Info" priority 2
	end if
end run

-- Check if application is running
on appIsRunning(appName)
	tell application "System Events" to (name of processes) contains appName
end appIsRunning

-- Register with Growl
on growlRegister()
	tell application "Growl"
		register as application "iTunes - Song Info" all notifications {"Song Info", "Error"} default notifications {"Song Info", "Error"} icon of application "iTunes"
	end tell
end growlRegister