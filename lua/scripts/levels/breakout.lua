local Database = require("lua/corelibs/Database")
local prevBackgroundColour
local ball
local paddle
local paddleSpeed  = 500
local bricksToDestroy = {}
local scoreText
local score = 0
local brickValues = {}
local ballSpeedMultiplier = 1.01
local gameStart = false
local startVel = Vector2.new(0,200)
local maxBallSpeed = 210 
local timeBonus, currentTimeBonus = 1000, 1000
local timeLimit = 300 
local gameOverText
local gameOver = false
local finalScoreText
local brickCount = 0

local function getTotalScore()
	return math.floor(currentTimeBonus + score)
end

local function gameOverCoroutine()
	Engine.Coroutine.YieldForSeconds(3)
	Level.LoadLevel("lua/scripts/levels/breakout-menu.lua")
end

local function updateScore()

    local username = _G.session.username
    local oldScore = _G.session.brickscore
    if getTotalScore() > oldScore then
        Database.Query(string.format("UPDATE scores SET brickscore=%d WHERE username='%s'", getTotalScore(), username))
        _G.session.brickscore = getTotalScore()
    end

end

local function gameWinCoroutine()
	updateScore()
	Engine.Coroutine.YieldForSeconds(3)
	Level.LoadLevel("lua/scripts/levels/breakout-menu.lua")
end

local function brickCollide(brick, other)

	if other.name == "ball" then
		local phys = brick:GetComponent(ComponentType.PhysicsObject)
		local pos = phys:GetPosition()
		local rend = brick:GetComponent(ComponentType.RectRenderer)
		local otherPhys = other:GetComponent(ComponentType.PhysicsObject)
		local otherVel = otherPhys.linearVelocity
		local otherPos = otherPhys:GetPosition()
		local rightX, leftX = pos.x + (rend.width/2), pos.x - (rend.width/2)
		if otherPos.x > rightX then
			otherVel.x = -otherVel.x
		elseif otherPos.x < leftX then
			otherVel.x = -otherVel.x
		else
			otherVel.y = -otherVel.y
		end
		table.insert(bricksToDestroy, brick)
		score = score + brickValues[brick]
		otherPhys.linearVelocity = otherPhys.linearVelocity*ballSpeedMultiplier
		if phys.linearVelocity:Magnitude() > maxBallSpeed then
			phys.linearVelocity = phys.linearVelocity:Normalize()*maxBallSpeed
		end
		brickCount = brickCount - 1
		
	end
end

local function ballCollide(ball, other)
	local phys = ball:GetComponent(ComponentType.PhysicsObject)
	local paddlePhys = paddle:GetComponent(ComponentType.PhysicsObject)
	if other.name == "paddle" then
		phys:SetPosition(Vector2.new(phys:GetPosition().x, paddlePhys:GetPosition().y+20))
		phys.linearVelocity.y = -phys.linearVelocity.y
		if paddlePhys.linearVelocity.x ~= 0 then
			phys.linearVelocity.x = (1*(paddlePhys.linearVelocity.x/math.abs(paddlePhys.linearVelocity.x)))*phys.linearVelocity.y

		else
			--phys.linearVelocity.x = 0
		end
	end
end

