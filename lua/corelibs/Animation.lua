Animation = {}

local function _update(self)
    _component_update(self)
    _animation_update(self)
end

local function _getAnimCount(self)
    return _animation_getcount(self)
end

local function _getAnim(self, index)
    return (index >= 1 and index <= _getAnimCount(self)) and _animation_getanim(self, index) or nil
end

local function _removeAnim(self, index)
    return (index >= 1 and index <= _getAnimCount(self)) and _animation_removeanim(self, index) or nil
end

local function _addAnim(self, animTable)
    _animation_addanim(self, animTable)
end

local function getAnims(self)
    local animList = {}
    local count = _getAnimCount(self)
    for i=1,count,1 do
        table.insert(animList, _getAnim(self, i))
    end
    return animList
end

function Animation.new(handle)

    local animation = Component.new(handle)

    animation.GetAnims = _getAnims
    animation.AddAnim = _addAnim
    animation.RemoveAnim = _removeAnim
    animation.GetAnimCount = _getAnimCount

    animation.animationIndex = 1

    animation._update = _update

    return animation

end

return Animation