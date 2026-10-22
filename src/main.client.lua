-- STAR HUB | Loot To Forge — original UI shell
-- Studio LocalScript. Intended for an experience you own or are authorized to develop.
-- This build contains UI/navigation only: it does not execute downloaded code,
-- call third-party game remotes, or claim upstream automation is implemented.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local COLORS = {
    bg = Color3.fromRGB(15, 18, 27),
    panel = Color3.fromRGB(23, 28, 41),
    panel2 = Color3.fromRGB(30, 36, 52),
    line = Color3.fromRGB(55, 67, 94),
    accent = Color3.fromRGB(104, 139, 255),
    text = Color3.fromRGB(241, 244, 255),
    muted = Color3.fromRGB(158, 169, 193),
    warning = Color3.fromRGB(255, 196, 100),
    good = Color3.fromRGB(115, 220, 174),
}

local function make(className, props, parent)
    local object = Instance.new(className)
    for key, value in pairs(props or {}) do object[key] = value end
    object.Parent = parent
    return object
end

local function round(parent, radius)
    make("UICorner", { CornerRadius = UDim.new(0, radius or 10) }, parent)
end

local old = playerGui:FindFirstChild("STAR_HUB_LootToForge")
if old then old:Destroy() end

local gui = make("ScreenGui", {
    Name = "STAR_HUB_LootToForge",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, playerGui)

local window = make("Frame", {
    Name = "Window",
    Size = UDim2.fromOffset(680, 440),
    Position = UDim2.new(0.5, -340, 0.5, -220),
    BackgroundColor3 = COLORS.bg,
    BorderSizePixel = 0,
}, gui)
round(window, 14)
make("UIStroke", { Color = COLORS.line, Thickness = 1 }, window)

local header = make("Frame", {
    Name = "Header", Size = UDim2.new(1, 0, 0, 58),
    BackgroundColor3 = COLORS.panel, BorderSizePixel = 0,
}, window)
round(header, 14)
-- Cover the lower rounded edge so the header looks integrated with the window.
make("Frame", {
    Size = UDim2.new(1, 0, 0, 14), Position = UDim2.new(0, 0, 1, -14),
    BackgroundColor3 = COLORS.panel, BorderSizePixel = 0,
}, header)

make("TextLabel", {
    Name = "Brand", BackgroundTransparency = 1,
    Position = UDim2.fromOffset(18, 8), Size = UDim2.fromOffset(220, 25),
    Font = Enum.Font.GothamBold, Text = "STAR HUB",
    TextColor3 = COLORS.text, TextSize = 21, TextXAlignment = Enum.TextXAlignment.Left,
}, header)
make("TextLabel", {
    Name = "Subtitle", BackgroundTransparency = 1,
    Position = UDim2.fromOffset(19, 32), Size = UDim2.fromOffset(280, 17),
    Font = Enum.Font.Gotham, Text = "LOOT TO FORGE  /  DEVELOPMENT BUILD",
    TextColor3 = COLORS.muted, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left,
}, header)

local function headerButton(name, label, x, color)
    local button = make("TextButton", {
        Name = name, Size = UDim2.fromOffset(32, 30),
        Position = UDim2.new(1, x, 0, 14),
        BackgroundColor3 = color or COLORS.panel2, BorderSizePixel = 0,
        Font = Enum.Font.GothamBold, Text = label, TextSize = 15,
        TextColor3 = COLORS.text, AutoButtonColor = true,
    }, header)
    round(button, 8)
    return button
end
local minimize = headerButton("Minimize", "—", -78)
local close = headerButton("Close", "×", -40, Color3.fromRGB(115, 54, 66))

local sidebar = make("Frame", {
    Name = "Sidebar", Position = UDim2.fromOffset(12, 70),
    Size = UDim2.new(0, 150, 1, -82), BackgroundColor3 = COLORS.panel,
    BorderSizePixel = 0,
}, window)
round(sidebar, 11)
make("UIPadding", {
    PaddingTop = UDim.new(0, 12), PaddingLeft = UDim.new(0, 9),
    PaddingRight = UDim.new(0, 9),
}, sidebar)
make("UIListLayout", {
    Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder,
}, sidebar)

local content = make("Frame", {
    Name = "Content", Position = UDim2.fromOffset(174, 70),
    Size = UDim2.new(1, -186, 1, -82), BackgroundTransparency = 1,
}, window)

local pages, navButtons = {}, {}
local function makePage(name)
    local page = make("ScrollingFrame", {
        Name = name, Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1, BorderSizePixel = 0,
        ScrollBarThickness = 4, ScrollBarImageColor3 = COLORS.accent,
        CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false,
    }, content)
    make("UIPadding", {
        PaddingTop = UDim.new(0, 2), PaddingLeft = UDim.new(0, 2),
        PaddingRight = UDim.new(0, 8), PaddingBottom = UDim.new(0, 10),
    }, page)
    make("UIListLayout", { Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder }, page)
    pages[name] = page
    return page
end

local function label(parent, text, size, color, height)
    return make("TextLabel", {
        BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, height or 24),
        Font = Enum.Font.GothamSemibold, Text = text,
        TextColor3 = color or COLORS.text, TextSize = size or 15,
        TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true,
    }, parent)
