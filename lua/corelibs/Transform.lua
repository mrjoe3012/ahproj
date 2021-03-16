Transform = {}
Transform.__index = Transform

function Transform.new(position, rotation)

	position = position or Vector2.new()
	rotation = rotation or 0.0
	
	local transform = {}
	
	setmetatable(transform, Transform)
	
	transform.position = position
	transform.rotation = rotation
	
	return transform
	
end

return Transform