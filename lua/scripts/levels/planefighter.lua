local Database = require("lua/corelibs/Database")

local skyBackgrounds = {
}

local plane, plane_physicsObject, plane_spriteRenderer

local scoreText

local SKY_START_X = 360
local SKY_MIN_X = -1600
local SKY_REPEAT_COUNT = 2

local camSpeed, camSpeedInitial = 200, 200
local planeSpeed = 200

local OBSTACLE_MIN_SPEED_INITIAL, OBSTACLE_MAX_SPEED_INITIAL = 200, 350
local OBSTACLE_MIN_SPEED, OBSTACLE_MAX_SPEED = OBSTACLE_MIN_SPEED_INITIAL, OBSTACLE_MAX_SPEED_INITIAL
local OBSTACLE_INTERVAL_INITIAL = 5
local OBSTACLE_INTERVAL = OBSTACLE_INTERVAL_INITIAL

local EULERS_NUMBER = 2.1782818

local obstacles = {}

local lastObstacle = 0

local planeDead = false

local startTime

local score = 0

local function updateScore()

    local username = _G.session.username
    local oldScore = _G.session.planescore

    if score > oldScore then
        Database.Query(string.format("UPDATE scores SET planescore=%d WHERE username='%s'", score, username))
        _G.session.planescore = score
    end

end

local function newExplosion()

    local explosion = Actor.new("explosion")
    explosion:AddComponent(ComponentType.SpriteRenderer)
    local as = explosion:AddComponent(ComponentType.AudioSource)
    as:SetAudioFile("assets/audio/explosion.wav")
    as.volume = 0.5
    as:Play()
    local anim = explosion:AddComponent(ComponentType.Animation)

    local sprites = {}

    for i=1,16,1 do
        table.insert(sprites, string.format("assets/sprites/explosion%d.png", i))
    end

    anim:AddAnim({length = 1, sprites=sprites})

    Engine.CallDelayed(1, function()
        explosion:Destroy()
    end)

    return explosion

end

local function onPlaneCollide(plane, o2)

    if o2.tag == "obstacle" then
        planeDead = true
    end

end

local function newHelicopter()

    local helicopter = Actor.new("helicopter")
    local spriteRenderer = helicopter:AddComponent(ComponentType.SpriteRenderer)
    spriteRenderer:SetSprite("assets/sprites/helicopter1_96x46.png")
    local physicsObject = helicopter:AddComponent(ComponentType.PhysicsObject)
    physicsObject.drawCollider = true
    physicsObject:SetCollider(ColliderType.Box, 96, 46, false, false)
    physicsObject.linearVelocity = Vector2.new(-math.random(OBSTACLE_MIN_SPEED, OBSTACLE_MAX_SPEED), 0)
    return helicopter
end

local function newBird()

    local sprites = {}

    if math.random(0,1) == 0 then
        sprites[1] = "assets/sprites/bird1.png"
        sprites[2] = "assets/sprites/bird2.png"
        sprites[3] = "assets/sprites/bird3.png"
    else
        sprites[1] = "assets/sprites/bird4.png"
        sprites[2] = "assets/sprites/bird5.png"
        sprites[3] = "assets/sprites/bird6.png"
    end

    local bird = Actor.new("bird")
    local spriteRenderer = bird:AddComponent(ComponentType.SpriteRenderer)
    spriteRenderer.scale = Vector2.new(1.5,1.5)
    local anim = bird:AddComponent(ComponentType.Animation)

    anim:AddAnim({length=0.4, sprites=sprites})

    local physicsObject = bird:AddComponent(ComponentType.PhysicsObject)
    physicsObject.drawCollider = true
    physicsObject:SetCollider(ColliderType.Box, 28, 34, false, false)
    physicsObject.linearVelocity = Vector2.new(-math.random(OBSTACLE_MIN_SPEED, OBSTACLE_MAX_SPEED), 0)
    return bird

end

local obstacleFuncs = {
    newBird,
    newHelicopter,
}

