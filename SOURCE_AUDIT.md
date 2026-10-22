# Source audit — Loot To Forge (GameId 10684750879)

## Scope
Source archive: `Roblox-Scripts-main.zip` supplied in this conversation.
Game file: `Roblox-Scripts-main/All Map/Loot To Forge.lua`.
Game script size: 292,408 bytes; line count: 6,715.
This report describes static inspection only.

## Verified facts
- The archive includes a file named `All Map/Loot To Forge.lua`.
- The Loader mapping supplied in the conversation maps GameId `10684750879` to `Loot To Forge`.
- The source game script contains 5 URL-like string(s), 3 occurrence(s) of `loadstring`, 0 occurrence(s) of the word `webhook` (case-insensitive), and 272 text match(es) beginning with `Auto` (a textual count, not a verified feature count).
- This package preserves the original game script bytes at `docs/Loot-To-Forge-source.lua`; it does not silently rewrite it.
- This package adds a new independent UI example at `src/main.client.lua`; it is not a replacement for all original automation functions.

## URL-like strings extracted from the game script
- `https://discord.gg/FHVfmeSceA`
- `https://raw.githubusercontent.com/xDTaraZz/Roblox-Scripts/refs/heads/main/ui.lua`
- `https://raw.githubusercontent.com/xDTaraZz/Roblox-Scripts/refs/heads/main/loader.lua`
- `https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100`
- `https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100`

## Important limitations
- This was static source inspection, not execution in Roblox.
- A text match for `Auto`, `webhook`, or `loadstring` does not prove that a feature is active or that the script is malicious.
- The source ZIP listing did not show a LICENSE file; redistribution rights remain unverified.
- No claim is made that the original automation works with the current live game.
