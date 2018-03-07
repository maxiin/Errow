local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- 
--	Header
--
-- -----------------------------------------------------------------------------------

---- GAMEHEADER ----

--loading spritesheets
local sheetFile = require( "sheet" )
--Loading physics and setting the gravity to 0
local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )
--hiding the status bar
display.setStatusBar(display.HiddenStatusBar)

--------------------

---- VARIABLES ----

--Groups
local backGroup
local itemGroup
local playerGroup
local uiGroup
--dimens
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local displayW = display.contentWidth
local displayH = display.contentHeight
local mapMarginY = centerY + 35
local playerMarginY = displayH - 80
local shieldMMarginY
--music var
local backgroundMusicChannel
--game specific vars
local dead = false
local onAnim = true
local score = 0
--maps object vars
local map
local mapClosed
local mapOpened
local doors
--player, shield and arrows - object vars
local playerM
local playerL
local playerR
local shieldM
local shieldL
local shieldR
local arrowTable = {}
--ui vars
local hudScore
local rRect
local lRect
local mRect
local triangle
local triangler
local trianglel

-------------------

---- CONTROL FUNCTIONS ----

local function alphaChanger (p1, p2, p3)
	--trasparency of the player and the shield
	playerM.alpha = p1
	playerL.alpha = p2
	playerR.alpha = p3
	shieldM.alpha = p1
	shieldL.alpha = p2
	shieldR.alpha = p3
end

local function swipeListener (event)
	--player will only move if is not on animation and its not dead
	if (onAnim == false and dead == false) then
		--when the user lift the finger after the swipe
		if ( event.phase == "ended" ) then
			if ( event.xStart < event.x and (event.x - event.xStart) > (event.yStart - event.y) ) then
				--left > right
				alphaChanger(0, 0, 1)
			elseif ( event.xStart > event.x and (event.xStart - event.x) > (event.yStart - event.y) ) then
				--right > left
				alphaChanger(0, 1, 0)
			else
				if(event.yStart - event.y > 0) then
					--up
					alphaChanger(1, 0, 0)
				end
			end
		end
	end
end

local function tapListener (event)
	--player will only move if is not on animation and its not dead
	if (onAnim == false and dead == false) then
		if (event.target.id == 1) then
			--right
			alphaChanger(0, 0, 1)
		elseif (event.target.id == 2) then
			--left
			alphaChanger(0, 1, 0)
		else
			--up
			alphaChanger(1, 0, 0)
		end
	end
end

---------------------------

---- GAME FUNCTIONS ----

local function endGame()
	--setting the game over score and going to the highscores page
	composer.setVariable( "finalScore", score )
    composer.gotoScene( "highscores", { time=800, effect="crossFade" } )
end

--function to create the "enemies"
local function CreateArrows()
	--displaying a new arrow, setting its size inserting on the enemies
	--on screen table and setting the right physics body
	local newArrow = display.newImage( itemGroup, "Sprites/arrow.png")
	newArrow:scale( 0.75, 0.75 )
	table.insert( arrowTable, newArrow )
	physics.addBody( newArrow, "kinematic" )
	newArrow.myName = "arrow"
	--randomizing where does the arrow come from (top, right, left)
	local whereFrom = math.random( 3 )
	--setting the top arrow
	if (whereFrom == 1) then
		newArrow.x = centerX
		newArrow.y = centerY - 125
		newArrow.rotation = 90
		newArrow:setLinearVelocity( 0, math.random( 20,60 ) )
		newArrow.isBullet = true
	--setting the left arrow
	elseif (whereFrom == 2) then
		newArrow.x = centerX - 220
		newArrow.y = playerMarginY
		newArrow:setLinearVelocity( math.random( 40,120 ), 0 )
		newArrow.isBullet = true
	--setting the right arrow
	else
		newArrow.x = centerX + 220
		newArrow.y = playerMarginY
		newArrow.rotation = 180
		newArrow:setLinearVelocity( math.random( 40,120 ) * -1, 0 )
		newArrow.isBullet = true
	end
end

--gameloop function will only run after the animation 
--will not run after player death
local function gameLoop()
	if(onAnim == false and dead == false) then
	CreateArrows()
	end
