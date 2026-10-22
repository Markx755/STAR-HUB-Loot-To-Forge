local ModuleRegistry = {}

local ALLOWED_MODULES = {
    Shell = true,
}

function ModuleRegistry.new()
    local modules = {}

    return {
        register = function(name, module)
            if type(name) ~= "string" or not ALLOWED_MODULES[name] then
                return false, "Module is not allowlisted: " .. tostring(name)
            end
            if modules[name] then
                return false, "Module is already registered: " .. name
            end
            if type(module) ~= "table" or type(module.start) ~= "function" then
                return false, "Module must provide a start function: " .. name
            end

            modules[name] = module
            return true
        end,
        get = function(name)
            return modules[name]
        end,
        names = function()
            local names = {}
            for name in pairs(modules) do
                table.insert(names, name)
            end
            table.sort(names)
            return names
        end,
    }
end

return ModuleRegistry
