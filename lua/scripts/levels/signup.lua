local InputField = require("lua/scripts/InputField")
local Database = require("lua/corelibs/Database")
local config = require("lua/scripts/game-config")

local skyBackground
local title
local usernameField, usernameBackground
local passwordField, passwordBackground
local errorText, errorTextActor
local submitButton, submitClicked = nil, false
local backButton, backClicked = nil, false

local function register(username, password)
    Database.Connect(config.DB_NAME, config.SERVER_NAME, config.DB_USR, config.DB_PASS)

    local results = Database.Query(string.format("SELECT username FROM accounts WHERE username='%s'", username))
    if #results == 0 then
        Database.Query(string.format("INSERT INTO accounts(username, password) VALUES('%s','%s')", username, password))
        Database.Query(string.format("INSERT INTO scores(username, brickscore, planescore, wordscore) VALUES('%s',0,0,0)", username))
        _G.session = {username=username, planescore=0, birckscore=0, wordscore=0}
        return true
    else
        errorText.text = string.format("Username '%s' is already in use.", username)
        return false
    end
end

local function onSubmitClick(button, mouseButton)
    submitClicked = true
    submitButton:GetComponent(ComponentType.SpriteRenderer):SetSprite("assets/sprites/button_submit2_147x64.png")
    Engine.Coroutine.YieldForSeconds(0.1)
    submitButton:GetComponent(ComponentType.SpriteRenderer):SetSprite("assets/sprites/button_submit1_147x64.png")
    local username, password = usernameField.textRenderer.text, passwordField.textRenderer.text
    if #username == 0 then
        errorText.text = "Username cannot be empty."
    elseif #password == 0 then
        errorText.text = "Password cannot be empty."
    elseif #password < 8 then
        errorText.text = "Password must be longer than 8 characters."
    else
        if register(username, password) then
            Level.LoadLevel("lua/scripts/levels/games.lua")
        end
    end
    submitClicked = false
end

local function onBackClicked(button, mouseButton)
    backClicked = true
    backButton:GetComponent(ComponentType.SpriteRenderer):SetSprite("assets/sprites/button_back2_65x64.png")
    Engine.Coroutine.YieldForSeconds(0.1)
    Level.LoadLevel("lua/scripts/levels/welcome.lua")
end

function OnLoad()
    InputField.OnLoad()

    skyBackground = Actor.new("skyBackground1")

    do
        local spriteRenderer = skyBackground:AddComponent(ComponentType.SpriteRenderer)
        spriteRenderer:SetSprite("assets/sprites/mainmenu_sky1_960x460.png")
        spriteRenderer.priority = -10
        spriteRenderer.scale = Vector2.new(1.5,1.8)
    end

    usernameField = InputField.new("usernameField")
    usernameField.actor.transform.position = Vector2.new(-145, 20)
    usernameField.textRenderer.fontSize = 30
    usernameField.textRenderer.text = "Username"
    usernameField.limit = 17
    usernameField.firstSelect = true
    usernameBackground = Actor.new("usernameBackground")

    do
        local spriteRenderer = usernameBackground:AddComponent(ComponentType.SpriteRenderer)
        spriteRenderer:SetSprite("assets/sprites/inputfield1_300x50.png")
        spriteRenderer.priority = -1
        local button = usernameBackground:AddComponent(ComponentType.Button)
        button.width = 300
        button.height = 50
        button.OnClick:Bind(function(button, mouseButton)
            if mouseButton == 0 and usernameField.firstSelect then usernameField.firstSelect = false usernameField.textRenderer.text = "" end
            usernameField.OnClick(button, mouseButton)
        end)
    end

    passwordField = InputField.new("passwordField")
    passwordField.actor.transform.position = Vector2.new(-145, -55)
    passwordField.textRenderer.fontSize = 30
    passwordField.textRenderer.text = "Password"
    passwordField.limit = 17
    passwordField.firstSelect = true
    passwordBackground = Actor.new("passwordBackground")
    passwordBackground.transform.position = Vector2.new(0, -75)

    do
        local spriteRenderer = passwordBackground:AddComponent(ComponentType.SpriteRenderer)
        spriteRenderer:SetSprite("assets/sprites/inputfield1_300x50.png")
        spriteRenderer.priority = 1
        local button = passwordBackground:AddComponent(ComponentType.Button)
        button.width = 300
        button.height = 50
        button.OnClick:Bind(function(button, mouseButton)
            if mouseButton == 0 and passwordField.firstSelect then passwordField.firstSelect = false passwordField.textRenderer.text = "" end
            passwordField.OnClick(button, mouseButton)
        end)
    end

    title = Actor.new("title")
    title.transform.position = Vector2.new(0,200)

    do
        local spriteRenderer = title:AddComponent(ComponentType.SpriteRenderer)
        spriteRenderer:SetSprite("assets/sprites/text_signup1_300x200.png")
    end

    errorTextActor = Actor.new("errorText")
    errorText = errorTextActor:AddComponent(ComponentType.TextRenderer)
    errorTextActor.transform.position = Vector2.new(-150,-150)
    errorText.fontSize = 25
    errorText.text = ""
    errorText.colour = Colour.red

    submitButton = Actor.new("submitButton")
    submitButton.transform.position = Vector2.new(250, -42)

    do
        local spriteRenderer = submitButton:AddComponent(ComponentType.SpriteRenderer)
        spriteRenderer:SetSprite("assets/sprites/button_submit1_147x64.png")
        local button = submitButton:AddComponent(ComponentType.Button)
        button.width, button.height = 147, 64
        button.OnClick:Bind(function(button, mouseButton)
            if mouseButton == 0 and not submitClicked then
                Engine.Coroutine.new(onSubmitClick)
            end
        end)
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

    passwordMask = Actor.new("passwordMask")
    passwordMask.transform.position = Vector2.new(-145, -55)
    
    do
        local textRenderer = passwordMask:AddComponent(ComponentType.TextRenderer)
        textRenderer.fontSize = 30
        textRenderer.priority = 2
        textRenderer.text = "Password"
    end

end

function Update()
    InputField.Update()
    if not passwordField.firstSelect then
        local str = ""
        for i=1,#passwordField.textRenderer.text,1 do str = str.."*" end
        passwordMask:GetComponent(ComponentType.TextRenderer).text = str
    end
end

Level.OnLoad = OnLoad
Level.Update = Update