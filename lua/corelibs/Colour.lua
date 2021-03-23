Colour = {}
Colour.__index = Colour

function Colour.new(r,g,b,a)

	r = r or 1
	g = g or 1
	b = b or 1
	a = a or 1

	local colour = {}
	setmetatable(colour, Colour)
	
	colour.r = r
	colour.g = g
	colour.b = b
	colour.a = a

	return colour

end

Colour.white = Colour.new(1,1,1)
Colour.red = Colour.new(1,0,0,1)
Colour.green = Colour.new(0, 1, 0, 1)
Colour.black = Colour.new(0, 0, 0, 1)
Colour.blue = Colour.new(0, 0, 1, 1)
Colour.yellow = Colour.new(1, 1, 0, 1)
Colour.orange = Colour.new(1, 0.5, 0, 1)
Colour.pink = Colour.new(1, 0.8, 0.8, 1)
Colour.purple = Colour.new(0.5, 0, 0.5, 1)
Colour.grey = Colour.new(0.5, 0.5, 0.5, 1)
Colour.brown = Colour.new(0.5, 0.25, 0, 1)

return Colour