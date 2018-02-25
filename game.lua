
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local sheetFile = require( "sheet" )

----Loading physics and setting the gravity to 0
local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )

----hiding the notification bar
display.setStatusBar(display.HiddenStatusBar)

----Groups
local backGroup
local itemGroup
local playerGroup
local uiGroup

----getting the center of the screen
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local displayW = display.contentWidth
local displayH = display.contentHeight
local mapMarginY = centerY + 35
local playerMarginY = displayH - 80
local shieldMMarginY

local backgroundMusicChannel

local dead = false
local onAnim = true
local score = 0

local map
local mapClosed
local mapOpened
local doors

local playerM
local playerL
local playerR
local shieldM
local shieldL
local shieldR

local hudScore
local rRect
local lRect
local mRect
local triangle
local triangler
local trianglel

local arrowTable = {}

local function alphaChanger (p1, p2, p3)

	playerM.alpha = p1
	playerL.alpha = p2
	playerR.alpha = p3

	shieldM.alpha = p1
	shieldL.alpha = p2
	shieldR.alpha = p3

end

local function tapListener (event)

	if (onAnim == false and dead == false) then

		if (event.target.id == 1) then
		
			alphaChanger(0, 0, 1)
		
		elseif (event.target.id == 2) then
			
			alphaChanger(0, 1, 0)
		
		else
			
			alphaChanger(1, 0, 0)

		end

	end

	return true
end

---------------------------------

local StartLoop

local function CreateArrows()

	local newArrow = display.newImage( itemGroup, "Sprites/arrow.png")
	newArrow:scale( 0.75, 0.75 )
	table.insert( arrowTable, newArrow )
	physics.addBody( newArrow, "kinematic" )
	newArrow.myName = "arrow"

	local whereFrom = math.random( 3 )

	--m
	if (whereFrom == 1) then
		newArrow.x = centerX
		newArrow.y = centerY - 125
		newArrow.rotation = 90
		newArrow:setLinearVelocity( 0, math.random( 20,60 ) )
		newArrow.isBullet = true
	--l
	elseif (whereFrom == 2) then
		newArrow.x = centerX - 220
		newArrow.y = playerMarginY
		newArrow:setLinearVelocity( math.random( 40,120 ), 0 )
		newArrow.isBullet = true
	--r
	else
		newArrow.x = centerX + 220
		newArrow.y = playerMarginY
		newArrow.rotation = 180
		newArrow:setLinearVelocity( math.random( 40,120 ) * -1, 0 )
		newArrow.isBullet = true
	end

end

local function endGame()
	composer.setVariable( "finalScore", score )
    composer.gotoScene( "highscores", { time=800, effect="crossFade" } )
end

local function Start()

	mapOpened.alpha = 0

	transition.to( mapOpened , {time = 400, alpha = 0} )
	transition.to( shieldM , {time = 200, alpha = 1} )
	transition.to( mapClosed, { time = 400, alpha = 1} )
	transition.to( doors, {time = 400, alpha = 1, onComplete = StartLoop} )

	onAnim = false

end

local function Awake()

	onAnim = true

	playerM.y = displayH + playerM.contentHeight
	playerM.alpha = 1

	local backgroundMusic = audio.loadStream("Sounds/Main.ogg")
	audio.setVolume(0 , { channel=1 }) 
	backgroundMusicChannel = audio.play( backgroundMusic, { channel=1, loops=-1}  )

	transition.to( playerM, { time = 2000, y = playerMarginY, onComplete = Start} )

	audio.fade( { channel=1, time=2000, volume=1 } )

end

local function gameLoop()

	if(onAnim == false and dead == false) then
	CreateArrows()
	end

end

local function onCollision( event )
 
    if ( event.phase == "began" ) then
 
        local obj1 = event.object1
        local obj2 = event.object2

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

        elseif (obj1.myName == "arrow" and obj2.myName == "player") then

        	display.remove(obj2)
        	dead = true
        	timer.performWithDelay( 1000, endGame )

        elseif (obj1.myName == "player" and obj2.myName == "arrow") then
        	
        	display.remove(obj1)
        	dead = true
        	timer.performWithDelay( 1000, endGame )

        end

    end

end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

	physics.pause()
	
	backGroup = display.newGroup()
    sceneGroup:insert( backGroup )
    itemGroup = display.newGroup()
    sceneGroup:insert( itemGroup )
    playerGroup = display.newGroup()
    sceneGroup:insert( playerGroup )
    uiGroup = display.newGroup()
    sceneGroup:insert( uiGroup )

    ----loading the background map
	map = display.newImage(backGroup, "Sprites/map.png", centerX, mapMarginY)
	mapClosed = display.newImage(backGroup, "Sprites/mapd.png", centerX, mapMarginY)
	mapOpened = display.newImage(backGroup, "Sprites/mapdo.png", centerX, mapMarginY)
	doors = display.newImage(backGroup, "Sprites/doors.png", centerX, mapMarginY)

	map.alpha = 1
	mapClosed.alpha = 0
	mapOpened.alpha = 1
	doors.alpha = 0

	----loading sheet
	--player
	local sheet = graphics.newImageSheet( "Sprites/sheet test.png", options )

	playerM = display.newImage(playerGroup, sheet, 1 , centerX, playerMarginY)
	playerL = display.newImage(playerGroup, sheet, 2 , centerX, playerMarginY)
	playerR = display.newImage(playerGroup, sheet, 3 , centerX, playerMarginY)

	physics.addBody( playerM, { isSensor=true } )
	physics.addBody( playerL, { isSensor=true } )
	physics.addBody( playerR, { isSensor=true } )

	playerM.myName = "player"
	playerL.myName = "player"
	playerR.myName = "player"

	playerM.alpha = 0
	playerL.alpha = 0
	playerR.alpha = 0

	--shield
	local sheetShield = graphics.newImageSheet( "Sprites/shield.png", optionsShield )
	shieldMMarginY = playerM.y - playerM.contentHeight / 2

	shieldM = display.newImage(itemGroup, sheetShield, 1 , centerX, shieldMMarginY)
	shieldL = display.newImage(itemGroup, sheetShield, 2 , centerX - 22, playerM.y)
	shieldR = display.newImage(itemGroup, sheetShield, 2 , centerX + 25, playerM.y)

	physics.addBody( shieldM, {isSensor = true} )
	physics.addBody( shieldL, {isSensor = true} )
	physics.addBody( shieldR, {isSensor = true} )

	shieldM.alpha = 0
	shieldL.alpha = 0
	shieldR.alpha = 0

	shieldM.myName = "shield"
	shieldL.myName = "shield"
	shieldR.myName = "shield"

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

	rRect:addEventListener( "tap", tapListener )
	lRect:addEventListener( "tap", tapListener )
	mRect:addEventListener( "tap", tapListener )

end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		physics.start()

		gameLoopTimer = timer.performWithDelay( 2000, gameLoop, 0 )
		Runtime:addEventListener( "collision", onCollision )

		Awake()

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
		Runtime:removeEventListener( "collision", onCollision )
        physics.pause()
        audio.pause( backgroundMusicChannel )
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
