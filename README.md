# STAR HUB — Loot To Forge (GameId 10684750879)

This repository starter is scoped to **one game only: Loot To Forge**.

## Files

- `src/main.client.lua` — Studio entry point that wires the allowlisted UI module into the loader.
- `src/ui/Shell.lua` — original UI shell with draggable window, Main/Modules/Settings tabs, minimize/close, module audit labels, and local stop-state button. Game automation is not connected.
- `src/Loader.lua`, `src/LoaderCore.lua`, and `src/ModuleRegistry.lua` — dependency-injected loader, lifecycle/error handling, and the project module allowlist.
- `src/game_check.client.lua` — checks that the current experience's `game.GameId` matches `10684750879`; it does not load remote code.
- `tools/build_bundle.py` — deterministic builder for the standalone `dist/star-hub.lua` LocalScript.
- `tests/loader_spec.lua` and `tests/bundle_spec.lua` — Lua lifecycle and bundle checks.
- `dist/star-hub.lua` — generated single-file build; it has no ModuleScript dependencies or downloaded code.
- `docs/Loot-To-Forge-source.lua` — byte-preserved copy of the original `All Map/Loot To Forge.lua` from the uploaded ZIP, included for source review only.
- `docs/ui.lua.upstream-copy` and `docs/ui_v2.lua.upstream-copy` — byte-preserved UI library copies from the archive for review, not automatically executed.
- `.github/compat_check.py` and `.github/workflows/luau-check.yml` — copied compatibility-check files from the archive when present.
- `docs/SOURCE_AUDIT.md` — initial findings and caveats.
- `docs/FUNCTION_INVENTORY.md` — static inventory of source function groups.
- `docs/DEPENDENCY_AND_REMOTE_AUDIT.md` — external code-loading paths, executor-only APIs, and remote-call risks.
- `docs/UI_CALLBACK_MAP.md` — UI tabs and representative callback flow.
- `docs/NEXT_IMPLEMENTATION.md` — implementation gates and evidence boundary.

## Important source/licensing notes

The source archive's file listing did not include a LICENSE file. Public availability alone does not establish permission to republish or modify someone else's code. Before making this repository public, verify the upstream license/permission. If permission is unclear, remove the upstream copies under `docs/` and use only original code you own or have permission to use.

This starter deliberately does not include the original generic loader or auto-execution behavior, and does not claim that the original game automation has been preserved as a working feature set. The additional audit documents are static-review notes, not runtime validation. The original game script is kept as a byte-preserved review artifact so it can be audited before any permitted adaptation.

## Build and test

From the repository root, run:

```sh
python3 tools/build_bundle.py
python3 tools/build_bundle.py --check
lua tests/loader_spec.lua
lua tests/bundle_spec.lua
```

The bundle is a Roblox LocalScript, while the Lua specs are standalone scripts that exercise the loader with test modules. Roblox Studio testing is still needed to verify actual UI behavior in an experience you own or are authorized to develop.

## Upload to GitHub

Review `LICENSE-REVIEW-REQUIRED.md` before public release. The audit artifacts under `docs/` are not runtime validation, and this project does not claim that upstream automation has been implemented.
