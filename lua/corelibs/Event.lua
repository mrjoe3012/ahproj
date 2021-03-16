Event = {}
Event.__index = Event

function Event.new()

	local event = {}
	setmetatable(event, Event)
	
	event.funcs = {}
	event.instanceToFuncs = {}
    
	return event

end

function Event:Bind(func)

	table.insert(self.funcs, func)

end

function Event:BindMember(instance, func)

	if (self.instanceToFuncs[instance] == nil) then
		self.instanceToFuncs[instance] = {}
	end

	table.insert(self.instanceToFuncs[instance], func)

end

function Event:Unbind(func)

	local index = -1

	for i,f in pairs(self.funcs) do
	
		index = i
		break
	
	end

	if index == -1 then
		error("Function was not bound.")
	end
		table.remove(self.funcs, index)

end

function Event:UnbindMember(instance, func)

	local funclist = self.instanceToFuncs[instance]

	if funclist == nil then
		error("The instance does not have any bound functions.")
	end
	
	local index = -1
	
	for i, f in pairs(funclist) do
	
		if f == func then
			index = i
			break
		end
	
	end

	if index == -1 then
		error("The member function is not bound to the event.")
	end
		
	table.remove(funclist, index)
	
end

function Event:UnbindInstance(instance)

	local funcList = self.instanceToFuncs[instance]

	if funcList == nil then
		error("The instance is not bound to the event.")
	end
	
	self.instanceToFuncs[instance] = nil

end

function Event:UnbindAll()
  
    self.instanceToFuncs = {}
    self.funcs = {}
    
end

function Event:Invoke(...)

	for _,f in pairs(self.funcs) do
        f(...)
	end
	
	for instance,t in pairs(self.instanceToFuncs) do
        for _,f in pairs(t) do
		  f(instance, ...)
        end
	end
	
end

return Event