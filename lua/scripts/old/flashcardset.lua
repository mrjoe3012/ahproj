local set = {}

function set.fromCsv(path)

    local instance = {}

    setmetatable(instance, set)

    f = io.open(path, "r")
    io.input(f)
    for line in io.lines() do
        local sepIndex = string.find(line, ",")
        local q = string.sub(line, 1, sepIndex-1)
        local a = string.sub(line, sepIndex+1, #line)
        table.insert(instance, {q=q,a=a})
    end

    io.close()

    return instance

end

return set