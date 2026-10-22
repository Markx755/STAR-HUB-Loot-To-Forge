package.path = "./src/?.lua;" .. package.path

local LoaderCore = require("LoaderCore")
local ModuleRegistry = require("ModuleRegistry")

local failures = {}
local registry = ModuleRegistry.new()
local startCount = 0
local stopCount = 0
local onClose
local shell = {
    start = function(options)
        startCount = startCount + 1
        onClose = options.onClose
        return {
            stop = function()
                stopCount = stopCount + 1
            end,
        }
    end,
}

local registered, registerError = registry.register("Shell", shell)
assert(registered, registerError)
assert(registry.get("Shell") == shell)
assert(not registry.register("Shell", shell), "duplicate registration must be rejected")
assert(not registry.register("Unapproved", shell), "non-allowlisted modules must be rejected")
assert(not registry.register("Shell", {}), "modules without start must be rejected")
assert(#registry.names() == 1 and registry.names()[1] == "Shell")

local loader = LoaderCore.new(registry, function(message)
    table.insert(failures, message)
end)
assert(loader.getState() == "stopped")
assert(loader.initialize())
assert(loader.initialize(), "initialization must be idempotent")
assert(startCount == 1, "duplicate initialization must not start the UI twice")
assert(loader.isModuleRunning("Shell"))
assert(loader.getState() == "running")
assert(not loader.startModule("Unapproved"), "unregistered modules must not start")
assert(#failures == 1, "start failures must be reported")

local firstOnClose = onClose
firstOnClose()
assert(not loader.isModuleRunning("Shell"), "UI close must clear loader state")
assert(loader.getState() == "stopped")
assert(loader.initialize(), "loader must be restartable after UI close")
assert(startCount == 2)
local secondOnClose = onClose
firstOnClose()
assert(loader.isModuleRunning("Shell"), "a stale close must not stop a newer instance")
assert(loader.stopModule("Shell"))
secondOnClose()
assert(stopCount == 1, "module cleanup must run exactly once")
assert(loader.stopModule("Shell"), "stopping an inactive module must be safe")
assert(loader.getState() == "stopped")

local reentrantRegistry = ModuleRegistry.new()
local reentrantStartCount = 0
local reentrantStopCount = 0
local reentrantLoader
assert(reentrantRegistry.register("Shell", {
    start = function(options)
        reentrantStartCount = reentrantStartCount + 1
        local nestedStarted, nestedMessage = reentrantLoader.initialize()
        assert(nestedStarted and nestedMessage == "already started")
        options.onClose()
        return {
            stop = function()
                reentrantStopCount = reentrantStopCount + 1
            end,
        }
    end,
}))
reentrantLoader = LoaderCore.new(reentrantRegistry, function(message)
    table.insert(failures, message)
end)
assert(reentrantLoader.initialize())
assert(reentrantStartCount == 1, "reentrant initialization must not start twice")
assert(reentrantStopCount == 1, "a module closed during startup must be cleaned up")
assert(not reentrantLoader.isModuleRunning("Shell"))
assert(reentrantLoader.getState() == "stopped")

local brokenRegistry = ModuleRegistry.new()
assert(brokenRegistry.register("Shell", {
    start = function()
        error("expected startup failure")
    end,
}))
local brokenLoader = LoaderCore.new(brokenRegistry, function(message)
    table.insert(failures, message)
end)
local started, startupError = brokenLoader.initialize()
assert(not started and startupError:find("expected startup failure"))
assert(brokenLoader.getState() == "stopped")
assert(#failures == 2, "startup errors must be reported")

local stopFailureRegistry = ModuleRegistry.new()
assert(stopFailureRegistry.register("Shell", {
    start = function()
        return {
            stop = function()
                error("expected cleanup failure")
            end,
        }
    end,
}))
local stopFailureLoader = LoaderCore.new(stopFailureRegistry, function(message)
    table.insert(failures, message)
end)
assert(stopFailureLoader.initialize())
local stopped, stopError = stopFailureLoader.stop()
assert(not stopped and stopError:find("expected cleanup failure"))
assert(stopFailureLoader.getState() == "stopped")
assert(#failures == 3, "cleanup errors must be reported")

print("loader_spec.lua: all checks passed")
