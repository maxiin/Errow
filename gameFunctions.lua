local gameFunctions = {};

function stopArrows()
	for i = #arrowTable, 1, -1 do
		arrowTable[i]:setLinearVelocity(0,0)
	end
end

function frameChanger (p1, p2, p3)
    --trasparency of the player and the shield
    --print(p1 .. p2 .. p3)
    if(p1 == 1)then
        playerObj:setFrame(1)
    elseif(p2 == 1)then
        playerObj:setFrame(5)
    elseif(p3 == 1)then
        playerObj:setFrame(6)
    else
		playerObj:setFrame(4)
		stopArrows()
	end
    shieldM.alpha = p1
    shieldL.alpha = p2
    shieldR.alpha = p3
end


function swipeListener (event)
	--player will only move if is not on animation and its not dead
	if (onAnim == false and dead == false) then
		--when the user lift the finger after the swipe
		if ( event.phase == "ended" ) then
			if ( event.xStart < event.x and (event.x - event.xStart) > (event.yStart - event.y) ) then
				--left > right
				frameChanger(0, 0, 1)
			elseif ( event.xStart > event.x and (event.xStart - event.x) > (event.yStart - event.y) ) then
				--right > left
				frameChanger(0, 1, 0)
			else
				if(event.yStart - event.y > 0) then
					--up
					frameChanger(1, 0, 0)
				end
			end
		end
	end
end

function tapListener (event)
	--player will only move if is not on animation and its not dead
	if (onAnim == false and dead == false) then
		if (event.target.id == 1) then
			--right
			frameChanger(0, 0, 1)
		elseif (event.target.id == 2) then
			--left
			frameChanger(0, 1, 0)
		else
			--up
			frameChanger(1, 0, 0)
		end
	end
end

function moveShield(objA, objS) 
	if (objA.myName == "arrowM") then
		--move shield down
		playerObj:setFrame(2)
		transition.to( objS, { time = 100, y = playerMarginY - 18, onComplete = function() transition.to( objS, { y = playerMarginY - 20}) playerObj:setFrame(1) end } )
	elseif (objA.myName == "arrowL") then
		--move left shield
		playerObj:setFrame(7)
		transition.to( objS, { time = 100, x = centerX - 20, onComplete = function() transition.to(objS, {x = centerX - 22}) playerObj:setFrame(5) end })
	else
		--move right shield
		--shieldR.x = centerX + 25
		playerObj:setFrame(8)
		transition.to( objS, { time = 100, x = centerX + 23, onComplete = function() transition.to(objS, {x = centerX + 25}) playerObj:setFrame(6) end })
	end
end

function onCollision( event )
	if ( event.phase == "began" ) then
        local obj1 = event.object1
        local obj2 = event.object2
		--these arrow-shields ifs test if the shield protected the player from the arrow
		--todo, change names to something simpler
        if ((obj1.myName == "arrowM" or obj1.myName == "arrowL" or obj1.myName == "arrowR") and obj2.myName == "shield" and obj2.alpha == 1) then
			moveShield(obj1, obj2)
			display.remove( obj1 )
        	score = score + 1
        	hudScore.text = "score: " .. score
        	for i = #arrowTable, 1, -1 do
                if ( arrowTable[i] == obj1) then
                    table.remove( arrowTable, i )
                    break
                end
            end
        elseif (obj1.myName == "shield" and (obj2.myName == "arrowM" or obj2.myName == "arrowL" or obj2.myName == "arrowR") and obj1.alpha == 1) then
			moveShield(obj2, obj1)
			display.remove( obj2 )
        	score = score + 1
        	hudScore.text = "score: " .. score
        	for i = #arrowTable, 1, -1 do
                if ( arrowTable[i] == obj2) then
                    table.remove( arrowTable, i )
                    break
                end
            end
        --and these arrow-player tell the game that an arrow has killed the player
        elseif ((obj1.myName == "arrowM" or obj1.myName == "arrowL" or obj1.myName == "arrowR") and obj2.myName == "player" and dead == false) then
        	frameChanger(0,0,0)
        	dead = true
        	endGame()
        elseif (obj1.myName == "player" and (obj2.myName == "arrowM" or obj2.myName == "arrowL" or obj2.myName == "arrowR") and dead == false) then
        	frameChanger(0,0,0)
        	dead = true
        	endGame()
        end
	end

	--todo, remove this from gameFunctions
	if(score >= 10 and level == 1) then
		--set to lvl 2, clear all arrows, make animations
		level = 2
		changeLevel()
	elseif(score >= 20 and level == 2) then
		--to lvl 3
		level = 3
		changeLevel()
	else
		--over
	end

end

--declaring functions publicly
gameFunctions.frameChanger = frameChanger
gameFunctions.swipeListener = swipeListener
gameFunctions.tapListener = tapListener
gameFunctions.onCollision = onCollision

return gameFunctions