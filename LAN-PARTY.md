# LAN party profiles for AMP 2

The LAN profiles provide native AMP configuration fields. They do not require a separate control panel.

| Template | Role | Default slots |
| --- | --- | --- |
| Counter-Strike: Source LAN | Normal Versus | 16 |
| Counter-Strike: Source LAN GunGame | GunGame with configurable bots and respawns | 16 |
| Call of Duty 4x: Modern Warfare | CoD4x with Bot Warfare controls | 32 |

Configure the server name, host address, game port and desired slot count in AMP.

## Counter-Strike: Source

Use the `Counter-Strike: Source LAN` template for normal Versus and `Counter-Strike: Source LAN GunGame` for the second server. Keeping two instances allows parallel play and independent maps and rules.

Under **LAN Party**, AMP exposes bot enable/disable, bot quota and filling mode, difficulty, team, chatter, weapon classes, round/buy/freeze times, starting money, team balance and map switches. Keep at least one installed map selected.

The prepared instances use an eight-player fill target, normal bot difficulty, and wait for a human player before adding bots. A joining human takes a bot's place. GunGame additionally exposes enable/disable, turbo progression, knife steals, kills per weapon level, warmup, handicap, bot wins and respawn settings.

GunGame 1.2.16.0 is installed from a pinned commit of the author's repository. The small `lan_gungame_respawn` SourceMod plugin handles respawns for humans and bots only while GunGame is enabled, stops doing so after a winner, and leaves Versus unaffected. Its source and compiled plugin are included. `sm_lan_gg_status` in AMP's console reports its state and counters.

GunGame's map configuration executes `lan-party.cfg` last, so upstream defaults cannot silently replace the AMP bot quota and round limits on a later map. The same applies when warmup finishes. Custom maps must already be present on the server before selecting them. The prepared GunGame pool has bot navigation for every enabled map.

### Player map voting

Players can type `nominate` in chat to propose a map from the AMP rotation and `rtv` to request an early map vote. The default threshold is 60% of players after the first 30 seconds. Versus starts its regular vote three minutes before the time limit. GunGame starts its vote when the leader is two weapon levels away from the final level. The winning map becomes the next map. An early RTV changes the map immediately.

The profiles enable SourceMod MapChooser, Nominations and RockTheVote. The vote size, recent-map exclusion, duration and RTV settings are under **LAN Party → Kartenwahl**. The map switches under **Kartenrotation** control both rotation and nominations. Upload each custom BSP and its matching NAV to `cstrike/maps` before enabling that map. Additional Versus switches include `fy_chancellery` and `fy_chateau`. GunGame supports `gg_dust_complex`, `gg_mystic_garden`, `gg_no90_remix`, `gg_tnb_aztec` and `gg_xlighty`.

## CoD4x

The template keeps the supplied `cod4x18_dedrun.exe` and the existing `mods/mp_bots` installation. It does not download, update or validate the game through Steam. Its update stages fetch the LAN configuration templates only; they do not recreate a Wine prefix.

On Windows, the dedicated server starts natively as before. On Linux, the Windows server uses the installed `wine` and `xvfb-run`; the virtual X display is local to this game process and does not listen on TCP. A working 32-bit Wine prefix is required. The matching 32-bit Valve runtime files `steamclient.dll`, `tier0_s.dll` and `vstdlib_s.dll` must be available in the game directory. These proprietary files and game data are not included in this repository. For this installation, the three runtime files came from the owner's existing Steam installation; the original CoD4x EXE hash remained unchanged.

Under **LAN Party**, CoD4x exposes:

- A choice between individual map switches and an advanced custom rotation. All 21 stock/DLC maps in the prepared installation were verified as installed. At least one map must remain selected.
- Bot master switch, population/fill mode, team allocation, team balancing, skill/range/team-specific skill mix, loadout preferences, movement, aim, fire, knife, grenades, objectives, camping, jump/drop shots, bot chat and bot killstreak use.
- Killstreak master switch and individual UAV, airstrike and helicopter switches, permanent UAV and helicopter interval.
- Hardcore, Oldschool, perks, killcam, headshots, friendly fire modes, spectator restrictions, player health, regeneration, sprint duration and map intermission.
- Per-mode point, time, round, life and respawn limits for Deathmatch, Team Deathmatch, Domination, Headquarters, Sabotage and Search & Destroy. Bomb modes also expose timer, planting, defusing and side-switch settings.

The default prepared profile is Team Deathmatch, eight players/bots in total, skill randomized between 2 and 5, automatic team balancing, and the 17-map pool reflected in the map switches. UAV, airstrike, helicopter and bot killstreak use start disabled, matching the earlier local bot configuration. They can be enabled individually in AMP.

The normal CoD4 killstreak thresholds remain 3/5/7. This template does not invent DVARs for changing those hardcoded thresholds. The installed Bot Warfare 2.2.0 also lacks the newer `bots_manage_fill_watchplayers` option; that unsupported option is intentionally not exposed. CoD4 bots start after their configured delay even when the server is empty.

Players who have joined a team can call a vote from the game console. `/callvote map mp_crash` proposes the next map. `/callvote g_gametype sd` proposes Search & Destroy and restarts the current map if it passes. `/callvote typemap dom mp_crash` proposes Domination on Crash for the next map. Use `/vote yes` or `/vote no` to cast a ballot. Votes use maps from the rotation and the six modes `dm war dom koth sab sd`. Abstentions carry zero weight when time expires, so idle bots do not add votes against. [CoD4x vote commands](https://github.com/callofduty4x/CoD4x_Server/blob/master/src/g_sv_cmds.c)

Player-limit and mod arguments are supplied before executing configs and starting the first map. This matters for latched settings such as `sv_maxclients` and `fs_game`.

## Applying changes and retaining them

Game settings and map switches are generated when the game server starts. Save changes in AMP, then restart that game server. A setting marked for restart should not be assumed to change an already running match.

For an existing instance, back up `GenericModule.kvp`, `configmanifest.json`, `metaconfig.json` and the relevant game configs. Install the matching configuration manifest and metaconfig in the instance root and the matching `*.template.*` files in the application's root directory. Restart that AMP instance to load new field definitions. This is separate from restarting the game after changing a value.

For normal future refreshes, the instance's `Meta.ConfigRoot`, `Meta.ConfigManifest`, `Meta.MetaConfigManifest`, `Meta.AppConfigId` and `Meta.OriginalSource` must point at the corresponding LAN template from this repository. A refresh of the old official CSS template would otherwise replace local UI definitions. Refreshing an AMP template is separate from updating the game through its Update button.

## Source references

- [AMP Generic module and configuration manifests](https://github.com/CubeCoders/AMP/wiki/Configuring-the-%27Generic%27-AMP-module)
- [Official CSS AMP template](https://github.com/CubeCoders/AMPTemplates/blob/main/counter-strike-source.kvp)
- [SourceMod required versions](https://wiki.alliedmods.net/Required_Versions_%28SourceMod%29)
- [GunGame author repository and configuration documentation](https://github.com/altexdim/sourcemod-plugin-gungame)
- [Bot Warfare DVAR documentation](https://github.com/ineedbots/iw3_bot_warfare/blob/master/README.md), checked against the actual installed 2.2.0 scripts
- [CoD4x server setup](https://github.com/callofduty4x/CoD4x_Server/wiki/Server-setup)
- [Original CoD4 multiplayer scripts](https://github.com/volkv/CoD4-Default-GSC-Scripts), used to verify game rules and fixed killstreak thresholds
