Actor = {}
Actor.__index = Actor
Actor._actors = {}

function Actor._getActorByHandle(handle)
   
    local actor = nil
    local index = 1
    
    while actor == nil and index <= #Actor._actors do
        if Actor._actors[index]._handle == handle then
            actor = Actor._actors[index]
		end
		index = index + 1
    end
    
    if actor == nil then error("Attempted to find actor by handle but an actor was not found.") end
    
    return actor
    
end

function Actor.new(name, tag)

	name = name or "Actor"
	tag = tag or ""

	local actor = {}
	actor._engineData = {}
	setmetatable(actor, Actor)

	actor.name = name
	actor.tag = tag
	actor.transform = Transform.new(Vector2.new(), 0)
	actor._components = {}
	
	actor._handle = _actor_new(name,tag)

    actor.OnUpdate = Event.new()

	table.insert(Actor._actors, actor)

	return actor

end

function Actor.FindActorsByName(name)
  
    local actors = {}
    
    for _,actor in pairs(Actor._actors) do
        if (actor.name == name) then
            table.insert(actors, actor)
        end
    end
    
    return actors
    
end

function Actor.FindActorsByTag(tag)
   
    local actors = {}
    
    for _,actor in pairs(Actor._actors) do
       
        if(actor.tag == tag) then
            table.insert(actors, actor)
        end
        
    end
    
    return actors
        
end

function Actor:_update()

	_actor_update(self)

	for _,comp in pairs(self._components) do
	
		comp:_update()
	
	end
    
    self.OnUpdate:Invoke(self)
    
end

function Actor:Destroy()
	
	_actor_destroy(self._handle)

	local index = -1

	for i,actor in pairs(Actor._actors) do
	
		if actor == self then
			index = i
			break
		end

	end
	
	table.remove(Actor._actors, index)

end

function Actor:AddComponent(componentType)

	local constructors = { [ComponentType.RectRenderer] = RectRenderer.new, [ComponentType.EllipseRenderer] = EllipseRenderer.new, [ComponentType.SpriteRenderer] = SpriteRenderer.new, [ComponentType.TextRenderer] = TextRenderer.new, [ComponentType.PhysicsObject] = PhysicsObject.new, [ComponentType.AudioSource] = AudioSource.new, [ComponentType.Animation] = Animation.new, [ComponentType.Button] = Button.new }

	local component = constructors[componentType](_actor_addcomponent(self._handle, componentType))
	
	table.insert(self._components, component)
	
	return component
	
end

function Actor:GetComponent(componentType)

	local handle = _actor_getcomponent(self, componentType)
	
	if handle == 0 then
		return nil
	end

	for _,comp in pairs(self._components) do
	
		if comp._handle == handle then
			return comp
		end
		
	end

	error("Component not found but should be present.")

end

function Actor:RemoveComponent(componentType)

	local removedHandle = _actor_removecomponent(self, componentType)

	if removedHandle == 0 then
	
		error("Attempted to remove component that isn't attached to actor with name "..self.name)
	
	end

	local index = nil
	
	for i,component in pairs(self._components) do
		
		if component._handle == removedHandle then
			index = i
			break
		end
		
	end

	if index == nil then
		error("Component was not found but should be present.")
	end
	
	table.remove(self._components, index)
	
end

return Actor