local function updateObstacles()

    if Time.time - lastObstacle >= OBSTACLE_INTERVAL then
        lastObstacle = Time.time
        local newObstacle = obstacleFuncs[math.random(1,#obstacleFuncs)]()
        newObstacle:GetComponent(ComponentType.PhysicsObject):SetPosition(Vector2.new(600, math.random(-350, 350)))
        newObstacle.tag = "obstacle"
        newObstacle:GetComponent(ComponentType.PhysicsObject):SetCollisionLayer(1)
        table.insert(obstacles, newObstacle)
    end

    for i, obstacle in pairs(obstacles) do
        if obstacle:GetComponent(ComponentType.PhysicsObject):GetPosition().x < -750 then
            obstacle:Destroy()
            table.remove(obstacles, i)
        end
    end

end

local function moveSky()
    for i,sky in pairs(skyBackgrounds) do
        sky.transform.position.x = sky.transform.position.x - (Time.delta*camSpeed)
        if sky.transform.position.x <= SKY_MIN_X then
            sky.transform.position.x = sky.transform.position.x + 1919*#skyBackgrounds
        end
    end
end

local function movePlane()

    if planeDead and plane then 
        local explosion = newExplosion()
        explosion.transform.position = plane_physicsObject:GetPosition()
        plane:Destroy()
        plane = nil
        updateScore()
        Engine.CallDelayed(3, function()
            Level.LoadLevel("lua/scripts/levels/planefighter-menu.lua")
        end)
    end
    if planeDead then return end

    local input = Vector2.new()

    if Input.GetKeyState(KeyCode.W) == KeyState.Down or Input.GetKeyState(KeyCode.ArrowUp) == KeyState.Down then
        input.y = input.y + 1
    end

    if Input.GetKeyState(KeyCode.A) == KeyState.Down or Input.GetKeyState(KeyCode.ArrowLeft) == KeyState.Down then
        input.x = input.x - 1
    end

    if Input.GetKeyState(KeyCode.S) == KeyState.Down or Input.GetKeyState(KeyCode.ArrowDown) == KeyState.Down then
        input.y = input.y - 1
    end

    if Input.GetKeyState(KeyCode.D) == KeyState.Down or Input.GetKeyState(KeyCode.ArrowRight) == KeyState.Down then
        input.x = input.x + 1
    end

    plane_physicsObject.linearVelocity = input*planeSpeed
    if plane_physicsObject.linearVelocity.x > 0 and plane_spriteRenderer:GetSprite() == "assets/sprites/plane1_137x33.png" then
        plane_spriteRenderer:SetSprite("assets/sprites/plane2_137x33.png")
    elseif plane_physicsObject.linearVelocity.x == 0 and plane_spriteRenderer:GetSprite() == "assets/sprites/plane2_137x33.png" then
        plane_spriteRenderer:SetSprite("assets/sprites/plane1_137x33.png")
    end

    local planePos = plane_physicsObject:GetPosition()

    local newY, newX

    if planePos.x >= 545 then
        newX = 545
    elseif planePos.x <= -545 then
        newX = -545
    end

    if planePos.y >= 345 then
        newY = 345
    elseif planePos.y <= -345 then
        newY = -345 
    end

    if newY or newX then plane_physicsObject:SetPosition(Vector2.new(newX or planePos.x, newY or planePos.y)) end
end

local function updateGameState()

    local elapsed = Time.time - startTime

    local ft = math.pow(EULERS_NUMBER, (1/50)*elapsed)

    OBSTACLE_INTERVAL = OBSTACLE_INTERVAL_INITIAL / math.min(ft, 20)
    OBSTACLE_MIN_SPEED, OBSTACLE_MAX_SPEED = math.floor(OBSTACLE_MIN_SPEED_INITIAL*math.min(5,ft)), math.floor(OBSTACLE_MAX_SPEED_INITIAL*math.min(3,ft))
    camSpeed = camSpeedInitial * math.floor(2.5, fx)

    score = math.floor(elapsed*ft)

end

function OnLoad()

    Physics.SetLayer(1,1,false)

    startTime = Time.time

    for i=1,SKY_REPEAT_COUNT,1 do
        skyBackgrounds[i] = Actor.new("skyBackground"..tostring(i))
        skyBackgrounds[i].transform.position = Vector2.new(SKY_START_X + (1919*(i-1)), 0)
        local spriteRenderer = skyBackgrounds[i]:AddComponent(ComponentType.SpriteRenderer)
        spriteRenderer:SetSprite("assets/sprites/sky1_1920x1200.png")
        spriteRenderer.scale.x = spriteRenderer.scale.x - (2*(i%2))
    end

    plane = Actor.new("plane")

    plane.transform.position = Vector2.new(-200,0)

    do
        spriteRenderer = plane:AddComponent(ComponentType.SpriteRenderer)
        plane_spriteRenderer = spriteRenderer
        spriteRenderer:SetSprite("assets/sprites/plane1_137x33.png")
        spriteRenderer.priority = 1
        local physicsObject = plane:AddComponent(ComponentType.PhysicsObject)
        plane_physicsObject = physicsObject
        physicsObject:SetCollider(ColliderType.Box, 98, 33, false, false)
        physicsObject.drawCollider = true
        physicsObject.OnCollide:Bind(onPlaneCollide)
    end

    local scoreTextActor = Actor.new("scoreTextActor")
    scoreTextActor.transform.position = Vector2.new(-550, 350)
    scoreText = scoreTextActor:AddComponent(ComponentType.TextRenderer)
    scoreText.priority = 3
end

function Update()

    moveSky()
    movePlane()
    updateObstacles()

    if not planeDead then
        updateGameState()
    end

    scoreText.text = tostring(score)

end

Level.OnLoad = OnLoad
Level.Update = Update