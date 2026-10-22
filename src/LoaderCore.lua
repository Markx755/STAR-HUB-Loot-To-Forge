local LoaderCore = {}

local function defaultLogger(message)
    if type(warn) == "function" then
        warn(message)
    else
        print(message)
    end
end

function LoaderCore.new(registry, logger)
    assert(type(registry) == "table", "A module registry is required")
    assert(type(registry.get) == "function", "The registry must provide get")

    local activeModules = {}
    local activeGenerations = {}
    local startingModules = {}
    local nextGeneration = 0
    local state = "stopped"
    local log = logger or defaultLogger

    local function reportError(operation, name, message)
        local text = ("[STAR HUB] Failed to %s module %q: %s")
            :format(operation, name, tostring(message))
        log(text)
    end

    local function updateState()
        if next(activeModules) then
            state = "running"
        elseif next(startingModules) then
            state = "starting"
        else
            state = "stopped"
        end
    end

    local loader = {}

    function loader.registerModule(name, module)
        if type(registry.register) ~= "function" then
            return false, "The registry does not support registration"
        end
        return registry.register(name, module)
    end

    function loader.startModule(name, options)
        if activeModules[name] or startingModules[name] then
            return true, "already started"
        end

        local module = registry.get(name)
        if not module then
            local message = "Module is not registered"
            reportError("start", name, message)
            return false, message
        end
        if type(module.start) ~= "function" then
            local message = "Module does not provide a start function"
            reportError("start", name, message)
            return false, message
        end

        local moduleOptions = {}
        for key, value in pairs(options or {}) do
            moduleOptions[key] = value
        end

        nextGeneration = nextGeneration + 1
        local generation = nextGeneration
        local closedDuringStart = false
        startingModules[name] = generation
        updateState()

        local onClose = moduleOptions.onClose
        moduleOptions.onClose = function(...)
            if activeGenerations[name] == generation then
                activeModules[name] = nil
                activeGenerations[name] = nil
                updateState()
            elseif startingModules[name] == generation then
                closedDuringStart = true
            end
            if onClose then
                onClose(...)
            end
        end

        local ok, handle, startError = pcall(module.start, moduleOptions)
        startingModules[name] = nil
        if not ok then
            updateState()
            reportError("start", name, handle)
            return false, tostring(handle)
        end
        if type(handle) ~= "table" or type(handle.stop) ~= "function" then
            updateState()
            local message = startError or "Module start must return a handle with stop"
            reportError("start", name, message)
            return false, tostring(message)
        end

        if closedDuringStart then
            local stopOk, stopError = pcall(handle.stop)
            updateState()
            if not stopOk then
                reportError("stop", name, stopError)
                return false, tostring(stopError)
            end
            return true, "closed during startup"
        end

        activeModules[name] = handle
        activeGenerations[name] = generation
        updateState()
        return true
    end

    function loader.stopModule(name)
        local handle = activeModules[name]
        if not handle then
            return true, "not started"
        end

        activeModules[name] = nil
        activeGenerations[name] = nil
        updateState()
        local ok, stopError = pcall(handle.stop)
        if not ok then
            reportError("stop", name, stopError)
            return false, tostring(stopError)
        end
        return true
    end

    function loader.initialize()
        if activeModules.Shell then
            return true, "already initialized"
        end
        return loader.startModule("Shell")
    end

    function loader.stopAll()
        local names = {}
        for name in pairs(activeModules) do
            table.insert(names, name)
        end
        table.sort(names)

        local succeeded = true
        local errors = {}
        for _, name in ipairs(names) do
            local ok, message = loader.stopModule(name)
            if not ok then
                succeeded = false
                table.insert(errors, name .. ": " .. tostring(message))
            end
        end
        return succeeded, table.concat(errors, "; ")
    end

    function loader.stop()
        return loader.stopAll()
    end

    function loader.getState()
        return state
    end

    function loader.isModuleRunning(name)
        return activeModules[name] ~= nil
    end

    return loader
end

return LoaderCore
