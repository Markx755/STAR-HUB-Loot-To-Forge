# Dependency / Remote Audit — Loot To Forge

Date: 2026-10-22  
Source reviewed: `docs/Loot-To-Forge-source.lua` (copied from uploaded archive)  
Method: static text inspection; no HTTP requests executed, no Roblox session started, no Remote invoked.

## Confirmed external code-loading paths

| Source lines | Evidence | Why it matters | Required action before any execution |
|---|---|---|---|
| 152–159 | `Config.UiSource` points to `https://raw.githubusercontent.com/xDTaraZz/Roblox-Scripts/refs/heads/main/ui.lua` | UI library is fetched at runtime; the content can change independently of this repository. | Pin a reviewed commit/hash and vendor only with permission, or replace with original owned UI code. |
| 164–183 | `Config.ReloadSource` reads local files, otherwise fetches `.../loader.lua`, then uses `loadstring` | A second-stage loader can execute code not present in this source snapshot. | Do not execute during audit; trace and review every stage first. |
| 742–778 | `Util.HttpGet` and `Util.LoadLibrary` fetch, compile and execute the UI source | Downloaded content is executed, not merely displayed. | Remove dynamic execution from a safe Studio implementation. |
| 5128 and 5208 | Calls `https://games.roblox.com/v1/games/%d/servers/Public?...` | External Roblox public-server discovery for session hopping. | Treat as network dependency and verify the intended authorized use. |

## Executor-specific APIs found

Static search found references to `loadstring`, `LPH_JIT`, `identifyexecutor`, `getrenv`, filesystem helpers such as `isfile`/`readfile`, clipboard helpers, and hook APIs. These are not ordinary portable Roblox Studio APIs. Their presence means the original script is not a drop-in Studio LocalScript.

## Remote calls

The source dynamically locates remotes by folder/name (`Util.FindRemote` / `Util.Remote`, lines 691–740) and invokes many `FireServer` / `InvokeServer` calls across forging, selling, gear, stage, training, tower, boss, season, pet, and shop modules. This audit intentionally does not replay or recommend remote payloads. Names and arguments in client code do not establish that the server accepts them or that the operation is authorized.

Examples of consequential operations found by static search:

- Selling: `Sell.Run`, `Sell.All` (around lines 1555–1613).
- Forging / enhancement: `Forge.Run`, `Gear.Enhance*` (around lines 1414–1497 and 1796–1897).
- Pet deletion / grade / crafting: around lines 4367–4729 and 4800 onward.
- Client hooks / damage overrides: `Guard.Hook*` (around lines 3774–4084).
- Noclip / fly and session hopping: movement/session modules around lines 5014–5158.

## Static conclusion

1. The source has mutable external dependencies and second-stage code execution.
2. It depends on executor-only capabilities and therefore cannot be treated as a Studio-ready project.
3. It issues many game remotes, including inventory-changing actions; no runtime behavior or server acceptance is proven here.
4. A safe STAR HUB rewrite should keep the UI/data-display layer separate from game automation, use owned/authorized APIs, avoid client-side hooks and dynamic downloaded execution, and add confirmation/stop controls for destructive actions.

## Not verified

- Whether any URL currently serves the same bytes as when this snapshot was created.
- Whether any remote/function name or argument contract still matches the live game.
- Whether any feature works in a current Roblox session.
- License or permission to republish upstream code.
