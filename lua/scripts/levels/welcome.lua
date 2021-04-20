local title, signup, login
local skyBackground

local buttonClicked = false

local BUTTON_PRESS_DELAY = 0.2

local function signupClickCoroutine()
    signup:GetComponent(ComponentType.SpriteRenderer):SetSprite("assets/sprites/button_signup2_147x64.png")
    Engine.Coroutine.YieldForSeconds(BUTTON_PRESS_DELAY)
    Level.LoadLevel("lua/scripts/levels/signup.lua")
end

local function loginClickCoroutine()
    login:GetComponent(ComponentType.SpriteRenderer):SetSprite("assets/sprites/button_login2_147x64.png")
    Engine.Coroutine.YieldForSeconds(BUTTON_PRESS_DELAY)
    Level.LoadLevel("lua/scripts/levels/login.lua")
end

function OnLoad()

    _G.leaderboard = {}

    title = Actor.new("title")
    title.transform.position = Vector2.new(-100, 280)

    do
        local textRenderer = title:AddComponent(ComponentType.TextRenderer)
        textRenderer.text = "Welcome"
    end

    signup = Actor.new("signup")
    signup.transform.position = Vector2.new(-130, 30)

    do
        local spriteRenderer = signup:AddComponent(ComponentType.SpriteRenderer)
        spriteRenderer:SetSprite("assets/sprites/button_signup1_147x64.png")
        local button = signup:AddComponent(ComponentType.Button)
        button.width = 147
        button.height = 64
        button.OnClick:Bind(function(button, mb)
            if mb == 0 and not buttonClicked then
                buttonClicked = true
                Engine.Coroutine.new(signupClickCoroutine)
            end
        end)
    end

    login = Actor.new("login")
    login.transform.position = Vector2.new(130, 30)

    do
        local spriteRenderer = login:AddComponent(ComponentType.SpriteRenderer)
        spriteRenderer:SetSprite("assets/sprites/button_login1_147x64.png")
        local button = login:AddComponent(ComponentType.Button)
        button.width = 146
        button.height = 64
        button.OnClick:Bind(function(button, mb)
            if mb == 0 and not buttonClicked then
                buttonClicked = true
                Engine.Coroutine.new(loginClickCoroutine)
            end
        end)
    end

    skyBackground = Actor.new("skyBackground1")

    do
        local spriteRenderer = skyBackground:AddComponent(ComponentType.SpriteRenderer)
        spriteRenderer:SetSprite("assets/sprites/mainmenu_sky1_960x460.png")
        spriteRenderer.priority = -10
        spriteRenderer.scale = Vector2.new(1.5,1.8)
    end

end

Level.OnLoad = OnLoad
