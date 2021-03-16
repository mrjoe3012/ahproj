FCS = dofile("lua/scripts/flashcardset.lua")

cardSet = nil
cardOrder = nil

local cardBox = nil
local cardText, cardText_tr = nil
local indText, indText_tr = nil
local cardOrder = nil
local currentIndex = 1
local showAnswer = false

local function genRandomOrder(cardSet)

    local order = {}
    local numbersLeft = {}
    
    for i=1,#cardSet,1 do
        table.insert(numbersLeft, i)
    end

    for i=1,#numbersLeft,1 do
        local n = math.random(1, #numbersLeft)
        table.insert(order, table.remove(numbersLeft, n))
    end

    return order

end

function OnLoad()
    math.randomseed(os.time())
    cardSet = FCS.fromCsv("lua/scripts/mods.fcs")
    cardOrder = genRandomOrder(cardSet)

    cardBox = Actor.new("card box")
    local cbr = cardBox:AddComponent(ComponentType.RectRenderer)
    cbr.width = 1000
    cbr.height = 240

    cardText = Actor.new("card text")
    cardText.transform.position = Vector2.new(-440, 20)
    cardText_tr = cardText:AddComponent(ComponentType.TextRenderer)
    cardText_tr.text = "Hello World"
    cardText_tr.fontSize = 25

    indText = Actor.new("ind text")
    indText.transform.position = Vector2.new(-440, 70)
    indText_tr = indText:AddComponent(ComponentType.TextRenderer)
    indText_tr.fontSize = 20

end

function Update()

    if Input.GetKeyState(KeyCode.Space) == KeyState.Released then
        if showAnswer == true then
            currentIndex = currentIndex + 1
            if currentIndex > #cardOrder then
                currentIndex = 1
                cardOrder = genRandomOrder(cardSet)
            end
            showAnswer = false
        else
            showAnswer = true
        end
    end

    cardText_tr.text = (showAnswer == false) and cardSet[cardOrder[currentIndex]].q or cardSet[cardOrder[currentIndex]].a
    indText_tr.text = string.format("%d/%d", currentIndex, #cardOrder)
end

Level.OnLoad = OnLoad
Level.Update = Update