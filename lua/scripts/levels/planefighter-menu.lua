local skyBackground
local backButton, playButton
local backClicked

local function onBackClicked(button, mouseButton)
    backClicked = true
    backButton:GetComponent(ComponentType.SpriteRenderer):SetSprite("assets/sprites/button_back2_65x64.png")
    Engine.Coroutine.YieldForSeconds(0.1)
    Level.LoadLevel("lua/scripts/levels/games.lua")
end

local function onPlayClicked(button, mouseButton)
    backClicked = true
    playButton:GetComponent(ComponentType.SpriteRenderer):SetSprite("assets/sprites/button_play2_147x64.png")
    Engine.Coroutine.YieldForSeconds(0.1)
    Level.LoadLevel("lua/scripts/levels/planefighter.lua")
end

local function onLeaderboardClicked(button, mouseButton)
    backClicked = true
    backButton:GetComponent(ComponentType.SpriteRenderer):SetSprite("assets/sprites/button_leaderboard2_147x64.png")
    Engine.Coroutine.YieldForSeconds(0.1)
    _G.leaderboard.gameName = "planefighter"
    Level.LoadLevel("lua/scripts/levels/leaderboard.lua")
end

function OnLoad()

    skyBackground = Actor.new("skyBackground1")

    do
        local spriteRenderer = skyBackground:AddComponent(ComponentType.SpriteRenderer)
        spriteRenderer:SetSprite("assets/sprites/mainmenu_sky1_960x460.png")
        spriteRenderer.priority = -10
        spriteRenderer.scale = Vector2.new(1.5,1.8)
    end

    backButton = Actor.new("backButton")
    backButton.transform.position = Vector2.new(-550, -320)

    do
        local spriteRenderer = backButton:AddComponent(ComponentType.SpriteRenderer)
        spriteRenderer:SetSprite("assets/sprites/button_back1_65x64.png")
        local button = backButton:AddComponent(ComponentType.Button)
        button.width, button.height = 65, 64
        button.OnClick:Bind(function(button, mouseButton)
            if mouseButton == 0 and not backClicked then
                Engine.Coroutine.new(onBackClicked)
            end
        end)
    end

    playButton = Actor.new("play")
    playButton.transform.position = Vector2.new(0, 0)

    do
        local spriteRenderer = playButton:AddComponent(ComponentType.SpriteRenderer)
        spriteRenderer:SetSprite("assets/sprites/button_play1_147x64.png")
        local button = playButton:AddComponent(ComponentType.Button)
        button.width, button.height = 147, 64
        button.OnClick:Bind(function(button, mouseButton)
            if mouseButton == 0 and not backClicked then
                Engine.Coroutine.new(onPlayClicked)
            end
        end)
    end
    -- this is actually the leaderboard button
    backButton = Actor.new("leaderboard")
    backButton.transform.position = Vector2.new(0, -100)

    do
        local spriteRenderer = backButton:AddComponent(ComponentType.SpriteRenderer)
        spriteRenderer:SetSprite("assets/sprites/button_leaderboard1_147x64.png")
        local button = backButton:AddComponent(ComponentType.Button)
        button.width, button.height = 147, 64
        button.OnClick:Bind(function(button, mouseButton)
            if mouseButton == 0 and not backClicked then
                Engine.Coroutine.new(onLeaderboardClicked)
            end
        end)
    end


end

function Update()

end

Level.OnLoad = OnLoad
Level.Update = Update