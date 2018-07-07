
local composer = require( "composer" )
local widget = require( "widget" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
  
local menuButton = nil
local controlsButton = nil
local musicButton = nil
local soundButton = nil
local gFunc = require("gameFunctions")

--menu button listener
local function gotoMenu()
    composer.gotoScene( "menu", { time=800, effect="crossFade" } )
end

local function sound(event)
    local phase = event.phase
    if ( phase == "ended" ) then
        if soundButton:getLabel() == "O" then
            soundButton:setLabel("X")
            -- audio.setVolume(0, {channel=2})
        else
            soundButton:setLabel("O")
            -- audio.setVolume(0.5, {channel=1})
        end
    end
end

local function music(event)
    local phase = event.phase
    if ( phase == "ended" ) then
        if musicButton:getLabel() == "O" then
            musicButton:setLabel("X")
            audio.setVolume(0, {channel=1})
        else
            musicButton:setLabel("O")
            audio.setVolume(0.5, {channel=1})
        end
    end
end

local function controls(event)
    local phase = event.phase
    if ( phase == "ended" ) then
        if controlsButton:getLabel() == "Swipe" then
            controlsButton:setLabel("Arrows")
            -- upArrow.alpha = 0.1
            -- leftArrow.alpha = 0.1
            -- rightArrow.alpha = 0.1
            rRect:addEventListener( "tap", gFunc.tapListener )
            lRect:addEventListener( "tap", gFunc.tapListener )
            mRect:addEventListener( "tap", gFunc.tapListener )
            Runtime:removeEventListener( "touch", swipeListener )
        else
            controlsButton:setLabel("Swipe")
            -- upArrow.alpha = 0
            -- leftArrow.alpha = 0
            -- rightArrow.alpha = 0
            rRect:removeEventListener( "tap", gFunc.tapListener )
            lRect:removeEventListener( "tap", gFunc.tapListener )
            mRect:removeEventListener( "tap", gFunc.tapListener )
            Runtime:addEventListener( "touch", swipeListener )
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

    --loading the ui elements
    local scoreFont = native.newFont("Kenney Pixel.ttf", 50)

    --loading ui button
    soundButton = widget.newButton(
        {
            x = display.contentCenterX + (display.contentCenterX / 2.5),
            y = display.contentCenterY - (display.contentCenterY / 3),
            width = 50,
            height = 50,
            defaultFile = "Sprites/button.png",
            overFile = "Sprites/button_pressed.png",
            label = "O",
            font = "Kenney Pixel.ttf",
            fontSize = 35,
            labelColor = { default = {0.49, 0.43, 0.27}, over = {0.63, 0.55, 0.36}},
            labelYOffset = -4,
            onEvent = sound
        }
    )
    musicButton = widget.newButton(
        {
            x = display.contentCenterX+ (display.contentCenterX / 2.5),
            y = display.contentCenterY,
            width = 50,
            height = 50,
            defaultFile = "Sprites/button.png",
            overFile = "Sprites/button_pressed.png",
            label = "O",
            font = "Kenney Pixel.ttf",
            fontSize = 35,
            labelColor = { default = {0.49, 0.43, 0.27}, over = {0.63, 0.55, 0.36}},
            labelYOffset = -4,
            onEvent = music
        }
    )
    controlsButton = widget.newButton(
        {
            x = display.contentCenterX + (display.contentCenterX / 3),
            y = display.contentCenterY + (display.contentCenterY / 3),
            width = 100,
            height = 50,
            defaultFile = "Sprites/button.png",
            overFile = "Sprites/button_pressed.png",
            label = "Swipe",
            font = "Kenney Pixel.ttf",
            fontSize = 35,
            labelColor = { default = {0.49, 0.43, 0.27}, over = {0.63, 0.55, 0.36}},
            labelYOffset = -4,
            onEvent = controls
        }
    )
    menuButton = widget.newButton(
        {
            x = display.contentCenterX,
            y = display.contentCenterY+130,
            width = 190,
            height = 50,
            defaultFile = "Sprites/button.png",
            overFile = "Sprites/button_pressed.png",
            label = "Menu",
            font = "Kenney Pixel.ttf",
            fontSize = 35,
            labelColor = { default = {0.49, 0.43, 0.27}, over = {0.63, 0.55, 0.36}},
            labelYOffset = -4,
            onEvent = gotoMenu
        }
    )
    sceneGroup:insert( menuButton )
    sceneGroup:insert( controlsButton )
    sceneGroup:insert( musicButton )
    sceneGroup:insert( soundButton )

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
        -- audio.stop(1)
        composer.removeScene( "pause" )


    end
end


-- destroy()
function scene:destroy( event )

    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
    -- audio.dispose(bgmTrack)

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