end

local function card(parent, height)
    local frame = make("Frame", {
        Size = UDim2.new(1, -4, 0, height), BackgroundColor3 = COLORS.panel,
        BorderSizePixel = 0,
    }, parent)
    round(frame, 10)
    make("UIPadding", {
        PaddingTop = UDim.new(0, 12), PaddingBottom = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 13), PaddingRight = UDim.new(0, 13),
    }, frame)
    return frame
end

local mainPage = makePage("Main")
local statusCard = card(mainPage, 112)
label(statusCard, "Project status", 16)
local statusText = label(statusCard, "UI loaded · game integration not connected", 12, COLORS.warning, 23)
statusText.Position = UDim2.fromOffset(0, 29)
local gameText = label(statusCard, "Target GameId: 10684750879", 12, COLORS.muted, 20)
gameText.Position = UDim2.fromOffset(0, 56)
local scopeCard = card(mainPage, 112)
label(scopeCard, "Current build", 16)
local scopeText = label(scopeCard, "Navigation, status panels, minimize/close and local stop state are implemented.\nNo game automation or remote calls are connected.", 12, COLORS.muted, 54)
scopeText.Position = UDim2.fromOffset(0, 30)
local stopButton = make("TextButton", {
    Name = "StopAll", Size = UDim2.new(1, -4, 0, 38),
    BackgroundColor3 = Color3.fromRGB(112, 55, 66), BorderSizePixel = 0,
    Font = Enum.Font.GothamBold, Text = "STOP ALL  ·  LOCAL UI STATE",
    TextColor3 = COLORS.text, TextSize = 12,
}, mainPage)
round(stopButton, 9)

local modulesPage = makePage("Modules")
label(modulesPage, "Module inventory", 18, COLORS.text, 30)
label(modulesPage, "These are audit categories, not active controls. They remain disconnected until implementation scope and permissions are confirmed.", 12, COLORS.muted, 42)
local moduleNames = {
    "Forge / Ore selection", "Gear / Enhancement / Selling", "Index / Collection",
    "Stages / Tower / Boss", "Upgrades / Training / Rebirth", "Pets / Eggs / Inventory",
    "Race / Player movement", "Rewards / Season / Shops", "Session / Server navigation",
}
for _, name in ipairs(moduleNames) do
    local row = card(modulesPage, 43)
    label(row, name, 13, COLORS.text, 20)
    local tag = make("TextLabel", {
        AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -1, 0, 1),
        Size = UDim2.fromOffset(96, 20), BackgroundTransparency = 1,
        Font = Enum.Font.GothamSemibold, Text = "AUDIT ONLY",
        TextColor3 = COLORS.warning, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Right,
    }, row)
end

local settingsPage = makePage("Settings")
local settingsCard = card(settingsPage, 126)
label(settingsCard, "Settings", 16)
label(settingsCard, "This build does not save preferences or run background jobs.\nClose destroys the UI; minimize hides the window.\nUse only in an experience you own or are authorized to develop.", 12, COLORS.muted, 70).Position = UDim2.fromOffset(0, 31)

local function showPage(name)
    for pageName, page in pairs(pages) do page.Visible = (pageName == name) end
    for pageName, button in pairs(navButtons) do
        button.BackgroundColor3 = (pageName == name) and COLORS.accent or COLORS.panel2
    end
end

for index, name in ipairs({ "Main", "Modules", "Settings" }) do
    local button = make("TextButton", {
        Name = name .. "Nav", LayoutOrder = index,
        Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = COLORS.panel2,
        BorderSizePixel = 0, Font = Enum.Font.GothamSemibold,
        Text = name, TextColor3 = COLORS.text, TextSize = 13,
    }, sidebar)
    round(button, 8)
    button.Activated:Connect(function() showPage(name) end)
    navButtons[name] = button
end
showPage("Main")

local running = true
stopButton.Activated:Connect(function()
    -- No game jobs are connected in this UI-only milestone.
    running = false
    statusText.Text = "Stopped · no background jobs are connected"
    statusText.TextColor3 = COLORS.good
end)

local minimized = false
minimize.Activated:Connect(function()
    minimized = not minimized
    sidebar.Visible = not minimized
    content.Visible = not minimized
    window.Size = minimized and UDim2.fromOffset(300, 58) or UDim2.fromOffset(680, 440)
end)
close.Activated:Connect(function() gui:Destroy() end)

-- Drag the window from its header. Input handling is local to this UI.
local dragging, dragStart, startPosition
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = window.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        window.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X,
            startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
    end
end)

print("[STAR HUB] UI shell loaded. Game modules are audit-only and are not connected.")
