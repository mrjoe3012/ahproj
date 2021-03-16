SpriteRenderer = {}
SpriteRenderer.__index = SpriteRenderer

local function _update(self)

	_component_update(self)
	_renderer_update(self)
	_spriterenderer_update(self)

end

local function _setsprite(self, filename)

	_spriterenderer_setsprite(self, filename)

end

local function _getsprite(self, filename)

	return _spriterenderer_getsprite(self)

end

function SpriteRenderer.new(handle)

	local spriterenderer = Renderer.new(handle)
	setmetatable(spriterenderer, SpriteRenderer)
	
	spriterenderer.SetSprite = _setsprite
	spriterenderer.GetSprite = _getsprite
	spriterenderer._update = _update
	
	return spriterenderer

end

return SpriteRenderer