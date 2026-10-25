Run from the repository root with Lua 5.0.3:

```
lua tests/resources.lua WarbandQuestHelper/ResourceMarkers.lua
lua tests/ui.lua WarbandQuestHelper/ResourceMarkers.lua WarbandQuestHelper/WarbandQuestHelper.lua
```

These execute production code with fake WoW services. They do not certify native
transport, actual minimap artwork or in-game interaction. No client/server is
controlled by the tests. Package with `python tools/package.py output.zip`.

Yellow-dot tests also cover localized known names, honest unknown-object fallback,
yellow tint, hover staying open across draws, recycled marker updates, clearing
owned tooltips while preserving unrelated UI tooltips and forwarding native
minimap clicks without bot commands. Artwork/hover still require in-game acceptance.

Tooltip ownership compatibility (1.2.3): use the Vanilla GameTooltip:IsOwned
method instead of GetOwner. The Lua5.0 fixture deliberately omits GetOwner,
reproduces the original error, and covers clearing owned versus unrelated
tooltips with the supported method. No server change is needed.
