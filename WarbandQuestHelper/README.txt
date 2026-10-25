Warband Quest Helper 1.0.0
==========================

A small Turtle WoW / Vanilla addon designed to be used alongside Warband.
It contains no MangosBot roster, controls, quest polling or debug messages.

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
