PhysicsObject = {}
PhysicsObject.__index = PhysicsObject

local function _update(self)
    _component_update(self)
    _physicsobject_update(self)
end

function _oncollision(actor1Handle, actor2Handle)
    local actor1,actor2 = Actor._getActorByHandle(actor1Handle), Actor._getActorByHandle(actor2Handle)
    local thisobj = actor1:GetComponent(ComponentType.PhysicsObject)
    thisobj.OnCollide:Invoke(actor1, actor2)
end

--local function _destroy(self)   
--end

function PhysicsObject.new(handle)

    local obj = Component.new(handle)
    
    obj._update = _update
    --obj._oncollide = _oncollision
    obj.OnCollide = Event.new() -- params:  this, other (Actor)
    obj.drawCollider = false
    obj.SetCollider = _physicsobject_set_collider
    obj.GetPosition = _physicsobject_get_position
    obj.SetPosition = _physicsobject_set_position
    obj.GetRotation = _physicsobject_get_rotation
    obj.SetRotation = _physicsobject_set_rotation
    obj.SetCollisionLayer = _physicsobject_set_collisionlayer
    obj.GetCollisionLayer = _physicsobject_get_collisionlayer
    obj.linearVelocity = Vector2.new()
    obj.rotationalVelocity = 0.0
    
    return obj
    
end

return PhysicsObject