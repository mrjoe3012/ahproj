AudioSource = {}

AudioSource.fallOffDistance = 200.0

local function _update(self)
    _component_update(self)
    _audiosource_update(self)
end

local function _setfile(self, filename)
    _audiosource_setfile(self, filename)
end

local function _getfile(self, filename)
    return _audiosource_getfile(self)
end

local function _play(self)
    _audiosource_play(self)
end

local function _stop(self)
    _audiosource_stop(self)
end

local function _pause(self)
    _audiosource_pause(self)
end

function AudioSource.new(handle)

    local audioSource = Component.new(handle)

    audioSource.GetAudioFile = _getfile
    audioSource.SetAudioFile = _setfile
    audioSource._update = _update

    -- changed properties get modified after updated, this may cause unexpected behaviour
    -- example set audio source to loop in onload, playing it won't loop because loop doesn't get set to true until update
    audioSource.volume = 1.0
    audioSource.fallOffRate = 0.0
    audioSource.isPlaying = false
    audioSource.loop = false

    audioSource.Play = _play
    audioSource.Stop = _stop
    audioSource.Pause = _pause

    return audioSource

end

return AudioSource