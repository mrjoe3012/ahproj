local InputField = {}

InputField.selected = nil

local characters = {
    "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"
}
local numbers = {
    N1="1",N2="2",N3="3",N4="4",N5="5",N6="6",N7="7",N8="8",N9="9",N0="0"
}

local function onClick(inputField, mouseButton)
    if mouseButton == 0 then
        InputField.selected = inputField
    end
end

function InputField.new(name, tag)
    local instance = {}
    instance.limit = nil
    instance.actor = Actor.new(name, tag)
    instance.textRenderer = instance.actor:AddComponent(ComponentType.TextRenderer)
    instance.allowSpaces = true
    instance.OnClick = function(button, mouseButton)
        onClick(instance, mouseButton)
    end
    return instance
end

function InputField.OnLoad()
    InputField.selected = nil
end

function InputField.Update()
    if InputField.selected and (InputField.selected.limit or math.huge) > #InputField.selected.textRenderer.text then

        if Input.GetKeyState(KeyCode.Backspace) == KeyState.Released and #InputField.selected.textRenderer.text > 0 then
            InputField.selected.textRenderer.text = string.sub(InputField.selected.textRenderer.text,1,-2)
            lastInput = Time.time
        end

        if Input.GetKeyState(KeyCode.Space) == KeyState.Released and allowSpaces then
            InputField.selected.textRenderer.text = InputField.selected.textRenderer.text.." "
            lastInput = Time.time
        end

        for _,character in pairs(characters) do
            if Input.GetKeyState(KeyCode[character]) == KeyState.Released and Input.GetKeyState(KeyCode.LeftShift) == KeyState.Down then
                InputField.selected.textRenderer.text = InputField.selected.textRenderer.text..character
                lastInput = Time.time
            elseif Input.GetKeyState(KeyCode[character]) == KeyState.Released then
                InputField.selected.textRenderer.text = InputField.selected.textRenderer.text..string.lower(character)
                lastInput = Time.time
            end
        end

        for keycode,character in pairs(numbers) do
            if Input.GetKeyState(KeyCode[keycode]) == KeyState.Released then
                InputField.selected.textRenderer.text = InputField.selected.textRenderer.text..character
                lastInput = Time.time
            end
        end

    elseif InputField.selected then
        if Input.GetKeyState(KeyCode.Backspace) == KeyState.Released and #InputField.selected.textRenderer.text > 0 then
            InputField.selected.textRenderer.text = string.sub(InputField.selected.textRenderer.text,1,-2)
            lastInput = Time.time
        end
    end
end

return InputField