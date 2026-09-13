# Room 07 — authored cubic sanctuary

## Scope

This is the approved isolated room-07 revision, not an all-room update.
The current main director still uses the previous `Polish07` pass. This folder
provides a separate viewer and does not change the director, layout, original
sample, shared geometry, character work or their original evidence folders.

## Open

Run `Open_Carved07.bat` in this folder. It uses the installed Godot 4.3 binary,
Forward+, 1600 × 900, and `viewer.tscn`. Keys 1–8 select shoulder, eye level,
carving, fountain, vessels, portal, overview and corridor. H hides the HUD.
The red figure is an unchanged scale proxy, not the production player.
There is no free walking, combat, spring-arm camera or moving water/fire.

## Art changes

- Recessed guardian sockets, raised nose, brows, root beard and branching crown.
- Layered botanical frames and side-wall vine reliefs with cut channels.
- Fluted columns, leaf capitals, stepped arch stones and broken high vault ribs.
- New square fountain lip with carved leaves, candles and an exposed root tree.
- Hollow urns, leaf reliefs, handles, fitted brazier baskets and small sconces.
- Wall-bound root growth and an almost-flush approach seal outside the fight ring.

`build_art.py` authors occupied cubic volumes with a small restrained palette.
`voxels.py` removes interior faces and greedily merges coplanar exposed faces.
The baked `Assets/sanctuary.glb` has no bevels, oblique normals or smooth shading.
Fine carving and masonry use a 0.03-unit grid; selected structural growth uses
0.06-unit cells. Exported vertex colors are linear RGB. The Godot loader does
not apply a second sRGB conversion. This is authored procedural geometry,
not a claim that an artist placed every voxel manually in an editor.

The backing wall/floor and original collision definitions remain in the isolated
instance. Only the old visible room wall mesh is hidden there. The shared scene
and original files are unchanged. The room keeps the existing footprint and
planned blocker. Existing passage lighting and corridor bases are reused.

## Evidence

`Evidence/acceptance.json` records the real Forward+ acceptance run:
8 fixed camera views, 133 sampled route positions, 611866 sculpture triangles,
98 mesh nodes and zero oblique normals. Temporary triangle collision tests
visible sculptures, not only simple production blocker boxes. Physical ray
probes measured a 0.36-unit socket recess and a 0.30-unit vessel-mouth depth.
Controls 1–8 and H passed synthetic viewport input checks.

`Renders/before/` is a new capture of the previous faceted `Polish07` source.
`Renders/after/` is this cubic pass. They are not reference images.
Each set contains the same eight distinct 1600 × 900 views. The manifests match
camera position, basis, projection, FOV and resolution. Lighting snapshots match
all 125 instantiated light records in the inherited room/passage rig; this count
is not the number of simultaneously visible lights or a lighting performance test.
`Evidence/render-verification.json` checks all 16 unique captures.

The original sample and current 14-room director tests passed before and after.
They write evidence into this folder rather than overwrite original evidence.
Those regressions do not mean this pass is installed in all 14 rooms.
Protected-file comparison found no map/art/layout changes outside this folder.
Eight character/viewer/stance paths changed concurrently; they were not restored.
See `Evidence/preservation.json` for the exact paths and limits.

## Review

`Review/Gallery.html` links matching before/after views.
`Review/Compare_*.png` puts the previous pass above this pass.
`Review/All_Views.png` contains all eight new views.
The copied reference board is explicitly external inspiration, not a Godot render.
Source metadata travels with that board in `References/`.
The review ZIP contains images and evidence, not a standalone game executable.

## Reproduce

From the project root, with the already installed Python + numpy:

```sh
python Rootbound_Sanctum/Art_Dungeon/Carved07/test_voxels.py
python Rootbound_Sanctum/Art_Dungeon/Carved07/build_art.py
```

Run the installed Godot executable with these arguments:

```text
--path <project-root> --rendering-method forward_plus --resolution 1600x900 --script res://Rootbound_Sanctum/Art_Dungeon/Carved07/test_room.gd
--path <project-root> --rendering-method forward_plus --resolution 1600x900 --script res://Rootbound_Sanctum/Art_Dungeon/Carved07/capture.gd -- --baseline
--path <project-root> --rendering-method forward_plus --resolution 1600x900 --script res://Rootbound_Sanctum/Art_Dungeon/Carved07/capture.gd
```

Then run `make_review.py` with the existing Pillow installation.
The scene loads the baked GLB at runtime; viewing does not require Python.
No dependencies were installed and no project-wide import setting was changed.

## Limits and approval gate

611866 triangles is the generated sculpture only, not total rendered scene cost.
The 650000-triangle test ceiling is a room-review guard, not a measured production
budget. This prototype has no LODs, streaming or whole-dungeon performance test.
Fixed poses and sampled clearance are not exhaustive navigation or gameplay QA.
Wall raster steps remain visible at close range because the geometry is cubic.
Approve or reject these actual images before any other room receives this pass.
