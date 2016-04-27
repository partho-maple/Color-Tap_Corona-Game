module(..., package.seeall)

function new()
	local localGroup = display.newGroup()
		
require 'revmob' 

local REVMOB_IDS = { ["Android"] = "50f251f5f0be08c80e00002b", ["iPhone OS"] = "50e657d9207a611200000029" } 
	RevMob.startSession(REVMOB_IDS)
	RevMob.showFullscreen()
	
	local background = display.newImage("background.jpg")
	localGroup:insert(background)
	background.x = -7
	background.y = -9
	background.xScale = 200
	
	local font = "Showcard Gothic"  
	local txt = display.newText("Level Two", 25,90,font,50)
	txt:setTextColor(255,255,255)
	localGroup:insert(txt)
	
	local font = "Showcard Gothic"  
	local txt = display.newText("Tap Red", 86,140,font,35)
	txt:setTextColor(255,0,0)
	localGroup:insert(txt)
	

	local playbutton = display.newImage("playbutton.png")
	playbutton.x = display.contentWidth / 2
	playbutton.y = display.contentHeight -200
	playbutton.xScale = .30
	playbutton.yScale = .30

	
	playbutton.scene = "leveltwo"
	
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

