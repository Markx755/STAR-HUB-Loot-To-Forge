# UI / Callback Map — Loot To Forge

Date: 2026-10-22  
Method: static source inspection of `docs/Loot-To-Forge-source.lua`; callback targets were read from source, not executed.

The UI builder begins at `BuildInterface()` around line 5,450. It defines shared wrappers (`Action`, `LongAction`, `Toggle`, `Check`, `Pick`, `NumberInput`) and then builds tabs. Most controls write settings into `State.Opt`; buttons dispatch callbacks through the scheduler. This is an architectural map, not a claim that the controls work in the live game.

| Tab / builder | Approx. lines | Areas shown in UI | Examples of callback targets / risks |
|---|---:|---|---|
| Main / `BuildMain` | 5,750 onward | Status, all-in-one mode, rewards, check-in, redeem codes | `Claim.All`, `Claim.CheckIn`, `Claim.AllCodes`; verify each claim path before use. |
| Combat & Stage / combat builder | 5,790–5,890 | Combat, boss, tower, season | `Combat.KillAll`, `Combat.WipeMapNow`, `Stage.ExitFight`, boss/tower/season actions; combat automation and remote calls need authorization review. |
| Spawner & Drops / `BuildSpawn` | 5,893–6,092 | Item/ore spawn, gear spawn, coins, stones, potions, token shop | `Spawn.Give`, stage farming, gear forging, season purchases; source contains actions described as spawning items, which are not proven legitimate or server-accepted. |
| Gear & Forge / `BuildGear` | 6,093–6,237 | Forge, equipment, enhance, sell, index | `Forge.Step`, `Forge.BulkForge`, `Gear.EnhanceToMax`, `Sell.All`, `Index.ClaimAll`; selling and enhancement may irreversibly alter inventory. |
| Pets & Eggs / `BuildPet` | 6,238–6,341 | Hatch, clean bag, deploy, equip, feed, grade/craft | `Pet.HatchStep`, cleanup/deletion, grade-up and rainbow crafting; destructive pet cleanup must never be enabled without safeguards. |
| Train & Rebirth / `BuildProgress` | 6,342–6,407 | Training, click, rebirth, upgrades | `Level.ClickBurst`, `Level.Rebirth`, `Upgrade.BuySelected`; automation and progression remotes are unverified. |
| Player / `BuildPlayer` | 6,408–6,556 | Race, movement, guard controls | Race roll/equip; speed/fly/noclip and damage-related hooks are not suitable for transplanting into a third-party live experience. |
| Settings / `BuildSettings` | 6,557–6,621 | Retry stopped features, session, rejoin, save/return position | `Session.Rejoin`, server hop and movement persistence; check external calls and cleanup behavior. |
| Tab assembly / `BuildTabs` | 6,622 onward | Tab names, descriptions, window assembly | Defines presentation/navigation, but depends on a dynamically fetched UI library earlier in startup. |

## Shared callback flow

1. UI toggle callback writes `opt[key] = value` and may call an `onChange` handler.
2. Button callbacks commonly wrap work with `Action(...)` or `LongAction(...)`.
3. `Action` defers work through `Scheduler.Run` and checks whether the script is alive / action already running.
4. `LongAction` also checks a shared lock and reports completion through UI notifications.
5. The scheduler periodically dispatches enabled jobs and stops tracked threads/connections when `Scheduler.Stop()` runs.

## Safe next implementation slice

Implement a fresh, original UI in an experience the project owner controls, first limited to:
- status labels backed by explicitly available local test data;
- tab/navigation and settings UI;
- cancellation / stop-all lifecycle;
- safe test buttons that do not invoke third-party game remotes.

Do not port `Guard` hooks, noclip/fly, combat overrides, arbitrary spawning, or remote payload automation into an unrelated live game. No UI callbacks in this map are runtime-verified.
