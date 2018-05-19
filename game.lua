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
local gFunc = require("gameFunctions")
--Loading physics and setting the gravity to 0
local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )
--physics.setDrawMode( "hybrid" ) --Uncomment this line to show hitboxes
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
local shieldMHitbox = { 8,-8, 0,0, -8,-8}
local shieldLHitbox = { -8,8, 0,0, -8,-8 }
local shieldRHitbox = { 0,0, 6,6, 6,-6, 0,0 }
local playerHitbox = { -16,16, 16,16, 16,-16, -16,-16 }
local arrowHitbox = { -15,6, 10,3, 10,-3, -15,-6 }
--music var
--todo, add lvl 2,3 tracks
local bgmTrack
local lvl1Track = "Sounds/Main.ogg"
local lvl2Track = "Sounds/Main.ogg"
local lvl3Track = "Sounds/Main.ogg"
local currentMusic
--game specific vars
local gameLoopTimer
dead = false
onAnim = true
score = 0
level = 1
local levelTimeMultiplier = 12
local levelStarterTime = 1000 -- to 700
local levelStarterVelocity = 50 -- to 75
--maps object vars
local map
local mapClosed
local mapOpened
local doors
--player, shield and arrows - object vars
--todo, set player in a unique object to change sprites, not alphas
playerObj = nil

-- playerM = nil
-- playerL = nil
-- playerR = nil
shieldM = nil
shieldL = nil
shieldR = nil
arrowTable = {}
--ui vars
hudScore = nil
local rRect
local lRect
local mRect
local triangle
local triangler
local trianglel

-------------------

---- CONTROL FUNCTIONS ----

local function keyListener (event)
	--player will only move if is not on animation and its not dead
	if (onAnim == false and dead == false) then
		if (event.keyName == "right") then
			--right
			gFunc.frameChanger(0, 0, 1)
		elseif (event.keyName == "left") then
			--left
			gFunc.frameChanger(0, 1, 0)
		elseif (event.keyName == "up") then
			--up
			gFunc.frameChanger(1, 0, 0)
		end
	end
end

---------------------------

---- GAME FUNCTIONS ----

local function changeLevelComplete()
	rRect:addEventListener( "tap", gFunc.tapListener )
	lRect:addEventListener( "tap", gFunc.tapListener )
	mRect:addEventListener( "tap", gFunc.tapListener )

	Runtime:addEventListener( "touch", gFunc.swipeListener )

	if(level == 2) then
		map = display.newImage(backGroup, "Sprites/map2.png", centerX, mapMarginY)
		mapClosed = display.newImage(backGroup, "Sprites/map2d.png", centerX, mapMarginY)
		mapOpened = display.newImage(backGroup, "Sprites/map2do.png", centerX, mapMarginY)
		doors = display.newImage(backGroup, "Sprites/doors.png", centerX, mapMarginY)
		--todo, make these variables
		currentMusic = lvl2Track
	else
		--todo: make the lvl 3 map
		map = display.newImage(backGroup, "Sprites/map.png", centerX, mapMarginY)
		mapClosed = display.newImage(backGroup, "Sprites/mapd.png", centerX, mapMarginY)
		mapOpened = display.newImage(backGroup, "Sprites/mapdo.png", centerX, mapMarginY)
		doors = display.newImage(backGroup, "Sprites/doors.png", centerX, mapMarginY)
		currentMusic = lvl3Track
	end
	InitialAnimation()
end

local function changeLevelAnimation()
	--todo, change playerR position later
	--todo change for playerobj
	playerObj:pause()
	playerObj:setSequence("walkingRight")
	playerObj:play()
	transition.to( playerObj, { time = 3500, x = (display.contentWidth + 20), onComplete = function() playerObj:pause() end} )
	-- transition.to( playerR, { delay=3250 , alpha = 1})
	-- transition.to( playerM, { delay=3500 , alpha = 0})
	transition.to( mapOpened, { delay = 3500, time = 2000, alpha = 0} )
	transition.to( map, { delay = 3500, time = 2000, alpha = 0} )
	--todo, working now, but needs tweaking in-game
	timer.performWithDelay(5500, function() changeLevelComplete() end, 1)
	--fadeout score and controlls
end

