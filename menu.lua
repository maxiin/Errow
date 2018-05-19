local composer = require( "composer" )
local widget = require( "widget" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

--setting the goto for the others scenes
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

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

	--loading the background and the buttons
	local menuBackground = display.newImage( sceneGroup, "Sprites/titleBg.png", display.contentCenterX, display.contentCenterY )
	local gameTitle = display.newText(sceneGroup, "ERROW", display.contentCenterX, display.contentCenterY/2, "Fonts/Kenney BLocks.ttf", 80 )
	gameTitle:setFillColor({type="gradient", color1={ 0.32, 0.29, 0.22 }, color2={ 0.27, 0.25, 0.19, 0.7 }, direction="down"})

	scoresButton = widget.newButton(
		{
			x = display.contentCenterX,
			y = display.contentCenterY + 60,
			width = 190,
        	height = 50,
        	defaultFile = "Sprites/button.png",
        	overFile = "Sprites/button_pressed.png",
        	label = "Scores",
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
        	onEvent = gotoGame
		}
	)

	sceneGroup:insert( scoresButton )
	sceneGroup:insert( playButton )

end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen

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
