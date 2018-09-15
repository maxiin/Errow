local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local unip
local unicluster

function showUnip() 

    transition.fadeIn( unip, {time = 1750, onComplete = timer.performWithDelay(2250, function() showCluster() end, 1), transition = easing.inOutSine} )

end

function showCluster()

    transition.fadeIn( unicluster, {time = 3500, onComplete =  
        timer.performWithDelay(2750, function() composer.gotoScene( "menu", { time=2750, effect="crossFade" } ) end , 1), transition = easing.inOutSine})
    
        timer.performWithDelay(2000, function() unip.alpha = 0 transition.fadeOut(unicluster, {time = 2500, transition = easing.inOutSine}) end , 1)

end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    
    unip = display.newImage(sceneGroup, "./Sprites/002n.png" , display.contentCenterX, display.contentCenterY );
    unip.alpha = 0
    unip.height = display.contentHeight
    unip.width = display.contentWidth
    unicluster = display.newImage(sceneGroup, "./Sprites/001n.png" , display.contentCenterX, display.contentCenterY);
    unicluster.alpha = 0
    unicluster.height = display.contentHeight
    unicluster.width = display.contentWidth

end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        showUnip()
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