-- STAR HUB | Loot To Forge mapping example
-- Use only in a Roblox Studio project you own or are authorized to develop.
-- This file does not download or execute remote scripts.

local SUPPORTED_GAME_ID = 10684750879
local SCRIPT_LABEL = "Loot To Forge"

if game.GameId ~= SUPPORTED_GAME_ID then
    warn(("[STAR HUB] This module is for %s (GameId %d). Current GameId: %d")
        :format(SCRIPT_LABEL, SUPPORTED_GAME_ID, game.GameId))
    return
end

print(("[STAR HUB] Project target confirmed: %s (%d)"):format(SCRIPT_LABEL, game.GameId))
-- Add project-owned functionality below after source and permission review.