end

--setting the time for the loop
local function StartLoop()
	gameLoopTimer = timer.performWithDelay( 2000, gameLoop, 0 )
end

--start function, for changing the map and starting the game it self
local function Start()
	mapOpened.alpha = 0
	transition.to( mapOpened , {time = 400, alpha = 0} )
	transition.to( shieldM , {time = 200, alpha = 1} )
	transition.to( mapClosed, { time = 400, alpha = 1} )
	transition.to( doors, {time = 400, alpha = 1, onComplete = StartLoop} )
	onAnim = false
end

------------------------

---- ANIMATION ----

--player animation entering the room
local function InitialAnimation()
	onAnim = true
	playerM.y = displayH + playerM.contentHeight
	playerM.alpha = 1
	local backgroundMusic = audio.loadStream("Sounds/Main.ogg")
	audio.setVolume(0 , { channel=1 }) 
	backgroundMusicChannel = audio.play( backgroundMusic, { channel=1, loops=-1}  )
	--making player enter the room
	transition.to( playerM, { time = 2000, y = playerMarginY, onComplete = Start} )
	--fading-in the audio
	audio.fade( { channel=1, time=2000, volume=1 } )
end

-------------------

---- COLLISIONS ----

local function onCollision( event )
    if ( event.phase == "began" ) then
        local obj1 = event.object1
        local obj2 = event.object2
        --these arrow-shields ifs test if the shield protected the player from the arrow
        if (obj1.myName == "arrow" and obj2.myName == "shield" and obj2.alpha == 1) then
        	display.remove( obj1 )
        	score = score + 1
        	hudScore.text = "score: " .. score
        	for i = #arrowTable, 1, -1 do
                if ( arrowTable[i] == obj1) then
                    table.remove( arrowTable, i )
                    break
                end
            end
        elseif (obj1.myName == "shield" and obj2.myName == "arrow" and obj1.alpha == 1) then
        	display.remove( obj2 )
        	score = score + 1
        	hudScore.text = "score: " .. score
        	for i = #arrowTable, 1, -1 do
                if ( arrowTable[i] == obj1) then
                    table.remove( arrowTable, i )
                    break
                end
            end
        --and these arrow-player tell the game that an arrow has killed the player
        elseif (obj1.myName == "arrow" and obj2.myName == "player" and dead == false) then
        	alphaChanger(0,0,0)
        	dead = true
        	timer.performWithDelay( 1000, endGame )
        elseif (obj1.myName == "player" and obj2.myName == "arrow" and dead == false) then
        	alphaChanger(0,0,0)
        	dead = true
        	timer.performWithDelay( 1000, endGame )
        end
    end
end

--------------------

