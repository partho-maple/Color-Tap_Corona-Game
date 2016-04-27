require 'revmob_facade'

function msg(message)
  print("[RevMob Sample App] " .. tostring(message))
  io.output():flush()
end

revmobListener = function (event)
  msg("Event: " .. event.type)
  if event.type == "adReceived" then
  elseif event.type == "adNotReceived" then
  end
  for k,v in pairs(event) do msg(tostring(k) .. ': ' .. tostring(v)) end
end

local REVMOB_IDS = { ["Android"] = "4f56aa6e3dc441000e005a20", ["iPhone OS"] = "4fd619388d314b0008000213" }

local labels = {
  {'Start Session', function()
    msg("Start Session")
    RevMob.startSession(REVMOB_IDS)
    return true
  end },
  
  {'Start Session - Testing With Ads', function()
    msg("Start Session")
    RevMob.startSession(REVMOB_IDS, RevMob.TEST_WITH_ADS)
    return true
  end },
  
  {'Start Session - Testing Without Ads', function()
    msg("Start Session")
    RevMob.startSession(REVMOB_IDS, RevMob.TEST_WITHOUT_ADS)
    return true
  end },

  {'Show Random Fullscreen', function()
    msg("Show Random Fullscreen")
    RevMob.showFullscreen(revmobListener)
    return true
  end },
  
  {'Show Fullscreen Web', function()
    msg("Show Fullscreen Web")
    RevMob.showFullscreenWeb({listener = revmobListener})
    return true
  end },

  {'Show Fullscreen', function()
    msg("Show Fullscreen")
    RevMob.showFullscreenImage()
    return true
  end },
  
  {'Show Banner', function()
    msg("Show Banner")
    banner = RevMob.createBanner({listener = revmobListener, x = display.contentWidth / 2, y = display.contentHeight - 20, width = 300, height = 40 })
    bannerVisible = true
    return true
  end },
  {'Hide/Show Banner', function()
    msg("Hide/Show Banner")
    if banner then if bannerVisible then banner:hide() bannerVisible = false else banner:show() bannerVisible = true end end
    return true
  end },
  {'Release Banner', function()
    msg("Release Banner")
    if banner then banner:release() end
    return true
  end },
  
  {'Show Banner Web', function()
    msg("Show Banner Web")
    bannerWeb = RevMob.createBannerWeb({listener = revmobListener, x = 10, y = 10, width = 200, height = 50, rotation = 0 })
    bannerWebVisible = true
    return true
  end },
  {'Hide/Show Banner Web', function()
    msg("Hide/Show Banner Web")
    if bannerWeb then if bannerWebVisible then bannerWeb:hide() bannerWebVisible = false else bannerWeb:show() bannerWebVisible = true end end
	return true
  end },
  {'Update Banner Web', function()
    msg("Hide/Show Banner Web")
    if bannerWeb then bannerWeb:update(10, 10, 100, 50, bannerWeb.webView.rotation + 1) end
	return true
  end },
  {'Release Banner Web', function()
    msg("Release Banner Web")
    if bannerWeb then bannerWeb:release() end
    return true
  end },
  
  {'Show Pop-up', function()
    msg("Show Pop-up")
    RevMob.showPopup(revmobListener)
    return true
  end },

  {'Open Ad Link', function()
    msg("Open Ad Link")
    RevMob.openAdLink(revmobListener)
    return true
  end },
  
  {'Print Env Info', function()
    RevMob.printEnvironmentInformation(ids)
    return true
  end }
}

local y = 20
for i, v in ipairs(labels) do
  local btn = display.newText(v[1], 0, 0, native.systemFont, 18)
  btn:setTextColor(255, 255, 255, 255)
  btn:setReferencePoint(display.CenterReferencePoint)
  btn.x = display.contentWidth/2
  btn.y = (i * 30) + y
  btn:addEventListener('tap', v[2])
end

-- local b = Banner:new({ applicationId = "4f56aa6e3dc441000e005a20", width = 100, height = 200, x = 100, y = 100 })

-- local onSystem = function( event )
--   if event.type == "applicationStart" then
--     print("start")
--   elseif event.type == "applicationExit" then
--     print("exit")
--   elseif event.type == "applicationSuspend" then
--     print("suspend")
--   elseif event.type == "applicationResume" then
--     print("resume")
--   end
-- end
--
-- Runtime:addEventListener( "system", onSystem )
