local Coroutine = {}

Coroutine.coroutines = {}

function Coroutine.new(func)
    table.insert(Coroutine.coroutines, coroutine.create(func))
end
--TODO add error processing, in fact add error processing for all things and try to make
-- the program more robust
function Coroutine.UpdateAll()
    for i,co in ipairs(Coroutine.coroutines) do
        if coroutine.status(co) == "dead" then
            table.remove(Coroutine.coroutines, i)
        elseif coroutine.status(co) == "suspended" then
            res, err = coroutine.resume(co)
            if not res then error(err) end
        end
    end
end

function Coroutine.YieldUntil(condition)
    while not condition() do
        coroutine.yield()
    end
end

function Coroutine.YieldForSeconds(seconds)
    local startTime = Time.time
    Coroutine.YieldUntil(function() return Time.time-startTime >= seconds end)
end

return Coroutine
