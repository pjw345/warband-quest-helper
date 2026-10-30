# Warband Quest Helper

A small Turtle WoW / Vanilla 1.12 addon providing Playerbot quest and inventory buttons alongside the separate WarBand roster addon.

## Installation

1. Download this repository using **Code → Download ZIP**, or clone it.
2. Close the game and copy the `WarbandQuestHelper` directory into your client's `Interface\AddOns` directory.
3. Confirm the path is `Interface\AddOns\WarbandQuestHelper\WarbandQuestHelper.toc` (avoid an extra nested repository directory).
4. Start the client and enable **Warband Quest Helper** on the AddOns screen.

The addon is Lua source loaded by the client; no build or server deployment is needed. WarBand is separate and is not bundled. This helper does not depend on its API, but requires a server supporting the Playerbot commands below.

## Use

`/wqh` shows or hides the panel. `/wqh reset` restores its default position. Drag the panel to move it; the client saves its position and visibility.

| Button | Command sent to party or raid |
| --- | --- |
| Accept | `do accept all quests` |
| Turn In | `do talk to quest giver` |
| Equip | `do equip upgrades` |
| Use Object | `u go` |
| Sell Junk | `s gray` |

For quest actions, stand near and target the quest giver. For selling, stand near and interact with the vendor if required by your server. Commands use ordinary group chat, selecting raid chat when in a raid. The panel reports when you are not grouped.

## Development

Version 1.0.0 was imported from the installed companion addon. This repository records that existing implementation; earlier development history is unavailable.

Edit files under `WarbandQuestHelper/`, then copy them to a test client's matching addon directory. Use `/reload` to reload Lua changes, and restart the client after installation or manifest changes. Check the buttons, party/raid routing, ungrouped feedback, dragging, saved position, visibility and reset in game. Source checks alone do not validate the client UI or server command handling.

Do not commit the client's `WTF` directory, SavedVariables, logs or account information. This project contains only the companion helper, not the original WarBand addon or game assets.

## License

MIT; see [LICENSE](LICENSE).

## Group resource minimap icons (1.1.1)

The helper now includes ore/herb icons from your controlled bots' professions and
trained skill. The **Resources** button cycles On and Off. The
same setting is available through `/wqh resources on|off` and
`/botresources on|off`. Settings share WarbandQuestHelperDB without
changing saved panel position or visibility. Hiding the panel leaves icons active;
choose Off to stop icon polling. Icons do not trigger gathering.

Requires installed pfQuest and matching server RESBOT support (tortoise-wow PR74,
deployed in c6a892a8). Nodes deduplicate across bots, clear after depletion/roster
or zone changes and expire if updates stop. Unknown map coordinates hide icons.
This replaces the separate Bot Resource Icons addon; do not enable that package
alongside this version. Neither Warband itself nor its roster interface is changed.

Restart the client after the manifest update. Lua5.0 tests use a fake WoW UI;
actual game rendering and interaction require separate acceptance.

On shows every supported resource type available from current harvesting skills; no per-type selection is required.
