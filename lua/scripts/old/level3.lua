local actor1, as1, rr1, po1
local actor2, as2
--TODO
-- update AudioSource global table's falloffdistance as it's currently not being updated, perhaps look at the existing update patterns for other statics? (physics)
-- fix stop, when stopping audio isplaying doesn't get set to false, it's still returning true :S
function OnLoad()
    actor1 = Actor.new("actor1")

    rr1 = actor1:AddComponent(ComponentType.RectRenderer)

    rr1.width = 100
    rr1.height = 100

    po1 = actor1:AddComponent(ComponentType.PhysicsObject)

    po1:SetCollider(ColliderType.Box, 100, 100, false, false)

    as1 = actor1:AddComponent(ComponentType.AudioSource)

    as1:SetAudioFile("assets/audio/mario.wav")
    as1.loop = true

    actor2 = Actor.new("actor2")
    as2 = actor2:AddComponent(ComponentType.AudioSource)
    as2:SetAudioFile("assets/audio/boing.wav")
    as2.loop = false
    as2.volume = 1.5
    as2.fallOffRate = 0

end

function Update()

    local speed = 100

    if as1.isPlaying == false then as1:Play() end

    local input = Vector2.new()

    if Input.GetKeyState(KeyCode.W) == KeyState.Down then
        input.y = input.y + 1
    end
    if Input.GetKeyState(KeyCode.A) == KeyState.Down then
        input.x = input.x - 1
    end
    if Input.GetKeyState(KeyCode.S) == KeyState.Down then
        input.y = input.y - 1
    end
    if Input.GetKeyState(KeyCode.D) == KeyState.Down then
        input.x = input.x + 1 
    end
    if Input.GetKeyState(KeyCode.Space) == KeyState.Down and as2.isPlaying == false then
        as2:Play()
    end

    po1.linearVelocity = speed*input

end

Level.OnLoad = OnLoad
Level.Update = Update