local ConnectionScope = {}

function ConnectionScope.new()
    local connections = {}
    local closed = false
    local scope = {}

    function scope.connect(signal, callback)
        assert(not closed, "Cannot connect a closed connection scope")
        local connection = signal:Connect(function(...)
            if not closed then
                callback(...)
            end
        end)
        table.insert(connections, connection)
        return connection
    end

    function scope.track(connection)
        assert(not closed, "Cannot track a connection in a closed scope")
        table.insert(connections, connection)
        return connection
    end

    function scope.disconnect(connection)
        for index = #connections, 1, -1 do
            if connections[index] == connection then
                table.remove(connections, index)
                if connection.Connected then
                    connection:Disconnect()
                end
                return true
            end
        end
        return false
    end

    function scope.close()
        if closed then
            return false
        end

        closed = true
        for index = #connections, 1, -1 do
            local connection = connections[index]
            if connection.Connected then
                connection:Disconnect()
            end
        end
        for index = #connections, 1, -1 do
            connections[index] = nil
        end
        return true
    end

    function scope.isClosed()
        return closed
    end

    return scope
end

return ConnectionScope
