mario = require("lua/scripts/mario")

function OnLoad()
    mario.OnLoad()
end

function Update()
    local input = Vector2.new()

    if input.GetKeyState(KeyCode.A) == KeyState.DOWN then
        input.x = -1
    end
    if input.GetKeyState(KeyCode.D) == KeyState.DOWN then
        input.x = input.x + 1
    end

end

Level.OnLoad = OnLoad
Level.Update = Update