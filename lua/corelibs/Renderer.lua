Renderer = {}
Renderer.__index = Renderer

function Renderer.new(handle)

	local renderer = Component.new(handle)

	renderer.priority = 0
	renderer.scale = Vector2.new(1,1)

	return renderer

end

return Renderer