package.path = "./src/?.lua;./src/ui/?.lua;" .. package.path

local ConnectionScope = require("ConnectionScope")

local function signal()
    local listeners = {}
    return {
        Connect = function(_, callback)
            local connection = {
                Connected = true,
                DisconnectCount = 0,
            }
            function connection:Disconnect()
                if self.Connected then
                    self.Connected = false
                    self.DisconnectCount = self.DisconnectCount + 1
                end
            end
            listeners[#listeners + 1] = { connection = connection, callback = callback }
            return connection
        end,
        Fire = function(_, ...)
            for _, listener in ipairs(listeners) do
                if listener.connection.Connected then
                    listener.callback(...)
                end
            end
        end,
    }
end

local scope = ConnectionScope.new()
local event = signal()
local calls = 0
local connection = scope.connect(event, function(value)
    calls = calls + value
end)
event:Fire(1)
assert(calls == 1)

assert(scope.disconnect(connection))
assert(not scope.disconnect(connection), "a disconnected connection must not be disconnected twice")
assert(connection.DisconnectCount == 1)

local second = scope.track(event:Connect(function()
    calls = calls + 10
end))
local third = scope.track(event:Connect(function()
    calls = calls + 100
end))
assert(scope.close())
assert(not scope.close(), "closing the scope twice must be idempotent")
assert(scope.isClosed())
assert(second.DisconnectCount == 1 and third.DisconnectCount == 1)
event:Fire(10)
assert(calls == 1, "closed scopes must not dispatch callbacks")

print("connection_scope_spec.lua: all checks passed")
