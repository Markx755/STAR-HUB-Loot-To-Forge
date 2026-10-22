-- STAR HUB | Loot To Forge project starter
-- For Roblox Studio experiences you own or are authorized to develop.
-- This starter intentionally does not execute remote source with loadstring.
-- The original Loot To Forge script is preserved separately in docs for review.

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "STAR_HUB_LootToForge"
screenGui.ResetOnSpawn = false

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(340, 210)
main.Position = UDim2.new(0.5, -170, 0.5, -105)
main.BackgroundColor3 = Color3.fromRGB(22, 25, 34)
main.BorderSizePixel = 0
main.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = main

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(85, 108, 170)
stroke.Thickness = 1
stroke.Parent = main

local title = Instance.new("TextLabel")
title.Name = "Title"
title.BackgroundTransparency = 1
title.Position = UDim2.fromOffset(16, 12)
title.Size = UDim2.new(1, -58, 0, 34)
title.Font = Enum.Font.GothamBold
title.Text = "STAR HUB"
title.TextColor3 = Color3.fromRGB(245, 247, 255)
title.TextSize = 22
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

local gameLabel = Instance.new("TextLabel")
gameLabel.Name = "GameName"
gameLabel.BackgroundTransparency = 1
gameLabel.Position = UDim2.fromOffset(16, 49)
gameLabel.Size = UDim2.new(1, -32, 0, 24)
gameLabel.Font = Enum.Font.GothamSemibold
gameLabel.Text = "Loot To Forge"
gameLabel.TextColor3 = Color3.fromRGB(150, 178, 255)
gameLabel.TextSize = 15
gameLabel.TextXAlignment = Enum.TextXAlignment.Left
gameLabel.Parent = main

local info = Instance.new("TextLabel")
info.Name = "Info"
info.BackgroundTransparency = 1
info.Position = UDim2.fromOffset(16, 82)
info.Size = UDim2.new(1, -32, 0, 58)
info.Font = Enum.Font.Gotham
info.Text = "STAR HUB starter UI\nAdd authorized features for your own experience here."
info.TextColor3 = Color3.fromRGB(190, 197, 212)
info.TextSize = 13
info.TextWrapped = true
info.TextXAlignment = Enum.TextXAlignment.Left
info.TextYAlignment = Enum.TextYAlignment.Top
info.Parent = main

local close = Instance.new("TextButton")
close.Name = "Close"
close.Size = UDim2.fromOffset(82, 30)
close.Position = UDim2.new(1, -98, 1, -44)
close.BackgroundColor3 = Color3.fromRGB(59, 73, 105)
close.BorderSizePixel = 0
close.Text = "Close"
close.TextColor3 = Color3.new(1, 1, 1)
close.Font = Enum.Font.GothamSemibold
close.TextSize = 13
close.Parent = main

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 7)
closeCorner.Parent = close

close.Activated:Connect(function()
    screenGui:Destroy()
end)

screenGui.Parent = player:WaitForChild("PlayerGui")
