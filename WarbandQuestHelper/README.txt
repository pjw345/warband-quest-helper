Warband Quest Helper 1.1.1
==========================

A small Turtle WoW / Vanilla addon designed to be used alongside Warband.
It adds compact commands and profession-based minimap resource icons alongside Warband.

Installation
------------

1. Close World of Warcraft.
2. Extract the ZIP into your client's Interface\AddOns folder.
3. Confirm that the resulting path is:

   Interface\AddOns\WarbandQuestHelper\WarbandQuestHelper.toc

4. Start the client and enable "Warband Quest Helper" on the AddOns screen.

Commands
--------

/wqh       Show or hide the button panel.
/wqh reset Reset the panel to its default position.

Buttons
-------

Accept      /p do accept all quests
Turn In     /p do talk to quest giver
Equip       /p do equip upgrades
Use Object  /p u go
Sell Junk   /p s gray (grey-quality items only)

The addon automatically uses raid chat instead of party chat when you are in
a raid. For quest-giver actions, stand near the NPC and target it first. For
selling, stand near and interact with a suitable vendor first if the bot build
requires the vendor interaction.

Resources button cycles On / Off.
/wqh resources on|off and /botresources provide the same setting.
Requires pfQuest and the matching server resource feed. Icons do not start gathering.
The separate Bot Resource Icons addon should be removed/disabled when using this version.

On shows every supported resource type available from current harvesting skills; no per-type selection is required.