function changeLevel()
	--arrows stop and existing disappear
		--erase all arrows #IMPORTANT
		for i = #arrowTable, 1, -1 do
			display.remove( arrowTable[i] )
			table.remove( arrowTable, i )
		end
		--stop physics
		physics.pause()
		--stop arrow spawn
		timer.cancel(gameLoopTimer)
		--unable event listeners
		rRect:removeEventListener( "tap", gFunc.tapListener )
		lRect:removeEventListener( "tap", gFunc.tapListener )
		mRect:removeEventListener( "tap", gFunc.tapListener )

		Runtime:removeEventListener( "touch", gFunc.swipeListener )
	--map open its doors
	transition.to( mapOpened , {time = 400, alpha = 1} )
	transition.to( mapClosed, { time = 400, alpha = 0} )
	transition.to( doors, {time = 400, alpha = 0} )
	--player walks to the middle
	transition.to( shieldL, { time = 400 , alpha = 0})
	transition.to( shieldR, { time = 400 , alpha = 0})
	transition.to( shieldM, { time = 400 , alpha = 0})
	--player enters to the right or left and disapears
	--todo, make random here
	playerObj:setSequence("walking")
	playerObj:play()
	timer.performWithDelay(500, (transition.to( playerObj, {delay = 1000, time = 2000, y = (centerY + 15), onComplete = function() changeLevelAnimation() end})) , 1)
	--music fades out
	audio.fade( { channel=1, time=500, volume=0 } )
	--change arrow velocity 
	--change spawn rate
	score = 0
	if(level == 2) then
		levelTimeMultiplier = 8
		levelStarterTime = 900 -- to 600
		levelStarterVelocity = 75 -- to 100
	elseif(level == 3) then
		levelTimeMultiplier = 6
		levelStarterTime = 700 -- to 400
		levelStarterVelocity = 100 -- to 150
	else
		levelTimeMultiplier = 1.1
		--todo add no-velocity multiplier
	end

end

function endGame()
	--setting the game over score and going to the highscores page
	composer.setVariable( "finalScore", score )
	transition.to(playerObj, {time=800, alpha = 0})
    composer.gotoScene( "highscores", { time=800, effect="crossFade" } )
end

--function to create the "enemies"
local function CreateArrows()
	--displaying a new arrow, setting its size inserting on the enemies
	--on screen table and setting the right physics body
	gameLoopTimer._delay = levelStarterTime - levelTimeMultiplier * score
	local newArrow = display.newImage( itemGroup, "Sprites/arrow.png")
	newArrow:scale( 0.75, 0.75 )
	table.insert( arrowTable, newArrow )
	physics.addBody( newArrow, "kinematic", {shape=arrowHitbox} )
	newArrow.isBullet = true
	--randomizing where does the arrow come from (top, right, left)
	local whereFrom = math.random( 3 )
	--setting the top arrow
	if (whereFrom == 1) then
		newArrow.myName = "arrowM"
		newArrow.x = centerX
		newArrow.y = centerY - 125
		newArrow.rotation = 90
		newArrow:setLinearVelocity( 0, levelStarterVelocity + score)
	--setting the left arrow
	elseif (whereFrom == 2) then
		newArrow.myName = "arrowL"
		newArrow.x = centerX - 220
		newArrow.y = playerMarginY
		newArrow:setLinearVelocity( levelStarterVelocity + score, 0 )
	--setting the right arrow
	else
		newArrow.myName = "arrowR"
		newArrow.x = centerX + 220
		newArrow.y = playerMarginY
		newArrow.rotation = 180
		newArrow:setLinearVelocity( -(levelStarterVelocity + score), 0 )
	end
end

--gameloop function will only run after the animation 
--will not run after player death
--todo, change checks from on colision to here
local function gameLoop()
	if(onAnim == false and dead == false) then
		CreateArrows()
	end
end

--setting the time for the loop
local function StartLoop()
	gameLoopTimer = timer.performWithDelay( levelStarterTime, function() gameLoop() end, -1 )
end

--start function, for changing the map and starting the game it self
local function Start()
	mapOpened.alpha = 0
	transition.to( mapOpened , {time = 400, alpha = 0} )
	transition.to( shieldM , {time = 200, alpha = 1} )
	transition.to( mapClosed, { time = 400, alpha = 1} )
	transition.to( doors, {time = 400, alpha = 1} )
	timer.performWithDelay(400, function() StartLoop() end, 1)
	onAnim = false
	playerObj:pause()
	playerObj:setSequence("all")
