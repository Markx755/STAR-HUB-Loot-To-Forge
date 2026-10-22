local Loader = require(script.Parent.Loader)
local LoaderCore = require(script.Parent.LoaderCore)
local ModuleRegistry = require(script.Parent.ModuleRegistry)
local Layout = require(script.Parent.ui.Layout)
local ConnectionScope = require(script.Parent.ui.ConnectionScope)
local Shell = require(script.Parent.ui.Shell)

return Loader({
    LoaderCore = LoaderCore,
    ModuleRegistry = ModuleRegistry,
    shellOptions = {
        Layout = Layout,
        ConnectionScope = ConnectionScope,
    },
    modules = {
        Shell = Shell,
    },
})
