package.path = "./src/?.lua;./src/ui/?.lua;" .. package.path

local Layout = require("Layout")

local desktop = Layout.compute({ X = 1920, Y = 1080 }, false)
assert(desktop.width == 680 and desktop.height == 440)
assert(desktop.x == 620 and desktop.y == 320)
assert(not desktop.compact)

local phone = Layout.compute({ X = 390, Y = 844 }, false)
assert(phone.width == 366 and phone.height == 440)
assert(phone.x == 12 and phone.y == 202)
assert(phone.compact)

local minimized = Layout.compute({ X = 390, Y = 844 }, true, { X = 195, Y = 422 })
assert(minimized.width == 300 and minimized.height == 58)
assert(minimized.x == 45 and minimized.y == 393)

local small = Layout.compute({ X = 280, Y = 240 }, false, { X = 0, Y = 0 })
assert(small.width == 256 and small.height == 216)
assert(small.x == 12 and small.y == 12)

print("layout_spec.lua: all checks passed")
