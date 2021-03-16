local Database = require("lua/corelibs/Database")
local title
local usernameHeading, scoreHeading, positionHeading
local background
local backButton
local prevBackgroundColour
local backButton
local ROW_SPACING = Vector2.new(0,40)
local COL_SPACING_1, COL_SPACING_2, COL_SPACING_3 = Vector2.new(85,0), Vector2.new(300, 0), Vector2.new(90,0)
local COL_START, ROW_START = Vector2.new(-200, 200), Vector2.new(-200, 240)
local HEADING_FONT_SIZE = 20
local columnDivs, rowDivs = {}, {}
local rowTextFields = {}
local COL_COUNT = 4
local ROW_COUNT = 12

local function bubbleSort(t, condition)
    for i=1, #t-1 do
        for j=1,#t-1-i do
            if not condition(t[j], t[j+1]) then
                t[j], t[j+1] = t[j+1], t[j]
            end
        end
    end
end

local function onBackClicked()
    backClicked = true
    backButton:GetComponent(ComponentType.SpriteRenderer):SetSprite("assets/sprites/button_back2_65x64.png")
    Engine.Coroutine.YieldForSeconds(0.1)
    Level.LoadLevel(string.format("lua/scripts/levels/%s-menu.lua", _G.leaderboard.gameName))
end

local function populateLeaderboard(usernameAndScores)

    local fieldName = ""

    if _G.leaderboard.gameName == "planefighter" then
        fieldName = "planescore"
    end

    local results = Database.Query(string.format("SELECT accounts.username, scores.%s FROM scores, accounts WHERE accounts.username = scores.username",fieldName))

    local scores = {}

    for index,resultSet in pairs(results) do
        scores[resultSet["username"]] = tonumber(resultSet[fieldName])
    end

    bubbleSort(scores, function(v1,v2) return v1<v2 end)

    local clientFound = false

    local i = 1
    for username, score in pairs(scores) do
        local texts = rowTextFields[i]
        texts.rank.text = tostring(" "..i)
        texts.username.text = " "..username
        texts.score.text = tostring(" "..score)

        if username == _G.session.username then
            clientFound = true
            texts.username.colour = Colour.red
            texts.rank.colour = Colour.red
            texts.score.colour = Colour.red
        end

        i = i +1
        if (not clientFound and (i==10)) or (clientFound and i==11) then break end
    end

    if clientFound then return end

    local nextIndex = i

    local clientScore = scores[_G.session.username]

    local clientRank = 0

    i = 1
    for username, score in pairs(scores) do
        if username == _G.session.username then
            clientRank = i
            break
        end
        i = i + 1
    end

    rowTextFields[nextIndex].score.text = " "..clientScore
    rowTextFields[nextIndex].username.text = " ".._G.session.username
    rowTextFields[nextIndex].username.colour = Colour.red
    rowTextFields[nextIndex].score.colour = Colour.red
    rowTextFields[nextIndex].rank.colour = Colour.red
    rowTextFields[nextIndex].rank.text = " "..clientRank

end

function OnLoad()

    background = Actor.new("background")

    do
        local spriteRenderer = background:AddComponent(ComponentType.SpriteRenderer)
        spriteRenderer:SetSprite("assets/sprites/whitebg1_1170x731.jpg")
        spriteRenderer.scale = Vector2.new(1.2,1.2)
    end

    title = Actor.new("title")

    title.transform.position = Vector2.new(10,300)

    do
        local spriteRenderer = title:AddComponent(ComponentType.SpriteRenderer)
        spriteRenderer:SetSprite("assets/sprites/leaderboardtitle1_325x78.png")
    end

    positionHeading = Actor.new("positionHeading")
    positionHeading.transform.position = COL_START

    do
        local textRenderer = positionHeading:AddComponent(ComponentType.TextRenderer)
        textRenderer.text = "Rank"
        textRenderer.fontSize = HEADING_FONT_SIZE
    end

    usernameHeading = Actor.new("usernameHeading")

    usernameHeading.transform.position = COL_START + COL_SPACING_1

    do
        local textRenderer = usernameHeading:AddComponent(ComponentType.TextRenderer)
        textRenderer.text = "Username"
        textRenderer.fontSize = HEADING_FONT_SIZE
    end

    scoreHeading = Actor.new("scoreHeading")
    scoreHeading.transform.position = COL_START + COL_SPACING_1 + COL_SPACING_2

    do
        local textRenderer = scoreHeading:AddComponent(ComponentType.TextRenderer)
        textRenderer.text = "Score"
        textRenderer.fontSize = HEADING_FONT_SIZE
    end

    for i=1,COL_COUNT do
        local height = 443
        local div = Actor.new(string.format("columnDiv%d", i))
        div.transform.position = COL_START - Vector2.new(0,height/2)
        local spacingTotal = (i>1 and COL_SPACING_1 or Vector2.new()) + (i>2 and COL_SPACING_2 or Vector2.new()) + (i>3 and COL_SPACING_3 or Vector2.new())
        div.transform.position = div.transform.position + spacingTotal
        local rectRenderer = div:AddComponent(ComponentType.RectRenderer)
        rectRenderer.width, rectRenderer.height = 3, height
        rectRenderer.colour = Colour.black
        table.insert(columnDivs, div)
    end

    for i=1,ROW_COUNT do
        local width = 475
        local div = Actor.new(string.format("rowDiv%d", i))
        div.transform.position = ROW_START + Vector2.new(width/2,0) - ROW_SPACING*i
        local rectRenderer = div:AddComponent(ComponentType.RectRenderer)
        rectRenderer.height, rectRenderer.width = 3, width
        rectRenderer.colour = Colour.black
        table.insert(rowDivs, div)
    end

    backButton = Actor.new("backButton")
    backButton.transform.position = Vector2.new(-550, -320)

    do
        local spriteRenderer = backButton:AddComponent(ComponentType.SpriteRenderer)
        spriteRenderer:SetSprite("assets/sprites/button_back1_65x64.png")
        local button = backButton:AddComponent(ComponentType.Button)
        button.width, button.height = 147, 64
        button.OnClick:Bind(function(button, mouseButton)
            if mouseButton == 0 and not backClicked then
                Engine.Coroutine.new(onBackClicked)
            end
        end)
    end

    for i=1,ROW_COUNT-2 do
        local rankTextActor = Actor.new("rankText")
        local rankText = rankTextActor:AddComponent(ComponentType.TextRenderer)

        rankTextActor.transform.position = COL_START  - ROW_SPACING*(i)
        rankText.fontSize = HEADING_FONT_SIZE
        rankText.text = ""

        local usernameTextActor = Actor.new("usernameText")
        local usernameText = usernameTextActor:AddComponent(ComponentType.TextRenderer)

        usernameTextActor.transform.position = COL_START + COL_SPACING_1 - ROW_SPACING*(i)
        usernameText.fontSize = HEADING_FONT_SIZE
        usernameText.text = ""

        local scoreTextActor = Actor.new("scoreText")
        local scoreText = scoreTextActor:AddComponent(ComponentType.TextRenderer)

        scoreTextActor.transform.position = COL_START + COL_SPACING_1 + COL_SPACING_2  - ROW_SPACING*(i)
        scoreText.fontSize = HEADING_FONT_SIZE
        scoreText.text = ""

        table.insert(rowTextFields,  {rank=rankText, username=usernameText, score=scoreText})
    end

    populateLeaderboard()

end

function Update()

end

Level.OnLoad = OnLoad
Level.Update = Update