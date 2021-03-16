KeyCode = {}

for k,v in  pairs(_get_keycodes()) do

	KeyCode[k] = v

end

function KeyCode.__index(table, key)
	local val = rawget(table, key)
	if not val then error(string.format("Attempted to index invalid keycode '%s'", key)) end
	return val
end

setmetatable(KeyCode, KeyCode)

return KeyCode