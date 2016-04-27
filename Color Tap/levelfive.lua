module(..., package.seeall);

function new()
	local localGroup = display.newGroup();
		
		--Variable initialization
	local physics = require "physics"
	physics.start()	
		
	local mRand = math.random;
	local o = 0;
	local time_remain = 10;
	local time_up = false;
	local total_orbs = 15;
	local ready = false;

	--Prepare sounds to be played or accessed
	local pop_sound = audio.loadSound("bubblepop.mp3")
	local soundtrackChannel; --needed to stop the audio
	
	local background = display.newImage( "orangebackground.jpg" )
	background.x = display.contentWidth / 2
	background.y = display.contentHeight / 2
	
	localGroup:insert(background)

	local display_txt = display.newText("Wait", 0, 0, "Showcard Gothic", 17*2);
	display_txt.xScale = .5; display_txt.yScale = .5;
	display_txt:setTextColor(34,139,34)
	display_txt:setReferencePoint(display.BottomLeftReferencePoint);
	display_txt.x = 25; display_txt.y = _H-440;
	
	localGroup:insert(display_txt);

	local countdowntxt = display.newText(time_remain, 0, 0, "Showcard Gothic", 22*2);
	countdowntxt.xScale = .5; countdowntxt.yScale = .5;
	countdowntxt:setTextColor(34,139,34)
	countdowntxt:setReferencePoint(display.BottomRightReferencePoint);
	countdowntxt.x = _W-40; countdowntxt.y = _H-440;

	localGroup:insert(countdowntxt);
	
	local rightwall = display.newImage("leftwall.png", 70, 50)
	rightwall.x = -120
	rightwall.y = 100
	
	localGroup:insert(rightwall)
		
	physics.addBody( rightwall, "static", { density = 1.0, bounce = 2 } )
	
	local leftwall = display.newImage("leftwall.png", 70, 50)
	leftwall.x = 500
	leftwall.y = 100
	
	localGroup:insert(leftwall)
		
	physics.addBody( leftwall, "static", { density = 1.0, bounce = 3 } )
	
	local ground = display.newImage("rainbowbanner.jpg", 70, 50)
	ground.x = 200
	ground.y = 460
	
	localGroup:insert(ground)
	
	physics.addBody( ground, "static", { density = 1.0, bounce = 2 } )
	
	local sky = display.newImage("blackground.png", 70, 50)
	sky.x = 200
	sky.y = -50
	
	localGroup:insert(sky)
	
	physics.addBody( sky, "static", { density = 1.0, bounce = 2 } )
	
	local play_again = display.newImageRect("play-again.png", 320, 75);
	play_again:setReferencePoint(display.CenterReferencePoint);
	play_again.x = _W/2; play_again.y = _H/2 - play_again.height;
	play_again.isVisible = false;
	play_again.alpha = 0;
	play_again.scene = nil;
	
	local back_to_menu = display.newImageRect("back-btn.png", 320, 75);
	back_to_menu:setReferencePoint(display.CenterReferencePoint);
	back_to_menu.x = _W/2; back_to_menu.y = _H/2 + back_to_menu.height;
	back_to_menu.isVisible = false;
	back_to_menu.alpha = 0;
	back_to_menu.scene = "menu";
	
	local function winLose(condition)
		play_again.isVisible = true;
		back_to_menu.isVisible = true;
		
		transition.to(play_again, {time=500, alpha = 1});
		transition.to(back_to_menu, {time=500, alpha = 1});
	
		if(condition == "win") then
			display_txt.text = "WIN!"
			play_again.isVisible = false;
			back_to_menu.isVisible = false;
		elseif(condition == "fail") then
			audio.play(fail_sound);
			display_txt.text = "Try Again";
			ready = false;
		end
	end

	local function trackOrbs(obj)
		obj:removeSelf();
		o = o-1;
		
		if(time_up ~= true) then
			--If all the orbs are removed from the display
			if(o == 0) then
				director:changeScene( "congratslevelsix" )
				timer.cancel(gametmr)
					
				winLose("win")
			end
		end
	end

	local function countDown(e)
		if(time_remain == 10) then
			ready = true;
			display_txt.text = "Go!";
			soundtrackChannel = audio.play(soundtrack, {loops=-1});
		end
		time_remain = time_remain - 1;
		countdowntxt.text = time_remain;
		
		if(time_remain == 0) then
			time_up = true;
			
			if(o ~= 0) then
				winLose("fail");
			end
			
		end
	end

	local function spawnOrb()
		local orb = display.newImageRect("green.png", 50, 50);
		orb:setReferencePoint(display.CenterReferencePoint);
		orb.x = mRand(90, _W-55); orb.y = mRand(90, _H-75);
		orb.xScale = 0.7; orb.yScale = 0.7;
		orb.isOrb = true;
		
		transition.to(orb, {time=25, xScale = 1, yScale = 1})
		
	local yellow = display.newImage("yellow.png");
		yellow.x = mRand( 500 )
		yellow.y = 60
		yellow.isOrb = true;
		
		transition.to(yellow, {time=25, xScale = .1, yScale = .1})
		
		physics.addBody( yellow, { density = 1.0, friction = 0, bounce = 1, radius = 40 } )
		
	local orange = display.newImage("orange.png");
		orange.x = mRand( 490 )
		orange.y = 70
		orange.isOrb = true;
		
		transition.to(orange, {time=125, xScale = .1, yScale = .1})
		
		physics.addBody( orange, { density = 1.0, friction = 0, bounce = 1, radius = 40 } )
		
	local blue = display.newImage("blue.png");
		blue.x = mRand( 300 )
		blue.y = 40
		blue.isOrb = true;
		
		transition.to(blue, {time=125, xScale = .1, yScale = .1})
		
		physics.addBody( blue, { density = 1.0, friction = 0, bounce = 1, radius = 40 } )
		
	local pink = display.newImage("pink.png");
		pink.x = mRand( 450 )
		pink.y = 25
		pink.isOrb = true;
		
		transition.to(pink, {time=125, xScale = .1, yScale = .1})
		
		physics.addBody( pink, { density = 1.0, friction = 0, bounce = 1, radius = 40 } )
		
	local green = display.newImage("green.png");
		green.x = mRand( 250 )
		green.y = 30
		green.isOrb = true;
		
		transition.to(green, {time=125, xScale = .1, yScale = .1})
		
		physics.addBody( green, { density = 1.0, friction = 0, bounce = 1, radius = 40 } )	
		
		local red = display.newImage("red.png");
		red.x = mRand( 200 )
		red.y = 30
		red.isOrb = true;
		
		transition.to(red, {time=125, xScale = .1, yScale = .1})
		
		physics.addBody( red, { density = 1.0, friction = 0, bounce = 1, radius = 40 } )	

		
		function orb:touch(e)
			if(ready == true) then
				if(time_up ~= true) then
					if(e.phase == "ended") then
						--Play the popping sound
						audio.play(pop_sound);
						--Remove the orbs
						trackOrbs(self);
					end
				end
			end
		
			return true;
			
		end
		
		--Increment o for every orb created
		o = o+1;
		
		orb:addEventListener("touch", orb);
		
		--If all orbs created, start the game timer
		if(o == total_orbs) then
			gametmr = timer.performWithDelay(1000, countDown, 10);
			
		else
			ready = false;
		end
		
		localGroup:insert(orb)
		localGroup:insert(pink)
		localGroup:insert(orange)
		localGroup:insert(yellow)
		localGroup:insert(blue)
		localGroup:insert(green)
		
	end
	
	
	tmr = timer.performWithDelay(10, spawnOrb, total_orbs);
	tmr = timer.performWithDelay(10, spawnPink );

	function changeScene(e)
		if(e.phase == "ended") then
			
			-- .stop() takes an audio CHANNEL argument
			
			play_again.isVisible = false;
			play_again.alpha = 0;
			back_to_menu.isVisible = false;
			back_to_menu.alpha = 0;
			
			if(e.target.scene) then
				--Load main menu
				director:changeScene(e.target.scene);
			else
				--Load game again
				o = 0;
				time_remain = 10;
				time_up = false;
				total_orbs = 15;
				ready = false;
				
				--Clear the game timer
				gametmr = nil;
				
				--Clear the spawn timer
				tmr = nil;
				
				--Traversing the localGroup, looking for remaining orbs
				--If present, remove them
				for i = localGroup.numChildren, 1, -1 do
					if(localGroup[i].isOrb) then
						--Set its orb property to nil
						localGroup[i].isOrb = nil;
						--Remove it from the display
						localGroup[i]:removeSelf();
						localGroup[i] = nil;
					end
				end
	
				--Spawn orbs and start over
				tmr = timer.performWithDelay(10, spawnOrb, total_orbs);
			end
		end
	end

	play_again:addEventListener("touch", changeScene);
	back_to_menu:addEventListener("touch", changeScene);
	
	return localGroup;

end