end

------------------------

---- ANIMATION ----

--player animation entering the room
function InitialAnimation()
	onAnim = true
	playerObj.x = centerX
	playerObj.y = displayH + playerObj.contentHeight
	playerObj.alpha = 1
	local backgroundMusic = audio.loadStream(currentMusic)
	audio.setVolume(0 , { channel=1 })
	bgmTrack = audio.play( backgroundMusic, { channel=1, loops=-1}  )
	--making player enter the room
	transition.to( playerObj, { time = 2000, y = playerMarginY} )
	timer.performWithDelay(2000, function() Start() end, 1)
	--fading-in the audio
	audio.fade( { channel=1, time=2000, volume=1 } )
	physics.start()
	playerObj:setSequence("walking")
	playerObj:play()
end

-------------------

---- COLLISIONS ----


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
	local playerSheet = graphics.newImageSheet( "Sprites/player sheet.png", optionsPlayer )
	playerObj = display.newSprite(playerSheet, playerAnimation)
	playerObj.x = display.contentCenterX
	playerObj.y = playerMarginY
	playerObj.alpha = 0
	physics.addBody( playerObj, { isSensor=true, shape=playerHitbox } )
	playerObj.myName = "player"

	--centering player
	--playerM = display.newImage(playerGroup, sheet, 1 , centerX, playerMarginY)

	-- playerM = display.newSprite(playerSheet, playerAnimation)
	-- playerM.x = centerX
	-- playerM.y = playerMarginY
	-- --playerM:setSequence(playerAnimation)
	-- playerL = display.newImage(playerGroup, playerSheet, 5 , centerX, playerMarginY)
	-- playerR = display.newImage(playerGroup, playerSheet, 6 , centerX, playerMarginY)
	-- --adding their bodies
	-- physics.addBody( playerM, { isSensor=true, shape=playerHitbox } )
	-- physics.addBody( playerL, { isSensor=true, shape=playerHitbox } )
	-- physics.addBody( playerR, { isSensor=true, shape=playerHitbox } )
	-- --setting colision names
	-- playerM.myName = "player"
	-- playerL.myName = "player"
	-- playerR.myName = "player"
	-- --making everything disappear to be loaded in the animation
	-- playerM.alpha = 0
	-- playerL.alpha = 0
	-- playerR.alpha = 0

	--shield
	local sheetShield = graphics.newImageSheet( "Sprites/shield.png", optionsShield )
	shieldMMarginY = playerObj.y - playerObj.contentHeight / 2
	--creating shield on the right place
	shieldM = display.newImage(itemGroup, sheetShield, 1 , centerX, shieldMMarginY)
	shieldL = display.newImage(itemGroup, sheetShield, 2 , centerX - 22, playerObj.y)
	shieldR = display.newImage(itemGroup, sheetShield, 2 , centerX + 25, playerObj.y)
	--adding their bodies
	physics.addBody( shieldM, {isSensor = true, shape=shieldMHitbox} )
	physics.addBody( shieldL, {isSensor = true, shape=shieldLHitbox} )
	physics.addBody( shieldR, {isSensor = true, shape=shieldRHitbox} )
	--setting colision names
	shieldM.myName = "shield"
	shieldL.myName = "shield"
	shieldR.myName = "shield"
	--making everything disappear to be loaded in the animation
	shieldM.alpha = 0
	shieldL.alpha = 0
	shieldR.alpha = 0

	--music set
	currentMusic = lvl1Track

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
	rRect:addEventListener( "tap", gFunc.tapListener )
	lRect:addEventListener( "tap", gFunc.tapListener )
	mRect:addEventListener( "tap", gFunc.tapListener )

	Runtime:addEventListener( "touch", gFunc.swipeListener )
	--Runtime:addEventListener("key", keyListener)

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
		Runtime:addEventListener( "collision", gFunc.onCollision )
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
		if(gameLoopTimer ~= nil) then
			timer.cancel( gameLoopTimer )
		end

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
		--removing the listeners
		Runtime:removeEventListener( "collision", gFunc.onCollision )
		Runtime:removeEventListener( "touch", gFunc.swipeListener )
		--pausing the physics and the music
        physics.pause()
		audio.stop(1)
		--todo, probably need to dispose of player
        --removing the scene
        composer.removeScene( "game" )

	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
	  audio.dispose(bgmTrack)
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
