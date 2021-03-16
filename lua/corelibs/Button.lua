Button = {}

local function _update(self)
    _component_update(self)
    _button_update(self)
end

function Button._onClick(actorHandle, mouseButton)

    local actor = Actor._getActorByHandle(actorHandle)
    local button = actor:GetComponent(ComponentType.Button)

    button.OnClick:Invoke(button, mouseButton)

end

function Button.new(handle)

    local instance = Component.new(handle)

    instance.width = 100
    instance.height = 100
    instance.OnClick = Event.new() -- params: this, mouseButton (int)
    instance._update = _update

    return instance

end

return Button