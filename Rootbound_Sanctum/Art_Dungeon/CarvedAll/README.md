# Rootbound Sanctum — All Carved Rooms

## Open

Run `Open_All_Carved_Rooms.bat` in this directory. This requires the existing project and Godot 4.3 installation. It is an art-review scene, not a standalone gameplay executable.

The loading page appears before layout work. It reads 14 packed rooms plus the shared floor, lighting and passages through Godot background resource requests. It shows measured resource/job progress, renders the full map behind the opaque page, and then reveals the complete scene. Missing or failed resources leave an error page instead of revealing a partial map.

Arrow keys or the top-left picker change rooms. `1` selects shoulder view, `2` eye level, `3` room overview, `4` detail. `M` shows the connected map. `H` hides labels. The red figure is a scale proxy, not the production character. There is no free-roam controller or combat simulation in this viewer.

## Art scope

Room 07 uses the approved Carved07 source without changing that source. Thirteen additional rooms use cubic volume art at selective 0.03/0.06-unit cells, with exterior greedy meshing. Shared columns, vessels, plants and portals reuse approved geometry. Room-specific crests and landmarks preserve room identities: landing skiff and mooring, sluice mechanism, root court, bunks and weapons, arched furnace, antlered effigies, book galleries, incised obelisks, fitted chests, pipe organ, gilled mushrooms and the carved ascent.

The original layout and its 15 connections remain unchanged. Original art directories remain available. All new source, packed assets and review files are inside `CarvedAll/`. Character code is outside this task.

## Review and evidence

`Review/Gallery.html` links full-resolution captures. `Review/Room_01.png` through `Room_14.png` show four views per room. `Review/All_Rooms.png` is a contact sheet. `Renders/manifest.json` is written incrementally and records camera positions, image sizes, adapter and short stationary frame samples. Startup images and the loading trace are separate.

`Evidence/acceptance.json` records camera, corridor and control acceptance. `visible-geometry.json` records cubic-normal checks; temporary triangle colliders test actual rendered art rather than just coarse proxies. `carving-depth.json` records physical recess depths and retained floor tiles. Regression copies redirect output here so approved sample evidence stays untouched. These checks do not prove combat, spring-arm movement, navmesh behavior or long-session performance.

## Rebuild

From the project root, run `python Rootbound_Sanctum/Art_Dungeon/CarvedAll/build_rooms.py`. Supplying room IDs rebuilds only those rooms, excluding the unchanged room 07 source.

Bake with the installed Godot executable using `--path . --rendering-method forward_plus --audio-driver Dummy --script res://Rootbound_Sanctum/Art_Dungeon/CarvedAll/bake_rooms.gd`. Do **not** use `--headless` for baking: the Godot 4.3 dummy renderer discards MultiMesh instance buffers. The bake rejects empty buffers before overwriting valid scenes.

Run `python Rootbound_Sanctum/Art_Dungeon/CarvedAll/run_checks.py`. Capture with Godot using `--path . --rendering-method forward_plus --audio-driver Dummy --script res://Rootbound_Sanctum/Art_Dungeon/CarvedAll/capture.gd`. Then run `python Rootbound_Sanctum/Art_Dungeon/CarvedAll/make_review.py`.

## References

The design continues the approved sanctuary, not a downloaded asset pack. Prior references remain in the original sample reference board. Official loading behavior: https://docs.godotengine.org/en/4.3/tutorials/io/background_loading.html

The review ZIP contains images and evidence, not a standalone game. Frame samples describe stationary review views on the recorded adapter only; they are not a guarantee of gameplay frame rate.
