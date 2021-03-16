TextRenderer = {}
TextRenderer.__index = TextRenderer

local function _update(self)

	_component_update(self)
	_renderer_update(self)
	_textrenderer_update(self)

end

function TextRenderer.new(handle)
  
    local rend = Renderer.new(handle)
    
    rend.fontFamily = "Verdana"
    rend.fontSize = 50.0
    rend.colour = Colour.black
    
    rend.text = "Text"
    
    rend._update = _update
    
    return rend
    
end