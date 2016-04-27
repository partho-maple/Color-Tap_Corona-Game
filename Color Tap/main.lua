require 'revmob' 

local REVMOB_IDS = { ["Android"] = "50ea453c0a07a50003000013", ["iPhone OS"] = "50e65825207a611b05000042" } 
	RevMob.startSession(REVMOB_IDS)
	local banner = RevMob.createBanner({x = display.contentWidth / 2, y = display.contentHeight - 20, width = 300, height = 40 }) 

	
display.setStatusBar(display.HiddenStatusBar)

_W = display.contentWidth
_H = display.contentHeight

system.activate( "multitouch" )

local director = require("director")

local mainGroup = display.newGroup()

local function main()

	mainGroup:insert(director.directorView)

	director:changeScene("menu")
	
	return true
end

main()
