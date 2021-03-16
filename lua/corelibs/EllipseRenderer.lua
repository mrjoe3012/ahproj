EllipseRenderer = {}
EllipseRenderer.__index = EllipseRenderer

local function _update(self)

	_component_update(self)
	_renderer_update(self)
	_ellipserenderer_update(self)

end

function EllipseRenderer.new(handle)

	local ellipserenderer = Renderer.new(handle)

	ellipserenderer.colour = Colour.red
	ellipserenderer.radii = Vector2.new(100,100)
	ellipserenderer._update = _update

	return ellipserenderer

end

return EllipseRenderer