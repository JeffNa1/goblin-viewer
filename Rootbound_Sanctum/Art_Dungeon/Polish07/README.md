# Room 07 — Quiet Sanctuary / Carved Art Pass

## Scope

This pass changes room 07 inside the existing all-room art viewer. The director selects the new room subclass only for ID 07. All other room implementations, the canonical layout and corridors, the original art sample, the original map scene, and character files remain outside the edit scope.

The style keeps deliberate flat facets but replaces large cube silhouettes with carved ashlar, wedge-built arches, fluted pillars and botanical capitals, layered leaf-and-root reliefs, tapered branches, leaf-shaped foliage, rounded vessels, and a chamfered fountain with a suspended faceted heart. Sparse chipped masonry arrises, fine fissure geometry, and basal moss add age. Fissures are surface detail; they are not simulated structural damage.

The existing room footprint, fountain blocker envelope, source light rig and light positions stay fixed. The red figure remains an unchanged scale proxy, not a production player.

## Open

In the existing project, run:

`Rootbound_Sanctum/Art_Dungeon/Polish07/Open_Room07.bat`

It opens the all-room viewer at room 07. Use 1 for shoulder, 2 for eye level, 3 for overview, H to hide the interface, and the existing room picker to compare other rooms. No walking controller is added.

## Evidence and images

`Renders/before/` and `Renders/after/` each contain the same six views at 1600 x 900: shoulder, eye level, overview, carving, fountain and corridor. These are real Godot 4.3 Forward+ captures on the NVIDIA GeForce GTX 1660 SUPER. Camera position, basis, field of view, resolution and adapter are matched by the review script. No generated illustration is substituted for a project render.

`Review/Comparison_*.png` contains full-resolution side-by-side pairs. `Review/Room07_All_Views.png` contains the final room contact sheet.

The older all-room gallery, renders and ZIP outside this directory remain the previous baseline. They do not show this room 07 art pass.

The external reference board is the already approved study. It stays separately labeled and attributed. It is not a project render; no source model or source texture is copied into this room.

## Checks

The original all-room acceptance suite passes before and after the change: 14 rooms, 15 links, 42 camera poses and 461 sampled corridor positions. Other room evidence records are compared exactly. The unchanged original sanctuary test passes again.

The new room check first fails because sculpted categories do not exist. A second check first fails because localized weathering does not exist. The final check passes for substantive non-box geometry, physical relief depth, finite vertices and normals, the fountain envelope, a local detail triangle budget, six camera positions, and 133 sampled approach/ring positions.

For the room-specific clearance check, the test temporarily gives the actual sculpted meshes triangle collision. It then checks the camera spheres and actor capsule against those surfaces, not only the retained simplified colliders. The test discards this extra collision with its scene. The viewer retains the original collision proxies.

Raw executions, the expected failures, capture manifests, preserved-file hashes, source snapshot and the small director integration diff remain in `Evidence/`. The original map and character work are not reset, cleaned, checked out or restored.

Concurrent character work changed `scripts/skeleton_warrior.gd` and `tools/capture_skeleton_warrior.gd` during this pass. Their hashes are not claimed unchanged. The preservation report separates those two allowed concurrent paths from the immutable map/art dependencies. A global whitespace check also reported issues in concurrent character/helper files; those files were not cleaned up by this pass. The task-scoped diff check is separate.

## Reproduce in the existing project

Run from the project root using the existing Python installation:

```
python Rootbound_Sanctum/Art_Dungeon/Polish07/run_checks.py acceptance green-final
python Rootbound_Sanctum/Art_Dungeon/Polish07/run_checks.py capture after
python Rootbound_Sanctum/Art_Dungeon/Polish07/run_checks.py regression
python Rootbound_Sanctum/Art_Dungeon/Polish07/run_checks.py sample
python Rootbound_Sanctum/Art_Dungeon/Polish07/run_checks.py launch
python Rootbound_Sanctum/Art_Dungeon/Polish07/run_checks.py preservation
python Rootbound_Sanctum/Art_Dungeon/Polish07/make_review.py
```

The `baseline` mode records the pre-edit state and is not part of normal reproduction. Do not run it after editing: it replaces the baseline hashes. The launcher smoke test uses its real BAT entry with `--quit-after 120` and checks that room 07 opened.

## Limits

This is one room's art-review pass, not completion of the full-dungeon polish. It adds no combat, enemies, walking controller, dynamic spring-arm camera, navigation mesh, or game-state logic. Clearance samples are not exhaustive traversal. Static light/particle-like geometry is not an animated effects system. No whole-dungeon frame-rate or memory budget is claimed. The extra sculpture has a cost; measure it before wider rollout.

`Room07_Carved_Review.zip` is a review/source package, not a standalone game. Its image folders work offline. Its `Source/` paths document the existing project's dependencies; the launcher targets the existing project installation. Visual approval is still required before extending this treatment to other rooms.
