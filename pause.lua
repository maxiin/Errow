
local composer = require( "composer" )
local widget = require( "widget" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
  
local menuButton = nil
local controllsButton = nil
local musicButton = nil
local soundButton = nil

--menu button listener
local function gotoMenu()
    composer.gotoScene( "menu", { time=800, effect="crossFade" } )
end

local function sound(event)
    local phase = event.phase
    if ( phase == "ended" ) then
        if soundButton:getLabel() == "O" then
            soundButton:setLabel("X")
        else
            soundButton:setLabel("O")
        end
    end
end

local function music(event)
    local phase = event.phase
    if ( phase == "ended" ) then
        if musicButton:getLabel() == "O" then
            musicButton:setLabel("X")
        else
            musicButton:setLabel("O")
        end
    end
end

local function controlls(event)
    local phase = event.phase
    if ( phase == "ended" ) then
        if controllsButton:getLabel() == "Swipe" then
            controllsButton:setLabel("Arrows")
        else
            controllsButton:setLabel("Swipe")
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
    controllsButton = widget.newButton(
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
            onEvent = controlls
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
    sceneGroup:insert( controllsButton )
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
