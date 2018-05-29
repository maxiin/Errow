local composer = require( "composer" )
local widget = require( "widget" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

--setting the goto for the others scenes
local bgmMusic = "Sounds/Menu.ogg"

local function gotoGame(event)
	if event.phase == "ended" then
		composer.gotoScene( "game", { time=800, effect="crossFade" } )
	end
end
 
local function gotoHighScores(event)
	if event.phase == "ended" then
		composer.gotoScene( "highscores", { time=800, effect="crossFade" } )
	end
end

local function gotoSettings(event)
	if event.phase == "ended" then
		composer.gotoScene( "settings", { time=800, effect="crossFade" } )
	end
end

local function gotoEndless(event)
	if event.phase == "ended" then
		composer.gotoScene( "gameEndless", { time=800, effect="crossFade" } )
	end
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

	--loading the background and the buttons
	local menuBackground = display.newImage( sceneGroup, "Sprites/titleBg.png", display.contentCenterX, display.contentCenterY )
	local gameTitleBack = display.newText(sceneGroup, "ERROW", display.contentCenterX+2, display.contentCenterY/2+2, "Fonts/Kenney BLocks.ttf", 80 )
	gameTitleBack:setFillColor(0,0,0,0.2)
	local gameTitle = display.newText(sceneGroup, "ERROW", display.contentCenterX, display.contentCenterY/2, "Fonts/Kenney BLocks.ttf", 80 )
	gameTitle:setFillColor({type="gradient", color1={ 0.63, 0.55, 0.36 }, color2={ 0.49, 0.43, 0.27}, direction="up"})

	--todo: make these buttons imgs to fix the offset
	scoresButton = widget.newButton(
		{
			x = display.contentCenterX,
			y = display.contentCenterY + 120,
			width = 190,
        	height = 50,
        	defaultFile = "Sprites/button.png",
        	overFile = "Sprites/button_pressed.png",
			label = "Scores",
			font = "Fonts/Kenney Pixel.ttf",
			fontSize = 35,
			labelColor = { default = {0.49, 0.43, 0.27}, over = {0.63, 0.55, 0.36}},
			labelYOffset = -4,
        	onEvent = gotoHighScores
		}
	)

	playButton = widget.newButton(
		{
			x = display.contentCenterX,
			y = display.contentCenterY,
			width = 190,
        	height = 50,
        	defaultFile = "Sprites/button.png",
        	overFile = "Sprites/button_pressed.png",
			label = "Play!",
			font = "Fonts/Kenney Pixel.ttf",
			fontSize = 35,
			labelColor = { default = {0.49, 0.43, 0.27}, over = {0.63, 0.55, 0.36}},
			labelYOffset = -4,
        	onEvent = gotoGame
		}
	)

	endlessButton = widget.newButton(
		{
			x = display.contentCenterX,
			y = display.contentCenterY + 60,
			width = 190,
        	height = 50,
        	defaultFile = "Sprites/button.png",
        	overFile = "Sprites/button_pressed.png",
			label = "Endless Mode",
			font = "Fonts/Kenney Pixel.ttf",
			fontSize = 35,
			labelColor = { default = {0.49, 0.43, 0.27}, over = {0.63, 0.55, 0.36}},
			labelYOffset = -4,
        	onEvent = gotoEndless
		}
	)

	sceneGroup:insert( scoresButton )
	sceneGroup:insert( playButton )
	sceneGroup:insert( endlessButton )

end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		backgroundMusic = audio.loadStream(bgmMusic)
		bgmTrack = audio.play( backgroundMusic, { channel=1, loops=-1} )

	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen

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