local function spawnBricks(count, rows, startCorner)

	local colSpace, rowSpace = 110, 60
	local brickSize = Vector2.new(100,50)
	local rowColours = {
		Colour.red,
		Colour.blue,
		Colour.new(0.5, 0, 0.5),
		Colour.green
	}
	local baseValue = 10
	local brickValueMultiplier = 2
	for j=1,rows do
		for i=1,count do
			local brick = Actor.new(string.format("brick%d,%d", i,j), "brick")
			local rend = brick:AddComponent(ComponentType.RectRenderer)
			rend.width, rend.height = brickSize.x, brickSize.y
			rend.colour = rowColours[j] or rowColours[#rowColours]
			local phys = brick:AddComponent(ComponentType.PhysicsObject)
			phys:SetCollider(ColliderType.Box, rend.width, rend.height, false, true)
			phys.OnCollide:Bind(brickCollide)
			phys.drawCollider = true
			local pos = Vector2.new(startCorner.x, startCorner.y)
			pos.y = pos.y - (rowSpace*(j-1))
			pos.x = pos.x + (colSpace*(i-1))
			phys:SetPosition(pos)
			brickValues[brick] = baseValue+ (baseValue*brickValueMultiplier*(rows-j))
			brickCount = brickCount + 1
		end
	end


end

function OnLoad()
	prevBackgroundColour = Game.backgroundColour
	Game.backgroundColour = Colour.new(0,0,0,0)

	ball = Actor.new("ball")

	do
		local renderer = ball:AddComponent(ComponentType.EllipseRenderer)
		renderer.colour = Colour.white		
		renderer.radii = Vector2.new(10,10)
		local phys = ball:AddComponent(ComponentType.PhysicsObject)
		phys:SetCollider(ColliderType.Circle, 10, false, false)
		phys.drawCollider = true
		phys:SetPosition(Vector2.new(0,-280))
		phys.OnCollide:Bind(ballCollide)
	end

	paddle = Actor.new("paddle")

	do
		local renderer = paddle:AddComponent(ComponentType.RectRenderer)
		renderer.colour = Colour.white
		renderer.width, renderer.height = 200,20
		local phys = paddle:AddComponent(ComponentType.PhysicsObject)
		phys:SetPosition(Vector2.new(0,-300))
		phys:SetCollider(ColliderType.Box, 200, 20, false, true)
		phys.drawCollider = true
	end

	scoreText = Actor.new("scoreText")
    	scoreText.transform.position = Vector2.new(-550, 350)

	do
		local renderer = scoreText:AddComponent(ComponentType.TextRenderer)
		renderer.priority = 100
	end

	gameOverText = Actor.new("gameOverText")
	gameOverText.transform.position = Vector2.new(-225,0)

	do
		local renderer = gameOverText:AddComponent(ComponentType.TextRenderer)
		renderer.text = "GAME OVER"
		renderer.colour = Colour.white
		renderer.priority = 100
		renderer.fontSize = 80 
		renderer.enabled = false
	end

	finalScoreText = Actor.new("finalScoreText")
	finalScoreText.transform.position = Vector2.new(-300, 0)

	do	
		local renderer = finalScoreText:AddComponent(ComponentType.TextRenderer)
		renderer.colour = Colour.white
		renderer.priority = 100
		renderer.fontSize = 65 
		renderer.enabled = false
	end

	spawnBricks(10,4,Vector2.new(-500,250))

end

local function ballWallCollisionCheck()
	local phys = ball:GetComponent(ComponentType.PhysicsObject)
	local rend = ball:GetComponent(ComponentType.EllipseRenderer)

	local pos = phys:GetPosition()
	local vel = phys.linearVelocity

	if pos.x > (1200/2)-(rend.radii.x/2) then
		vel.x = -vel.x
		pos.x = (1200/2)-(rend.radii.x/2)
	elseif  pos.x < (-1200/2)+(rend.radii.x/2) then
		vel.x = -vel.x
		pos.x = (-1200/2)+(rend.radii.x/2)
	end
	if pos.y > (720/2)-(rend.radii.x/2) then
		vel.y = -vel.y
		pos.y = (720/2)-(rend.radii.x/2)
	end
	if pos.y < (-720/2)+(rend.radii.x/2) then
		gameOver = true
		gameOverText:GetComponent(ComponentType.TextRenderer).enabled = true
		Engine.Coroutine.new(gameOverCoroutine)
	end
	phys:SetPosition(pos)
end

local function inputLoop()
	local input = Vector2.new()
	
	if Input.GetKeyState(KeyCode.A) == KeyState.Down or Input.GetKeyState(KeyCode.ArrowLeft) == KeyState.Down then
		input.x = input.x - 1
	elseif Input.GetKeyState(KeyCode.D) == KeyState.Down or Input.GetKeyState(KeyCode.ArrowRight) == KeyState.Down then
		input.x = input.x + 1
	end
	local rend = paddle:GetComponent(ComponentType.RectRenderer)
	local phys = paddle:GetComponent(ComponentType.PhysicsObject)
	phys.linearVelocity = input*paddleSpeed
	if phys:GetPosition().x < (-1200/2)+(rend.width/2) then
		phys:SetPosition(Vector2.new((-1200)/2+(rend.width/2),phys:GetPosition().y))
	elseif phys:GetPosition().x > (1200/2)-(rend.width/2) then
		phys:SetPosition(Vector2.new((1200)/2-(rend.width/2),phys:GetPosition().y))
	end

end

function Update()
	if gameOver then
		return
	end
	inputLoop()
	ballWallCollisionCheck()
	for _,brick in pairs(bricksToDestroy) do
		brick:Destroy()
	end
	bricksToDestroy = {}

	if brickCount <= 0 then
		gameOver = true
		finalScoreText:GetComponent(ComponentType.TextRenderer).text = string.format("Final Score: %d", getTotalScore())
		finalScoreText:GetComponent(ComponentType.TextRenderer).enabled = true
		Engine.Coroutine.new(gameWinCoroutine)
	end

	local scoreTextRenderer = scoreText:GetComponent(ComponentType.TextRenderer)
	scoreTextRenderer.text = tostring(getTotalScore())
	scoreTextRenderer.colour = Colour.white

	if not gameStart and paddle:GetComponent(ComponentType.PhysicsObject).linearVelocity:Magnitude() > 0 then
		gameStart = true
		ball:GetComponent(ComponentType.PhysicsObject).linearVelocity = startVel
	end

	if gameStart then
		currentTimeBonus = math.max(0,currentTimeBonus - (timeBonus/timeLimit)*Time.delta)
	end

end

function OnUnload()
	Game.backgroundColour = prevBackgroundColour
end

Level.OnLoad = OnLoad
Level.Update = Update
Level.OnUnload = OnUnload
