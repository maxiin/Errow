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

gFunc.gameVarInit()

---------------------------

---- GAME FUNCTIONS ----


--gameloop function will only run after the animation 
--will not run after player death
--todo, change checks from on colision to here
function gameLoop()
	if(onAnim == false and dead == false) then
		CreateArrows()
	end
end

function endGame()
	--setting the game over score and going to the highscores page
	audio.stop(1)
  backgroundMusic = audio.loadStream("Sounds/Death.ogg")
  audio.play( backgroundMusic, { channel=1, loops=-1}  )
	timer.performWithDelay( 1000, composer.setVariable( "finalScore", score ))
	transition.to(playerObj, {time=800, alpha = 0})
  composer.gotoScene( "highscores", { time=800, effect="crossFade" } )
  
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
	abovePlayerGroup = display.newGroup()
	sceneGroup:insert(abovePlayerGroup)
  	uiGroup = display.newGroup()
  	sceneGroup:insert( uiGroup )

    --loading the background map and setting their layers
	map = display.newImage(backGroup, "Sprites/mapInf.png", centerX, mapMarginY)
	mapClosed = display.newImage(abovePlayerGroup, "Sprites/mapInfUp.png", centerX, mapMarginY)
	mapOpened = display.newImage(abovePlayerGroup, "Sprites/mapInfUp.png", centerX, mapMarginY)
	doors = display.newImage(backGroup, "Sprites/mapInfDoors.png", centerX, mapMarginY)

	map.alpha = 1
	mapClosed.alpha = 0
	mapOpened.alpha = 1
	doors.alpha = 1

	----loading sheets
	--player
	local playerSheet = graphics.newImageSheet( "Sprites/player sheet.png", optionsPlayer )
	playerObj = display.newSprite(playerSheet, playerAnimation)
	playerObj.x = display.contentCenterX
	playerObj.y = playerMarginY
	playerObj.alpha = 0
	physics.addBody( playerObj, { isSensor=true, shape=playerHitbox } )
	playerObj.myName = "player"
	playerGroup:insert(playerObj)
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
	currentMusic = "Sounds/City.ogg"

	createUI()
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
		gFunc.InitialAnimation()
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
		--todo, probably need to dispose of player
        --removing the scene
        composer.removeScene( "gameEndless" )

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