-- -----------------------------------------------------------------------------------
--
-- Scene event functions
--
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

	--pause physics for loading
	physics.pause()
	
	--setting groups
	backGroup = display.newGroup()
    sceneGroup:insert( backGroup )
    itemGroup = display.newGroup()
    sceneGroup:insert( itemGroup )
    playerGroup = display.newGroup()
    sceneGroup:insert( playerGroup )
    uiGroup = display.newGroup()
    sceneGroup:insert( uiGroup )

    --loading the background map and setting their layers
	map = display.newImage(backGroup, "Sprites/map.png", centerX, mapMarginY)
	mapClosed = display.newImage(backGroup, "Sprites/mapd.png", centerX, mapMarginY)
	mapOpened = display.newImage(backGroup, "Sprites/mapdo.png", centerX, mapMarginY)
	doors = display.newImage(backGroup, "Sprites/doors.png", centerX, mapMarginY)

	map.alpha = 1
	mapClosed.alpha = 0
	mapOpened.alpha = 1
	doors.alpha = 0

	----loading sheets
	--player
	local sheet = graphics.newImageSheet( "Sprites/sheet test.png", options )
	--centering player
	playerM = display.newImage(playerGroup, sheet, 1 , centerX, playerMarginY)
	playerL = display.newImage(playerGroup, sheet, 2 , centerX, playerMarginY)
	playerR = display.newImage(playerGroup, sheet, 3 , centerX, playerMarginY)
	--adding their bodies
	physics.addBody( playerM, { isSensor=true } )
	physics.addBody( playerL, { isSensor=true } )
	physics.addBody( playerR, { isSensor=true } )
	--setting colision names
	playerM.myName = "player"
	playerL.myName = "player"
	playerR.myName = "player"
	--making everything disappear to be loaded in the animation
	playerM.alpha = 0
	playerL.alpha = 0
	playerR.alpha = 0

	--shield
	local sheetShield = graphics.newImageSheet( "Sprites/shield.png", optionsShield )
	shieldMMarginY = playerM.y - playerM.contentHeight / 2
	--creating shield on the right place
	shieldM = display.newImage(itemGroup, sheetShield, 1 , centerX, shieldMMarginY)
	shieldL = display.newImage(itemGroup, sheetShield, 2 , centerX - 22, playerM.y)
	shieldR = display.newImage(itemGroup, sheetShield, 2 , centerX + 25, playerM.y)
	--adding their bodies
	physics.addBody( shieldM, {isSensor = true} )
	physics.addBody( shieldL, {isSensor = true} )
	physics.addBody( shieldR, {isSensor = true} )
	--setting colision names
	shieldM.myName = "shield"
	shieldL.myName = "shield"
	shieldR.myName = "shield"
	--making everything disappear to be loaded in the animation
	shieldM.alpha = 0
	shieldL.alpha = 0
	shieldR.alpha = 0

	--rectangle in the top
	local topRect = display.newRect(uiGroup, centerX, 0, displayW, 0)
	local paint = { 0.62, 0.62, 0.62 }
	topRect.alpha = 0.65
	topRect.fill = paint

	--Score hud element
	hudScore = display.newText(uiGroup, "score: " .. score, 0, 0, "Fonts/SourceCodePro-Regular.ttf")
	hudScore.x = hudScore.contentWidth
	hudScore.y = hudScore.contentHeight
	hudScore:setFillColor( 0, 0, 0 )
    --setting the rectangle the correct size
	topRect.height = hudScore.contentHeight * 2
	topRect.y = topRect.contentHeight/2

	----CONTROLS---------------------
	--setting the touch controlls
	rRect = display.newRect(uiGroup, centerX + 80, centerY, 50, 50)
	lRect = display.newRect(uiGroup, centerX - 80, centerY, 50, 50)
	mRect = display.newRect(uiGroup, centerX, centerY, 50, 50)
	local paddingRect = mRect.contentWidth

	rRect.x = displayW - rRect.contentWidth/2 - paddingRect
	rRect.y = displayH - rRect.contentHeight
	rRect.alpha = 0.1
	lRect.x = displayW - lRect.contentWidth * 2.5 - paddingRect
	lRect.y = displayH - lRect.contentHeight
	lRect.alpha = 0.1
	mRect.x = displayW - mRect.contentWidth * 1.5 - paddingRect
	mRect.y = displayH - mRect.contentHeight * 2
	mRect.alpha = 0.1
	rRect.id = 1
	lRect.id = 2
	mRect.id = 0

	local triangleShape = { 0,-15, 20,15, -20,15 }
	triangle = display.newPolygon(uiGroup, mRect.x, mRect.y, triangleShape )
	triangler = display.newPolygon(uiGroup, rRect.x, rRect.y, triangleShape )
	trianglel = display.newPolygon(uiGroup, lRect.x, lRect.y, triangleShape )

	triangler.rotation = 90
	trianglel.rotation = -90

	--adding the event listeners for all the controlls
	rRect:addEventListener( "tap", tapListener )
	lRect:addEventListener( "tap", tapListener )
	mRect:addEventListener( "tap", tapListener )

	Runtime:addEventListener( "touch", swipeListener )

end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		--starting the physics again
		physics.start()
		--starting the collisions
		Runtime:addEventListener( "collision", onCollision )
		--starting the animation
		InitialAnimation()

	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
		timer.cancel( gameLoopTimer )

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
		--removing the listeners
		Runtime:removeEventListener( "collision", onCollision )
		Runtime:removeEventListener( "touch", swipeListener )
		--pausing the physics and the music
        physics.pause()
        audio.pause( backgroundMusicChannel )
        --removing the scene
        composer.removeScene( "game" )

	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
