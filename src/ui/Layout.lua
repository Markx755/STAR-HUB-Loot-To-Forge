local Layout = {}

local function clamp(value, minimum, maximum)
    return math.max(minimum, math.min(value, maximum))
end

function Layout.compute(viewport, minimized, center)
    local availableWidth = math.max(1, viewport.X - 24)
    local availableHeight = math.max(1, viewport.Y - 24)
    local width = minimized and math.min(300, availableWidth) or math.min(680, availableWidth)
    local height = minimized and math.min(58, availableHeight) or math.min(440, availableHeight)
    local centerX = center and center.X or viewport.X / 2
    local centerY = center and center.Y or viewport.Y / 2
    centerX = clamp(
        centerX,
        math.min(viewport.X / 2, width / 2 + 12),
        math.max(viewport.X / 2, viewport.X - width / 2 - 12)
    )
    centerY = clamp(
        centerY,
        math.min(viewport.Y / 2, height / 2 + 12),
        math.max(viewport.Y / 2, viewport.Y - height / 2 - 12)
    )

    return {
        width = width,
        height = height,
        x = centerX - width / 2,
        y = centerY - height / 2,
        compact = viewport.X < 600,
    }
end

return Layout
