module(..., package.seeall)

function new()
	local localGroup = display.newGroup()
	
	local background = display.newImage("colorfulbackground.jpg")
	localGroup:insert(background)
	background.x = -7
	background.y = -9
	background.xScale = 200
	local font = "Showcard Gothic"  
	local txt = display.newText("COLOR TAP", 25,90,font,50)
	txt:setTextColor(255,255,255)
	localGroup:insert(txt)

	local playbutton = display.newImage("playbutton.png")
	playbutton.x = display.contentWidth / 2
	playbutton.y = display.contentHeight -175
	playbutton.xScale = .40
	playbutton.yScale = .40

	
	playbutton.scene = "levelone "
	
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

