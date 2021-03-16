Vector2 = {}
Vector2.__index = {}

function Vector2.new(x,y)
	
	x = x or 0
	y = y or 0
	
	local vector2 = {}
	
	setmetatable(vector2, Vector2)
	
	vector2.x = x
	vector2.y = y
	
    vector2.SquareMagnitude = Vector2.SquareMagnitude
    vector2.Normalized = Vector2.Normalized
    vector2.Magnitude = Vector2.Magnitude
    
	return vector2
	
end

function Vector2.copy(v)
   
    return Vector2.new(v.x, v.y)
    
end

function Vector2:SquareMagnitude()

	local sqrmag = self.x^2 + self.y^2

	return sqrmag

end

function Vector2:Magnitude()

	local sqrmag = self:SquareMagnitude()

	local mag = math.sqrt(sqrmag)

	return mag

end

function Vector2:Normalized()

	local mag = self:Magnitude()

	local normalized = (1/mag)*self

	return normalized

end

function Vector2.__add(lhs, rhs)

	local result = Vector2.new(lhs.x+rhs.x, lhs.y+rhs.y)

	return result

end

function Vector2.__sub(lhs, rhs)

	local result = Vector2.new(lhs.x-rhs.x, lhs.y-rhs.y)

	return result

end

function Vector2.__mul(lhs, rhs)

	local number = nil
	local vector = nil

	if type(lhs) == "table" then vector = lhs end
	if type(lhs) == "number" then number = lhs end
	if type(rhs) == "table" then vector = rhs end
	if type(rhs) == "number" then number = rhs end

    if (number == nil or vector == nil) then
		error("Invalid parameters for multiplication.")
	end
	
	local result = Vector2.new()
	
	result.x = number*vector.x
	result.y = number*vector.y
	
	return result
	
end

function Vector2.__div(lhs, rhs)

	local number = nil
	local vector = nil

	if type(lhs) == "table" then vector = lhs end
	if type(lhs) == "number" then number = lhs end
	if type(rhs) == "table" then vector = rhs end
	if type(rhs) == "number" then number = rhs end

	if (number == nil or vector == nil) then
		error("Invalid parameters for division.")
	end

	local result = Vector2.new()

	result.x = vector.x/number
	result.y = vector.y/number

	return result

end

Vector2.Up = Vector2.new(0,1)
Vector2.Right = Vector2.new(1,0)

return Vector2