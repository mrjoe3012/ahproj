local actor1, actor2
local speed1, speed2 = 100, 125
local dead = false

function collision(actor2, actor1)
    dead = true
end

function collision2(actor1, actor2)
    dead = true
end

function OnLoad()
    
    actor1 = Actor.new("1")
    actor2 = Actor.new("2")
    
    local rend = actor1:AddComponent(ComponentType.EllipseRenderer)
    rend.radii = Vector2.new(50,50)
    rend.colour = Colour.blue
    
    rend = actor2:AddComponent(ComponentType.EllipseRenderer)
    rend.radii = Vector2.new(50,50)
    rend.colour = Colour.red
    
    local obj = actor1:AddComponent(ComponentType.PhysicsObject)
    obj.drawCollider = true
    obj:SetCollider(ColliderType.Circle, 50, false, false)
    obj.OnCollide:Bind(collision2)
    obj = actor2:AddComponent(ComponentType.PhysicsObject)
    obj.drawCollider = true
    obj:SetCollider(ColliderType.Circle, 50, false, false)
    obj:SetPosition(Vector2.new(200,0))
    obj.OnCollide:Bind(collision)
    --**************
    -- ADD ON COLLISION FOR COLLIDERS!!
    -- add functionality to onquit
    --**************
    
end

function Update()
    
    if(dead == true and actor1 ~= nil) then actor1:Destroy() actor1 = nil end
    
    local input1, input2 = Vector2.new(), Vector2.new()

    if(Input.GetKeyState(KeyCode.A) == KeyState.Down) then
        input1.x = input1.x - 1
    end
    
    if(Input.GetKeyState(KeyCode.S) == KeyState.Down) then
        input1.y = input1.y - 1
    end
    
    if(Input.GetKeyState(KeyCode.D) == KeyState.Down) then
        input1.x = input1.x + 1
    end
    
    if(Input.GetKeyState(KeyCode.W) == KeyState.Down) then
        input1.y = input1.y + 1
    end
    
    if(Input.GetKeyState(KeyCode.ArrowLeft) == KeyState.Down) then
        input2.x = input2.x - 1
    end
    
    if(Input.GetKeyState(KeyCode.ArrowDown) == KeyState.Down) then
        input2.y = input2.y - 1
    end
    
    if(Input.GetKeyState(KeyCode.ArrowRight) == KeyState.Down) then
        input2.x = input2.x + 1
    end
    
    if(Input.GetKeyState(KeyCode.ArrowUp) == KeyState.Down) then
        input2.y = input2.y + 1
    end
    if actor1 ~= nil then
        local obj = actor1:GetComponent(ComponentType.PhysicsObject)
        if obj ~= nil then
            obj.linearVelocity = input1*(speed1)
        end
    end
    obj = actor2:GetComponent(ComponentType.PhysicsObject)
    if obj ~= nil then
        obj.linearVelocity = input2*(speed2)
    end
    
end

Level.OnLoad = OnLoad
Level.Update = Update