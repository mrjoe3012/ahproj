Component = {}
Component.__index = Component

function Component.new(handle)

	local component = {}
	setmetatable(component, Component)
	
	component._handle = handle
	component.enabled = true
	
	return component

end

return Component