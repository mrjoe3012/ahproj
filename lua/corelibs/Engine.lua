Engine = _engine_get()
Engine.__index = Engine

Engine.ResetWindow = _engine_resetwindow
Engine.Coroutine = require("lua/corelibs/Coroutine")

function Engine.CallDelayed(delay, func, ...)
    local args = {...}
    Engine.Coroutine.new(function()
        Engine.Coroutine.YieldForSeconds(delay)
        func(table.unpack(args))
    end)
end

function Engine.Quit(code)
    local code = code or 0
    _engine_quit(code)
end

return Engine