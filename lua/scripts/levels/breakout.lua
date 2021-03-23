local prevBackgroundColour
local ball
local paddle
local paddleSpeed  = 250
local bricksToDestroy = {}

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
	end
end

local function ballCollide(ball, other)
	local phys = ball:GetComponent(ComponentType.PhysicsObject)
	local paddlePhys = paddle:GetComponent(ComponentType.PhysicsObject)
	if other.name == "paddle" then
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
		Colour.green
	}
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
		end
	end


end

function OnLoad()
	prevBackgroundColour = Game.backgroundColour
	Game.backgroundColour = Colour.new(0,0,0,0)

	ball = Actor.new("ball")
	ball.transform.position = Vector2.new(0,-250)

	do
		local renderer = ball:AddComponent(ComponentType.EllipseRenderer)
		renderer.colour = Colour.white		
		renderer.radii = Vector2.new(10,10)
		local phys = ball:AddComponent(ComponentType.PhysicsObject)
		phys:SetCollider(ColliderType.Circle, 10, false, false)
		phys.drawCollider = true
		phys.linearVelocity = Vector2.new(100,100) -- TODO make this linear for the final game
		phys.OnCollide:Bind(ballCollide)
	end

	paddle = Actor.new("paddle")

	do
		local renderer = paddle:AddComponent(ComponentType.RectRenderer)
		renderer.colour = Colour.white -- TODO change this to a paddle
		renderer.width, renderer.height = 200,20
		local phys = paddle:AddComponent(ComponentType.PhysicsObject)
		phys:SetPosition(Vector2.new(0,-300))
		phys:SetCollider(ColliderType.Box, 200, 20, false, true)
		phys.drawCollider = true
	end

	spawnBricks(5,2,Vector2.new(-300,300))

end

local function ballWallCollisionCheck()
	local phys = ball:GetComponent(ComponentType.PhysicsObject)
	local rend = ball:GetComponent(ComponentType.EllipseRenderer)

	local pos = phys:GetPosition()
	local vel = phys.linearVelocity

	if pos.x > (1200/2)-(rend.radii.x/2) or pos.x < (-1200/2)+(rend.radii.x/2) then
		vel.x = -vel.x
		pos.x = pos.x - (1*(vel.x/math.abs(vel.x)))
	end
	if pos.y > (720/2)-(rend.radii.x/2) then
		vel.y = -vel.y
		pos.y = pos.y - (1*(vel.y/math.abs(vel.y)))
	end
	if pos.y < (-720/2)+(rend.radii.x/2) then
		error("game over") --TODO back to menu and update leaderboard
	end
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
	inputLoop()
	ballWallCollisionCheck()
	for _,brick in pairs(bricksToDestroy) do
		brick:Destroy()
	end
	bricksToDestroy = {}
end

function OnUnload()
	Game.backgroundColour = prevBackgroundColour
end

Level.OnLoad = OnLoad
Level.Update = Update
Level.OnUnload = OnUnload
