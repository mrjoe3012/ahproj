local actor
local direction = Vector2.new(1,-0.2)
direction = direction:Normalized()
local speed = 2.2
local size = Vector2.new(390,121)
local scale = 0.5
size = size*scale

local bounds = {["Left"]=-400, ["Right"]=400, ["Up"]=300, ["Down"]=-300}

function OnLoad()
	actor = Actor.new("Joe")
	rend = actor:AddComponent(ComponentType.SpriteRenderer)
    rend:SetSprite("samsung.png")
    
end

function Update()

	local newpos = actor.transform.position
    newpos = newpos + direction*speed
    local collision = false
    
    if newpos.x - size.x/2 <= bounds.Left or newpos.x + size.x/2 >= bounds.Right then
        direction.x = direction.x*-1
        collision = true
    end
        
    if newpos.y - size.y/2 <= bounds.Down or newpos.y + size.y/2 >= bounds.Up then
        direction.y =  direction.y*-1
        collision = true
    end
    
    if collision == false then
        actor.transform.position = newpos
    end
        
end

function OnUnload()

	error("aww poo im unloading")
	
end

Level.OnLoad = OnLoad
Level.Update = Update
Level.OnUnload = OnUnload