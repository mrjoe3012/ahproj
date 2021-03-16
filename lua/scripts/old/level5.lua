local rect1, btn1
--TODO
-- FINISH IMPLEMENTING DATABASE (C SIDE AND LUA SIDE)
-- START ACTUAL PROJECT

function onClick(button, mouseButton)
    error(string.format("Clicked button. Width: %d Height: %d MB: %d", button.width, button.height, mouseButton))
end

function OnLoad()
    local actor = Actor.new("rect1")
    rect1 = actor:AddComponent(ComponentType.RectRenderer)
    rect1.width = 200
    rect1.height = 200
    btn1 = actor:AddComponent(ComponentType.Button)
    btn1.width = 200
    btn1.height = 200
    btn1.OnClick:Bind(onClick)
end

function Update()

end

Level.OnLoad = OnLoad
Level.Update = Update