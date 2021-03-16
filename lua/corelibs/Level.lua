Level = {}
Level.__index = Level

local Coroutine = require("lua/corelibs/Coroutine")

-- TODO: finishing implementing those animation functions, they need to be registered and tested

function Level._updateCall()
    
    _engine_update(Engine)
    _game_update(Game)
    _time_update(Time)
    Time = _time_get()
    _physics_update(Physics)
    _audiosourcestatic_update(AudioSource)
    
    Coroutine.UpdateAll()

    if Level.Update ~= nil then
	   Level.Update()
    end
        
	local actors = Actor._actors
	for _,actor in pairs(actors) do
		actor:_update()
	end

end

function Level._unloadCall()

    if Level.OnUnload ~= nil then
	   Level.OnUnload()
    end
        
	Level.OnLoad = function()end
	Level.OnUnload = function()end
	Level.Update = function()end
	Level.OnQuit = function()end

end

function Level.LoadLevel(levelName)
    
    if levelName == nil then
        error("LoadLevel was called without arguments.")
    end
       
    _level_loadlevel(levelName)
    
end

Level.OnLoad = function()end
Level.OnQuit = function()end

return Level