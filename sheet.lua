optionsShield =
{
    frames =
    {
        {   -- top
            x = 0,
            y = 0,
            width = 24,
            height = 25
        },
        {   -- sides
            x = 50,
            y = 0,
            width = 24,
            height = 25
        }
    }
}

optionsPlayer =
{
    frames =
    {
        {   --player up 1 [1]
            x = 0,
            y = 0,
            width = 40,
            height = 38,
        },
        {   --player up 2 [2]
            x = 0,
            y = 41,
            width = 40,
            height = 39
        },
        {   --player up 3 [3]
            x = 0,
            y = 82,
            width = 40,
            height = 39
        },
        {   --player dead [4]
            x = 0,
            y = 123,
            width = 40,
            height = 40
        },
        {   --player left 1 [5]
            x = 41,
            y = 0,
            width = 40,
            height = 40
        },
        {   --player right 1 [6]
            x = 41,
            y = 41,
            width = 40,
            height = 40
        },
        {   --player left 2 [7]
            x = 41,
            y = 82,
            width = 40,
            height = 40
        },
        {   --player right 2 [8]
            x = 41,
            y = 123,
            width = 40,
            height = 40
        }
    }
}

playerAnimation = {
    {
        name = "walking",
        frames = { 1,2,1,3 },
        time = 1000,
        loopCount = 0,
        loopDirection = "forward"
    },
    {
         name = "walkingRight",
        frames = { 6, 8 },
        time = 1000,
        loopCount = 0,
        loopDirection = "forward"
    },
    {
        name = "all",
        frames = { 1,2,3,4,5,6,7,8 },
        time = 1,
        loopCount = 1,
        loopDirection = "forward"
    }
}

options =
{
    frames =
    {
        {   -- player 1
            x = 45,
            y = 50,
            width = 40,
            height = 40
        },
        {   -- player 2
            x = 90,
            y = 55,
            width = 40,
            height = 40
        },
        {   -- player 3
            x = 135,
            y = 55,
            width = 40,
            height = 40
        }
    }
}