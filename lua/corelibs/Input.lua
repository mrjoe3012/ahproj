Input = {}
Input.__index = Input

function Input.GetKeyState(keycode)

	local holding = _input_keyheld(keycode)
	
	if holding == true then
	
		return KeyState.Down
	
	end
	
	local released = _input_keyreleased(keycode)

	if released == true then
	
		return KeyState.Released
	
	end

	return KeyState.Up

end

function Input.AnyKeyDown()
	
	return _input_anykeydown()
	
end

function Input.AnyKeyReleased()
	
	return _inpur_anykeyreleased()
	
end

return Input