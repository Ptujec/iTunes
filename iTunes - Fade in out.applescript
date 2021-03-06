(* 
  db iTunes Fade-in/out
  By David Battino, Batmosphere.com
  Based on ideas from Doug's AppleScripts and Mac OS Hints
  
  This script fades out iTunes if it's playing and fades it in if it's stopped.
*)


-- check if iTunes is running 
tell application "System Events"
	if process "iTunes" exists then
		set okflag to true --iTunes is running
	else
		set okflag to false
	end if
end tell

if okflag is true then
	tell application "iTunes"
		set currentvolume to the sound volume
		if player state is playing then
			repeat
				--Fade down	
				repeat with i from currentvolume to 0 by -1 --try by -4 on slower Macs
					set the sound volume to i
					delay 0.01 -- Adjust this to change fadeout duration (delete this line on slower Macs)
				end repeat
				pause
				--Restore original volume
				set the sound volume to currentvolume
				exit repeat
			end repeat
		else -- if player state is paused then
			
			set the sound volume to 0 --2007-03-20 script update to fix startup glitch
			play
			repeat with j from 0 to currentvolume by 1 --try by 4 on slower Macs
				set the sound volume to j
				delay 0.01 -- Adjust this to change fadeout duration (delete this line on slower Macs)	
			end repeat
			
			--- Notification
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
					
				end if
			end tell
			
			-- else if player state is stopped then
			
			-- my growlRegister()
			-- tell application "GrowlHelperApp" to notify with name "Error" title "Error" description "No song playing" application name "iTunes - Song Info" priority 2
		end if
		
	end tell
	
else
	my growlRegister()
	tell application "Growl" to notify with name "Error" title "Error" description "iTunes not running" application name "iTunes - Song Info" priority 2
end if

-- tell application "LaunchBar"
-- 	remain active
-- end tell

-- Register with Growl for Notification
on growlRegister()
	tell application "Growl"
		register as application "iTunes - Song Info" all notifications {"Song Info", "Error"} default notifications {"Song Info", "Error"} icon of application "iTunes"
	end tell
end growlRegister
