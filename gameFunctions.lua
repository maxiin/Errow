local gameFunctions = {};

function alphaChanger (p1, p2, p3)
    --trasparency of the player and the shield
    --print(p1 .. p2 .. p3)
    if(p1 == 1)then
        playerObj:setFrame(1)
    elseif(p2 == 1)then
        playerObj:setFrame(5)
    elseif(p3 == 1)then
        playerObj:setFrame(6)
    else
        playerObj:setFrame(4)
    end
    shieldM.alpha = p1
    shieldL.alpha = p2
    shieldR.alpha = p3
end
gameFunctions.alphaChanger = alphaChanger

return gameFunctions