# STAR HUB — Loot To Forge Starter

This repository provides a safe-by-default Roblox Studio starter for the experience `Loot To Forge` (GameId `10684750879`).

The project is intentionally limited to review-safe source handling and a minimal UI example. It does not silently execute remote scripts or load upstream source files automatically.

## Purpose

Use this repository as a clean starting point when you want:
- a minimal STAR HUB UI example,
- a game-id guard for the correct experience,
- preserved upstream source for review without auto-execution,
- a safe onboarding pattern for authorized local development.

## Repository layout

- `src/main.client.lua` — minimal STAR HUB UI example.
- `src/game_check.client.lua` — confirms the current game matches `10684750879` before proceeding.
- `docs/Loot-To-Forge-source.lua` — preserved copy of the original script for review only.
- `docs/ui.lua.upstream-copy` — upstream UI copy retained for audit/review.
- `docs/ui_v2.lua.upstream-copy` — second upstream UI copy retained for audit/review.
- `docs/SOURCE_AUDIT.md` — static source review notes and caveats.
- `LICENSE-REVIEW-REQUIRED.md` — caution about redistributing original source without confirmed license permission.
- `README.md` — project overview and usage notes.

## Safe usage rules

This starter deliberately does not:
- download code from remote URLs,
- run `loadstring` or similar dynamic execution,
- auto-run preserved upstream files.

The scripts are intended for use in a Roblox Studio experience you own or are explicitly authorized to modify.

## Source review and licensing caution

The source archive referenced in this repository did not include a LICENSE file. Public availability alone does not establish permission to redistribute or modify someone else's source.

Before publishing or reusing upstream code, verify:
1. you have the right to redistribute it,
2. the original license allows modification or sharing,
3. you are not violating the original author or game developer terms.

See `LICENSE-REVIEW-REQUIRED.md` for the cautionary guidance.

## Local setup

1. Open the project in Roblox Studio.
2. Place the scripts in an experience you own or are authorized to develop.
3. Use `src/main.client.lua` as a starter UI reference.
4. Use `src/game_check.client.lua` to ensure the experience matches the intended game.
5. Keep all preserved upstream copies in `docs/` and review them before any production use.

## Testing status

This package is a static starter and source-review project.
- No live Roblox runtime validation was performed here.
- It is not an assertion that the original upstream code is safe or functional.

## Recommended workflow

- review source under `docs/` before building gameplay automation,
- keep your production code separate from preserved upstream copies,
- avoid automatic remote execution entirely,
- keep the project limited to game ownership or explicit authorization.
