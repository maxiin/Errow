local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------


transition.fadeIn( target, params )
transition.fadeOut( target, params )
transition.fadeIn( target, params )
transition.fadeOut( target, params )

local function gotoMenu()
    composer.gotoScene("menu")
end

local function splash()
	transition.to( placeholderSplash, { time = 2, alpha = 1} )
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    local placeholderSplash = display.newText( sceneGroup, "This is a Splashscreen!", display.contentCenterX, display.contentCenterY,"Fonts/SourceCodePro-Regular.ttf", 40 )
    local placeholderSplash2 = display.newText( sceneGroup, "This is a second Splashscreen!", display.contentCenterX, display.contentCenterY,"Fonts/SourceCodePro-Regular.ttf", 40 )
    placeholderSplash.alpha=0
    placeholderSplash2.alpha=0
    local skipButton = display.newText(sceneGroup, "Skip", display.contentWidth, display.contentHeight, "Fonts/SourceCodePro-Regular.ttf", 20)
    skipButton.anchorX = 1
    skipButton.anchorY = 1
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        splash()
 
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