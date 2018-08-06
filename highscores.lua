
local composer = require("composer")
local json = require("json")
local widget = require("widget")

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local scoresTable = {}

local filePath = system.pathForFile("scores.json", system.DocumentsDirectory)

local function loadScores()
    
    --loading the file and decoding the contents
    local file = io.open(filePath, "r")
    
    if file then
        local contents = file:read("*a")
        io.close(file)
        scoresTable = json.decode(contents)
    end
    
    --if theres nothing on the index, set to 0
    if (scoresTable == nil or #scoresTable == 0) then
        scoresTable = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
    end
end

local function saveScores()
    
    --remove the score if greater than 10
    for i = #scoresTable, 11, -1 do
        table.remove(scoresTable, i)
    end
    
    --open file and save the scores
    local file = io.open(filePath, "w")
    
    if file then
        file:write(json.encode(scoresTable))
        io.close(file)
    end
    
end

--menu button listener
local function gotoMenu()
    composer.gotoScene("menu", {time = 800, effect = "crossFade"})
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create(event)
    
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    loadScores()
    
    --putting the game over score in the table
    table.insert(scoresTable, composer.getVariable("finalScore"))
    composer.setVariable("finalScore", 0)
    
    local function compare(a, b)
        return a > b
    end
    table.sort(scoresTable, compare)
    
    saveScores()
    
    --loading the ui elements
    local scoreFont = native.newFont("Kenney Pixel.ttf", 50)
    
    local menuBackground = display.newImage(sceneGroup, "Sprites/titleBg.png", display.contentCenterX, display.contentCenterY)
    
    local backPanel = display.newImage(sceneGroup, "Sprites/panel_beige.png", display.contentCenterX, display.contentCenterY - 15)
    
    local highScoresHeader = display.newText(sceneGroup, "High Scores", display.contentCenterX, display.contentCenterY / 2, "Kenney Pixel.ttf", 60)
    highScoresHeader:setFillColor(0.49, 0.43, 0.27)
    
    --displaying the scores
    for i = 1, 10 do
        if (i <= 5) then
            if (scoresTable[i]) then
                local yPos = 200 + (i * 56)
                
                local rankNum = display.newText(sceneGroup, i .. ")", display.contentCenterX - 100, yPos / 2, scoreFont)
                rankNum:setFillColor(0.49, 0.43, 0.27)
                rankNum.anchorX = 1
                
                local thisScore = display.newText(sceneGroup, scoresTable[i], display.contentCenterX - 60, yPos / 2, scoreFont)
                thisScore:setFillColor(0.63, 0.55, 0.36)
                thisScore.anchorX = 0
                
            end
        else
            if (scoresTable[i]) then
                
                local yPos = 200 + ((i - 5) * 56)
                
                local rankNum = display.newText(sceneGroup, i .. ")", display.contentCenterX + 60, yPos / 2, scoreFont)
                rankNum:setFillColor(0.49, 0.43, 0.27)
                rankNum.anchorX = 1
                
                local thisScore = display.newText(sceneGroup, scoresTable[i], display.contentCenterX + 100, yPos / 2, scoreFont)
                thisScore:setFillColor(0.63, 0.55, 0.36)
                thisScore.anchorX = 0
                
            end
        end
    end
    
    --loading ui button
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
        --local menuButton = display.newText( sceneGroup, "Menu", display.contentCenterX, display.contentCenterY + (display.contentCenterY / 2) + 50, scoreFont )
        --menuButton:setFillColor( 0.75, 0.78, 1 )
        --menuButton:addEventListener( "tap", gotoMenu )
        
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
            audio.stop(1)
            composer.removeScene("highscores")
            
        end
    end
    
    -- destroy()
    function scene:destroy(event)
        
        local sceneGroup = self.view
        -- Code here runs prior to the removal of scene's view
        audio.dispose(bgmTrack)
        
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

   