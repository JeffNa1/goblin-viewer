# Rootbound Sanctum — Room 07 Art Sample

## Status and scope

This is a working, isolated Godot art sample for **Quiet Sanctuary (07)** and a close-camera corridor approach. It is not the complete 14-room dungeon. Approval of this room's visual direction is the next gate.

The original room polygon comes from `data/rootbound_layout.json`. The sample adds a south approach and short capped review stubs at the other exits. It does not replace the original map or extend its actual route network. The central basin stays within the planned shrine blocker footprint.

No original character scene or script is loaded. The red-backed block figure is a static scale reference, not the game's player character. There is no movement controller, combat, enemy placement, or runtime camera collision system in this art sample.

## Open and review

Open `Open_Sanctuary_Sample.bat` **from this directory in the existing project**. The launcher uses the installed Godot executable and selects Forward+ for this preview only. The original `project.godot` remains unchanged.

Press **1** for the close shoulder view, **2** for the corridor, **3** for eye level, **4** for the complete sample footprint, and **5** for the shrine detail. Press **H** to hide or show the review UI.

`Renders/` contains five actual 1600 x 900 Godot captures. `Review_Sheet.png` collects all five. `Sanctuary_Review_Pack.zip` is a review package, **not a standalone game or a source-project export**.

## Visual research

I reviewed the official Jungle Awakens artwork for its block foliage, stepped stone forms, and clustered natural colors.[12]

I reviewed the stylized modular ruins reference for its broken architectural silhouettes and the relationship between stone and moss.[6]

I reviewed the forest-ruins reference for focal-point composition and foreground framing.[7]

`References/Reference_Board.png` shows the studied source artwork with source-page links. These images are reference artwork, not project renders. No external model, texture, or material asset enters the Godot scene.

The sample uses a root shrine as its focal point, cool jade water, warm fire, stepped portals, broken vault ribs, relief panels, urns, candles, and selected edge foliage. Thin raised floor slabs replace the first pass's visually oversized grout. Edge dressing leaves the central approach and shrine detour open.

## Execution evidence

`Evidence/red-test.json` records the initial acceptance failure because the sample scene did not exist.

`Evidence/acceptance.json` records **90 walking samples**, **5 camera poses**, corridor wall checks, and a shrine blocker check. All checks passed. These are physical clearance samples and fixed-pose camera checks, not a combat playtest or a continuous gameplay-camera test.

`Evidence/acceptance-run.json`, `Evidence/render-run.json`, and `Evidence/standalone-run.json` record successful execution with Godot 4.3 on the installed NVIDIA GeForce GTX 1660 SUPER. The final Forward+ runs report no errors.

A headless check passed but reported a dummy-renderer mesh warning on shutdown. `Evidence/baseline-test.json` records a later attempt to run the old map test after that file was removed during separate project work. The user confirmed that concurrent character work must not block this map task. The final sample checks do not depend on those removed files or on character scripts.

`Evidence/map-preservation.json` compares six original map/configuration files against their pre-task SHA-256 hashes. All six remain unchanged. All task-authored source files and output are confined to this `Art_Sample` directory.

The sample contains 133,360 exposed-face voxel triangles and 2,159 detail block instances in 57 spatial batches. This is geometry bookkeeping, not a measured frame-rate guarantee. There is no full-dungeon performance result yet.

## Remaining review decisions

Review visual density and atmosphere from the close shoulder and corridor views before the overhead image. The sample still has an open ruined roof, a simple static tree canopy, and no moving water or foliage. The broad floor is intentional for readability, but its final combat use is not tested.

Approve or change this visual target before applying it to the other rooms. Do not treat this sample as approval of an altered route layout or character scale.

## Reproduce

Run from the existing project root:

```text
C:\Users\Administrator\.gemini\antigravity\bin\godot.exe --path . --rendering-method forward_plus --script res://Rootbound_Sanctum/Art_Sample/test_sample.gd
C:\Users\Administrator\.gemini\antigravity\bin\godot.exe --path . --rendering-method forward_plus --resolution 1600x900 --script res://Rootbound_Sanctum/Art_Sample/capture.gd
python Rootbound_Sanctum/Art_Sample/make_review.py
```

The collage tool uses the already-installed Pillow package. It does not install a dependency. Its first run downloads the credited reference images; later runs reuse them.

## Sources

[6] https://80.lv/articles/how-to-make-atmospheric-stylized-modular-ruins-with-zbrush-substance-3d — How to Make Atmospheric Stylized Modular Ruins
[7] https://80.lv/articles/breakdown-how-to-create-a-dark-fantasy-environment-of-ruins-in-a-forest — Breakdown: Dark Fantasy Ruins in a Forest
[12] https://www.minecraft.net/en-us/store/minecraft-dungeons-jungle-awakens-dlc — Minecraft Dungeons: Jungle Awakens — official artwork
