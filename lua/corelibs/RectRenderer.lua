RectRenderer = {}
RectRenderer.__index = RectRenderer

local function _update(self)

	_component_update(self)
	_renderer_update(self)
	_rectrenderer_update(self)

end

function RectRenderer.new(handle)

	local rectrenderer = Renderer.new(handle)
	
	rectrenderer.colour = Colour.red
	rectrenderer.width = 100
	rectrenderer.height = 100
	rectrenderer._update = _update
	
	return rectrenderer

end

return RectRenderer