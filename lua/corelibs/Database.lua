local Database = {}

function Database.Connect(database, server, username, password, port)
    _database_connect(database, server, username, password, port or 0)
end

function Database.Query(queryString)
    local results = _database_query(queryString)
    return results
end

return Database