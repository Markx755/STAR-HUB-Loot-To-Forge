local Loader = require(script.Parent.Loader)
local LoaderCore = require(script.Parent.LoaderCore)
local ModuleRegistry = require(script.Parent.ModuleRegistry)
local Shell = require(script.Parent.ui.Shell)

return Loader({
    LoaderCore = LoaderCore,
    ModuleRegistry = ModuleRegistry,
    modules = {
        Shell = Shell,
    },
})
