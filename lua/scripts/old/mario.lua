mario = {}

function mario.OnLoad()

    mario.actor = Actor.new("mario", "player")

    local rend = mario.actor:AddComponent(ComponentType.SpriteRenderer)
    local anim = mario.actor:AddComponent(ComponentType.Animation)
    rend:SetSprite("assets/sprites/mario_idle1_64x128.png")

    local idleSet = {}
    idleSet.length = 0.1
    idleSet.sprites = {"assets/sprites/mario_idle1_64x128.png"}

    anim:AddAnim(idleSet)

    local runSet = {}
    runSet.length = 0.5
    runSet.sprites = {"assets/sprites/mario_run1_64x128.png", "assets/sprites/mario_run2_64x128.png"}

    anim:AddAnim(runSet)

    anim.animationIndex = 1
    
end

function mario.Update()

end

function mario.__index(table, index)

    if index == "renderer" then
        return mario.actor:GetComponent(ComponentType.SpriteRenderer)
    elseif index == "animation" then
        return mario.actor:GetComponent(ComponentType.Animation)
    else
        return rawget(mario, index)
    end

end

return mario