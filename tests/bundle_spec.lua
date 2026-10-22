local bundleFile = assert(io.open("dist/star-hub.lua", "r"), "built bundle is missing")
local bundle = bundleFile:read("*a")
bundleFile:close()

assert(not bundle:find("script.Parent", 1, true), "bundle must not depend on script.Parent")
assert(not bundle:find("loadstring", 1, true), "bundle must not execute dynamic source")
assert(not bundle:find("http://", 1, true), "bundle must not contain external URLs")
assert(not bundle:find("https://", 1, true), "bundle must not contain external URLs")
assert(bundle:find("local Shell =", 1, true), "UI module must be included in the bundle")
assert(bundle:find("local ModuleRegistry =", 1, true), "registry must be included in the bundle")
assert(bundle:find("local LoaderCore =", 1, true), "loader core must be included in the bundle")
assert(bundle:find("duplicate initialization skipped", 1, true), "bundle must guard duplicate starts")

local result = os.execute("python3 tools/build_bundle.py --check")
assert(result == true or result == 0, "bundle must be reproducible from current sources")

print("bundle_spec.lua: all checks passed")
