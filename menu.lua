
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

--setting the goto for the others scenes
local function gotoGame()
    composer.gotoScene( "game", { time=800, effect="crossFade" } )
end
 
local function gotoHighScores()
    composer.gotoScene( "highscores", { time=800, effect="crossFade" } )
end

local function gotoSettings()
	composer.gotoScene( "settings", { time=800, effect="crossFade" } )
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

	local highScoresButton = display.newText( sceneGroup, "High Scores", display.contentCenterX, display.contentCenterY , "Fonts/SourceCodePro-Regular.ttf", 44 )
    highScoresButton:setFillColor( 0.75, 0.78, 1 )

	local playButton = display.newText( sceneGroup, "Play", display.contentCenterX, highScoresButton.y - highScoresButton.contentHeight, "Fonts/SourceCodePro-Regular.ttf", 44 )
    playButton:setFillColor( 0.82, 0.86, 1 )

    --setting the listeners
    playButton:addEventListener( "tap", gotoGame )
    highScoresButton:addEventListener( "tap", gotoHighScores )

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
