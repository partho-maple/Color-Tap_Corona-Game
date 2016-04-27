module(..., package.seeall)

function new()
	local localGroup = display.newGroup()
	
	require 'revmob' 

	local REVMOB_IDS = { ["Android"] = "50ea453c0a07a50003000013", ["iPhone OS"] = "50e657d9207a611200000029" } 
	RevMob.startSession(REVMOB_IDS)
	RevMob.showFullscreen()
	
	local background = display.newImage("background.jpg")
	background.x = -7
	background.y = -9
	background.xScale = 200
	
	localGroup:insert(background)
	
	local font = "Showcard Gothic"  
	local txt = display.newText("Level Seven", 50,90,font,40)
	txt:setTextColor(255,255,255)
	localGroup:insert(txt)
	
	local font = "Showcard Gothic"  
	local txt = display.newText("Tap Yellow", 60,140,font,35)
	txt:setTextColor(255,255,0)
	localGroup:insert(txt)
	

	local playbutton = display.newImage("playbutton.png")
	playbutton.x = display.contentWidth / 2
	playbutton.y = display.contentHeight -200
	playbutton.xScale = .30
	playbutton.yScale = .30

	
	playbutton.scene = "levelseven"
	
	localGroup:insert(playbutton)
	
	function changeScene(e)
		if(e.phase == "ended") then
			director:changeScene(e.target.scene)
		end
	end
	
	playbutton:addEventListener("touch", changeScene)
	playbutton = nil

return localGroup
end

