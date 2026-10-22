return function(dependencies)
    assert(type(dependencies) == "table", "Loader dependencies are required")
    assert(type(dependencies.LoaderCore) == "table", "LoaderCore is required")
    assert(type(dependencies.ModuleRegistry) == "table", "ModuleRegistry is required")

    local registry = dependencies.ModuleRegistry.new()
    for name, module in pairs(dependencies.modules or {}) do
        local registered, registrationError = registry.register(name, module)
        if not registered then
            error(registrationError, 2)
        end
    end

    local loader = dependencies.LoaderCore.new(registry)
    local initialized, initializationError = loader.initialize()
    if not initialized then
        error("STAR HUB initialization failed: " .. tostring(initializationError), 2)
    end
    return loader
end
