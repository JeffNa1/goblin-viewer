# Rootbound Sanctum B — All Rooms Art Review

## Scope

This pass builds the remaining 13 voxel room treatments and assembles all 14 original room footprints with the original 15 connections. The approved Quiet Sanctuary source remains unchanged and supplies the shared art primitives. The art viewer lives separately from the original map and character viewer.

This is an environment-art review, not a combat build. The red figure is a scale proxy, not the production player. No character scripts or character assets are loaded by this art scene.

## Open in the existing project

Run `Rootbound_Sanctum/Art_Dungeon/Open_All_Rooms.bat` from the existing goblin-viewer project. Allow the room geometry to finish building.

The launcher uses the installed Godot executable at `%USERPROFILE%\.gemini\antigravity\bin\godot.exe`, with `godot` on PATH as its fallback. It selects Forward+ without changing `project.godot`.

Use the room dropdown or Left/Right to change rooms. Press 1 for close shoulder, 2 for eye level, 3 for overview, M for the connected layout, and H to hide or show the interface. The individual-room views hide the other rooms for visual review. The map view shows the full assembly.

There is no walking controller, mouse-look exploration, enemy encounter, shop interaction, cache unlock, or boss-clear exit condition in this art viewer.

## Room identities

| Room | Art treatment |
|---|---|
| 01 Boat Landing | Lantern dock, carved river skiff, stepped river edge |
| 02 Sluice Gate | Bronze wheel, raised watergate, stone gate supports |
| 03 Root Court | Ancient root island, branching canopy, carved heraldry |
| 04 Barracks | Double bunks, weapon racks, worn company banners |
| 05 Ember Smithy | Open ember furnace, chimney, anvil and trading counter |
| 06 Hunter Cloister | Hunter effigies, broken garden colonnade, overgrown court |
| 07 Quiet Sanctuary | Approved heartwood fountain and sanctuary dressing |
| 08 Flooded Archive | Book galleries and an open, low-parapet water court |
| 09 Blood Vault | Blood obelisks, hanging banners, clear ritual circle |
| 10 Sealed Spoils | Bronze reliquary beneath a gilded apse |
| 11 Choir Hall | Pipe organ, hanging lights, clear ceremonial nave |
| 12 Spore Grotto | Giant mushroom canopies and an open boss arena |
| 13 Hidden Cache | Relic chest and overgrown crypt niches |
| 14 Ascent | Dogleg stairs and a luminous upper threshold |

## Review files

`Review/Gallery.html` is a local browser gallery. Keep it with the adjacent Renders and Review folders. Each room card opens a sheet with all three camera views.

`Review/All_Rooms.png` shows the full room set. `Renders/map_overview.png` shows the connected assembly.

The final capture manifest contains 43 distinct 1600 x 900 images: 39 captures for the 13 new rooms, three captures of the sanctuary in the new assembly, and one connected-map overview. These are real Godot Forward+ captures on an NVIDIA GeForce GTX 1660 SUPER, not reference images or generated illustrations.

`References/Reference_Board.png` and its accompanying source ledger are copied from the approved reference study. They remain labeled as external source artwork and are not project renders. No source models or textures are copied into the art geometry.

## Checks and limits

The real-renderer acceptance test checks all room IDs, three camera poses per room, floor and body clearance at the shoulder proxy, and the proxy-to-camera sight line. It checks 461 sample positions along all 15 original corridor centerlines for floor and capsule clearance. This does not prove that every position in each room is traversable.

Regression checks cover the open furnace view, the front of the ascent stairs, and a clear archive water sight line. Floor collision uses shared canonical half-grid coordinates to avoid microscopic gaps at translated room seams. Visible room geometry retains the original planning projection.

The test also exercises room navigation and camera controls. The original sanctuary test passes again. The original map test was absent from the concurrent working tree, so an isolated copy from Git revision `54f69f37535ba2d900c90a1ba375b3a81ac085ad` tests the current original map and passes; the deleted working-tree test is not restored. Raw results, initial expected failures, render logs, per-room evidence, preservation hashes, and visual review notes are stored in `Evidence/`.

Static effects, fixed review cameras, partial collision proxies, and sampled route checks are not a production gameplay camera, a navigation mesh, a combat playtest, or a performance benchmark. No full-dungeon frame-rate target is claimed.

## Reproduce

Use the same Godot executable and project path as the launcher. Run these scripts with `--rendering-method forward_plus --script`:

```
res://Rootbound_Sanctum/Art_Dungeon/test_dungeon.gd
res://Rootbound_Sanctum/Art_Dungeon/capture.gd
```

The capture script writes its manifest after each successful image. Optional arguments after `--` restrict captures to room IDs or `map`; for example `-- 05 08 14 map`.

Run `python Rootbound_Sanctum/Art_Dungeon/make_review.py` to rebuild the contact sheets and local gallery. It uses the Pillow installation already present on this workstation and Windows Segoe UI fonts. It checks capture coverage, dimensions, non-flat pixels, and unique image hashes before it creates the review sheets.

## Package

`Rootbound_All_Rooms_Review.zip` is a review and source package, not a standalone executable. Its Review and Renders folders work together for offline browsing. Its Source folder preserves the project-relative paths for the new scene, its approved primitive dependency, and the original layout data. The launcher is intended for the existing project.
