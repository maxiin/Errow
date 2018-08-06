
local composer = require("composer")
local widget = require("widget")

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
local settings = {
    sound = true,
    music = true,
    swipe = true
}

--menu button listener
local function gotoMenu()
    composer.gotoScene("menu", {time = 800, effect = "crossFade"})
end

local function sound(event)
    local phase = event.phase
    if (phase == "ended") then
        if soundButton:getLabel() == "OFF" then
            soundButton:setLabel("ON")
            settings.sound = true;
        else
            soundButton:setLabel("OFF")
            settings.sound = false;
        end
        system.setPreferences("app", settings)
    end
end

local function music(event)
    local phase = event.phase
    if (phase == "ended") then
        if musicButton:getLabel() == "OFF" then
            musicButton:setLabel("ON")
            settings.music = true
        else
            musicButton:setLabel("OFF")
            settings.music = false
        end
        system.setPreferences("app", settings)
    end
end

local function controls(event)
    local phase = event.phase
    if (phase == "ended") then
        if controlsButton:getLabel() == "Swipe" then
            settings.swipe = true
            controlsButton:setLabel("Arrows")
        else
            settings.swipe = false
            controlsButton:setLabel("Swipe")
        end
        system.setPreferences("app", settings)
    end
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create(event)
    
    if (system.getPreference("app", "sound", "boolean") ~= nil) then
        settings.sound = system.getPreference("app", "sound", "boolean")
    end
    if(system.getPreference("app", "music", "boolean") ~= nil) then
        settings.music = system.getPreference("app", "music", "boolean")
    end
    if(system.getPreference("app", "swipe", "boolean") ~= nil) then
        settings.swipe = system.getPreference("app", "swipe", "boolean")
    end
    
    local sceneGroup = self.view
    
    -- Code here runs when the scene is first created but has not yet appeared on screen
    
    --loading the ui elements
    local scoreFont = native.newFont("Kenney Pixel.ttf", 50)
    -- backPanel = display.newImage(sceneGroup, "Sprites/panel_beige.png", display.contentCenterX, display.contentCenterY - 15)
    menuBackgroundPanel = display.newRect(sceneGroup, centerX, centerY, displayW/2, displayH/2)
    paint = {0.62, 0.62, 0.62}
    menuBackgroundPanel.alpha = 0.65
    menuBackgroundPanel.fill = paint
    soundLabel = display.newText(sceneGroup, "Sound: ", display.contentCenterX/1.5, display.contentCenterY - (display.contentCenterY / 3), scoreFont, 35)
    musicLabel = display.newText(sceneGroup, "Music: ", display.contentCenterX/1.5, display.contentCenterY, scoreFont, 35)
    controlLabel = display.newText(sceneGroup, "Control: ", display.contentCenterX/1.42, display.contentCenterY + (display.contentCenterY / 3), scoreFont, 35)

    --loading ui button
    soundButton = widget.newButton(
        {
            x = display.contentCenterX + (display.contentCenterX / 2.5),
            y = display.contentCenterY - (display.contentCenterY / 3),
            width = 50,
            height = 50,
            defaultFile = "Sprites/button.png",
            overFile = "Sprites/button_pressed.png",
            font = "Kenney Pixel.ttf",
            fontSize = 35,
            labelColor = {default = {0.49, 0.43, 0.27}, over = {0.63, 0.55, 0.36}},
            labelYOffset = -4,
            onEvent = sound
        })
        
        if(system.getPreference("app", "sound", "boolean")) then
            soundButton:setLabel("ON")
        else
            soundButton:setLabel("OFF")
        end
        
        musicButton = widget.newButton(
            {
                x = display.contentCenterX + (display.contentCenterX / 2.5),
                y = display.contentCenterY,
                width = 50,
                height = 50,
                defaultFile = "Sprites/button.png",
                overFile = "Sprites/button_pressed.png",
                label = "OFF",
                font = "Kenney Pixel.ttf",
                fontSize = 35,
                labelColor = {default = {0.49, 0.43, 0.27}, over = {0.63, 0.55, 0.36}},
                labelYOffset = -4,
                onEvent = music
            })
            
            if(system.getPreference("app", "music", "boolean")) then
                musicButton:setLabel("ON")
            else
                musicButton:setLabel("OFF")
            end
            
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
                    labelColor = {default = {0.49, 0.43, 0.27}, over = {0.63, 0.55, 0.36}},
                    labelYOffset = -4,
                    onEvent = controls
                })
                
                if(system.getPreference("app", "swipe", "boolean")) then
                    controlsButton:setLabel("Arrows")
                else
                    controlsButton:setLabel("Swipe")
                end
                
                menuButton = widget.newButton(
                    {
                        x = display.contentCenterX,
                        y = display.contentCenterY + 130,
                        width = 190,
                        height = 50,
                        defaultFile = "Sprites/button.png",
                        overFile = "Sprites/button_pressed.png",
                        label = "Menu",
                        font = "Kenney Pixel.ttf",
                        fontSize = 35,
                        labelColor = {default = {0.49, 0.43, 0.27}, over = {0.63, 0.55, 0.36}},
                        labelYOffset = -4,
                        onEvent = gotoMenu
                    })
                    sceneGroup:insert(menuButton)
                    sceneGroup:insert(controlsButton)
                    sceneGroup:insert(musicButton)
                    sceneGroup:insert(soundButton)
                    
                end
                
                -- show()
                function scene:show(event)
                    
                    local sceneGroup = self.view
                    local phase = event.phase
                    
                    if (phase == "will") then
                        -- Code here runs when the scene is still off screen (but is about to come on screen)
                        
                    elseif (phase == "did") then
                        -- Code here runs when the scene is entirely on screen
                        
                    end
                end
                
                -- hide()
                function scene:hide(event)
                    
                    local sceneGroup = self.view
                    local phase = event.phase
                    
                    if (phase == "will") then
                        -- Code here runs when the scene is on screen (but is about to go off screen)
                        
                    elseif (phase == "did") then
                        -- Code here runs immediately after the scene goes entirely off screen
                        -- audio.stop(1)
                        composer.removeScene("pause")
                        
                    end
                end
                
                -- destroy()
                function scene:destroy(event)
                    
                    local sceneGroup = self.view
                    -- Code here runs prior to the removal of scene's view
                    -- audio.dispose(bgmTrack)
                    
                end
                
                -- -----------------------------------------------------------------------------------
                -- Scene event function listeners
                -- -----------------------------------------------------------------------------------
                scene:addEventListener("create", scene)
                scene:addEventListener("show", scene)
                scene:addEventListener("hide", scene)
                scene:addEventListener("destroy", scene)
                -- -----------------------------------------------------------------------------------
                
                return scene
                