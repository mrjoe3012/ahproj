local title
local skyBackground
local wordsearch, breakout, planefighter
local wordsearchClicked, breakoutClicked, planefighterClicked = false, false, false

local function onWordsearchClick()
    wordsearchClicked = true
    wordsearch:GetComponent(ComponentType.SpriteRenderer):SetSprite("assets/sprites/button_wordsearch2_147x64.png")
    Engine.Coroutine.YieldForSeconds(0.1)
    wordsearch:GetComponent(ComponentType.SpriteRenderer):SetSprite("assets/sprites/button_wordsearch1_147x64.png")
    wordsearchClicked = false
    Level.LoadLevel("lua/scripts/levels/wordsearch-menu.lua")
end

local function onBreakoutClick()
    breakoutClicked = true
    breakout:GetComponent(ComponentType.SpriteRenderer):SetSprite("assets/sprites/button_breakout2_147x64.png")
    Engine.Coroutine.YieldForSeconds(0.1)
    breakout:GetComponent(ComponentType.SpriteRenderer):SetSprite("assets/sprites/button_breakout1_147x64.png")
    breakoutClicked = false
    Level.LoadLevel("lua/scripts/levels/breakout-menu.lua")
end

local function onPlaneFighterClick()
    planefighterClicked = true
    planefighter:GetComponent(ComponentType.SpriteRenderer):SetSprite("assets/sprites/button_planefighter2_147x64.png")
    Engine.Coroutine.YieldForSeconds(0.1)
    planefighter:GetComponent(ComponentType.SpriteRenderer):SetSprite("assets/sprites/button_planefighter1_147x64.png")
    planefighterClicked = false
    Level.LoadLevel("lua/scripts/levels/planefighter-menu.lua")
end

function OnLoad()

    title = Actor.new("title")
    title.transform.position = Vector2.new(0,300)

    do
        local spriteRenderer = title:AddComponent(ComponentType.SpriteRenderer)
        spriteRenderer:SetSprite("assets/sprites/text_games1_300x200.png")
    end

    skyBackground = Actor.new("skyBackground1")

    do
        local spriteRenderer = skyBackground:AddComponent(ComponentType.SpriteRenderer)
        spriteRenderer:SetSprite("assets/sprites/mainmenu_sky1_960x460.png")
        spriteRenderer.priority = -10
        spriteRenderer.scale = Vector2.new(1.5,1.8)
    end

    wordsearch = Actor.new("wordsearch")
    wordsearch.transform.position = Vector2.new()

    do
        local spriteRenderer = wordsearch:AddComponent(ComponentType.SpriteRenderer)
        spriteRenderer:SetSprite("assets/sprites/button_wordsearch1_147x64.png")
        local button = wordsearch:AddComponent(ComponentType.Button)
        button.width = 147
        button.height = 64
        button.OnClick:Bind(function(button, mouseButton)
            if mouseButton == 0 and not wordsearchClicked then
                Engine.Coroutine.new(onWordsearchClick)
            end
        end)
    end

    breakout = Actor.new("breakout")
    breakout.transform.position = Vector2.new(200)

    do
        local spriteRenderer = breakout:AddComponent(ComponentType.SpriteRenderer)
        spriteRenderer:SetSprite("assets/sprites/button_breakout1_147x64.png")
        local button = breakout:AddComponent(ComponentType.Button)
        button.width = 147
        button.height = 64
        button.OnClick:Bind(function(button, mouseButton)
            if mouseButton == 0 and not breakoutClicked then
                Engine.Coroutine.new(onBreakoutClick)
            end
        end)
    end

    planefighter = Actor.new("planefighter")
    planefighter.transform.position = Vector2.new(-200)

    do
        local spriteRenderer = planefighter:AddComponent(ComponentType.SpriteRenderer)
        spriteRenderer:SetSprite("assets/sprites/button_planefighter1_147x64.png")
        local button = planefighter:AddComponent(ComponentType.Button)
        button.width = 147
        button.height = 64
        button.OnClick:Bind(function(button, mouseButton)
            if mouseButton == 0 and not planefighterClicked then
                Engine.Coroutine.new(onPlaneFighterClick)
            end
        end)
    end

end

function Update()

end

Level.OnLoad = OnLoad
Level.Update = Update