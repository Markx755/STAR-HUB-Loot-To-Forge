# STAR HUB — Loot To Forge (GameId 10684750879)

This repository starter is scoped to **one game only: Loot To Forge**.

## Files

- `src/main.client.lua` — new, minimal STAR HUB UI example for Roblox Studio.
- `src/game_check.client.lua` — checks that the current experience's `game.GameId` matches `10684750879`; it does not load remote code.
- `docs/Loot-To-Forge-source.lua` — byte-preserved copy of the original `All Map/Loot To Forge.lua` from the uploaded ZIP, included for source review only.
- `docs/ui.lua.upstream-copy` and `docs/ui_v2.lua.upstream-copy` — byte-preserved UI library copies from the archive for review, not automatically executed.
- `.github/compat_check.py` and `.github/workflows/luau-check.yml` — copied compatibility-check files from the archive when present.
- `docs/SOURCE_AUDIT.md` — findings and caveats.

## Important source/licensing notes

The source archive's file listing did not include a LICENSE file. Public availability alone does not establish permission to republish or modify someone else's code. Before making this repository public, verify the upstream license/permission. If permission is unclear, remove the upstream copies under `docs/` and use only original code you own or have permission to use.

This starter deliberately does not include the original generic loader or auto-execution behavior, and does not claim that the original game automation has been preserved as a working feature set. The original game script is kept as a byte-preserved review artifact so it can be audited before any permitted adaptation.

## Upload to GitHub

1. Download and extract this ZIP.
2. Create a GitHub repository named `STAR-HUB-Loot-To-Forge`.
3. Upload the contents of this folder (not the ZIP file nested inside).
4. Review `LICENSE-REVIEW-REQUIRED.md` before public release.
5. Open the project in Roblox Studio and test the new UI in an experience you own or are authorized to develop.

## Testing status

The package ZIP integrity was checked. No Roblox runtime test was performed; this does not prove the scripts run correctly in Roblox.
