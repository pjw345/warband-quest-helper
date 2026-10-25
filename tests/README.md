Run from the repository root with Lua 5.0.3:

```
lua tests/resources.lua WarbandQuestHelper/ResourceMarkers.lua
lua tests/ui.lua WarbandQuestHelper/ResourceMarkers.lua WarbandQuestHelper/WarbandQuestHelper.lua
```

These execute production code with fake WoW services. They do not certify native
transport, actual minimap artwork or in-game interaction. No client/server is
controlled by the tests. Package with `python tools/package.py output.zip`.
