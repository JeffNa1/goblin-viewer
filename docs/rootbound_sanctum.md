# Rootbound Sanctum — shape revision B

A separate, runnable voxel inspection scene of the approved 14-space floor. The project main scene, existing dungeon, and monster source files are not changed by this implementation.

## Open

Double-click `Rootbound_Sanctum_B.bat` in the project directory. The local desktop shortcut calls the same launcher. The Windows launcher uses the existing Godot installation, then falls back to `godot` on PATH.

From a shell in the project directory:

```sh
godot --path . res://scenes/rootbound_sanctum.tscn
```

In Godot, open `scenes/rootbound_sanctum.tscn` and run that scene with F6. Geometry appears at runtime; the scene does not use an editor tool script. Running the project main scene still opens the existing viewer.

## Inspection

Choose any of the 14 rooms from the selector. `Overview` shows the complete floor. `Scale` shows the four regular archetypes in room 03. `Boss` shows the current Chieftain in room 12. All five references use their existing scenes and scales. Their idle poses are static in this inspection scene.

Use WASD or arrow keys to pan, the mouse wheel to zoom, Q/E to orbit, and Home for the overview. Low foreground walls support the initial south-east view. This is not a player controller.

The gate button previews all gates open or closed. Inspection starts with gates open. `set_gate_flags()` supports the approved `sanctuary07`, `elite09`, `boss12`, and `discover13` prerequisites. Both elite-reward connections use `elite09`, so the safe branch cannot open the reward from behind. These are explicit inspection states, not automatic combat completion.

## Geometry and scale

`data/rootbound_layout.json` contains the approved room IDs, room outlines sampled from the revision B SVG, blockers, and all 15 connections. Polygons are sampled at approximately 3 SVG pixels. Terrain rasterization uses one global grid so sockets stay open where rooms meet corridors.

The measurement tool reads actual visible mesh vertices at each existing scene scale. It records idle body bounds, idle bounds with weapons, and a 24-sample walking body envelope over one second. Body measurements exclude meshes under named weapons. They are geometric measurements, not gameplay collision shapes or attack envelopes.

The largest regular-monster walking footprint rounds up to a 1.2 m planning unit. One SVG pixel is 0.12 m. The nominal corridor width is 4.8 m, with grid discretization at its edges. Terrain uses 0.24 m voxels; character assets keep their existing 0.03 m voxel scale and scene transforms. Gate beams start 3.36 m above the floor.

The builder reuses the existing `VoxelBuilder.build_seamless_mesh_scaled()` implementation. It culls internal voxel faces. Floors, shaped perimeter walls, obstacles, stairs, and gates have static triangle collision. Room roles receive simple blockout landmarks, including the root island, fountain, smithy, treasure platforms, boat, and shallow decorative water.

The JSON includes a hash snapshot of the monster sources and stance data used for calibration. Monster-related files changed during construction outside this task's write targets. Measurements were refreshed against a stable snapshot without editing those files. Recheck scale after future monster geometry or stance changes.

## Checks

Run from the project directory with the installed Godot executable:

```sh
godot --headless --path . --script res://tools/test_rootbound_sanctum.gd
godot --headless --path . --script res://tools/check_rootbound_clearance.gd
godot --headless --path . --script res://tools/test_dungeon_builder.gd
```

The first test checks all 14 meshes, physical floor hits, walls, planned blockers, landmarks, the five references, camera selection, and individual gate prerequisites. It also checks that the overview controls do not cover approved room outlines.

The clearance test checks 460 positions across all 15 corridor centerlines against real physics geometry. Its capsule is 2.4 m wide and 3.0 m tall, with a 0.02 m query margin. It checks that closed gates physically block the capsule and that the references retain their scene scales. This is a sampled static overlap test, not continuous locomotion, a weapon-swing test, or navigation validation.

The clearance test writes `rootbound_clearance_grid.json` and `rootbound_physics_checks.json` under Godot's project user-data directory. Check the exported grid with:

```sh
python tools/check_rootbound_routes.py "<Godot project user-data directory>/rootbound_clearance_grid.json" --out "<report directory>/route-checks.json"
```

The route checker uses a 0.72 m radius footprint on the actual terrain grid. All 16 gate-state combinations must match the approved connection graph. This catches disconnected rooms and reward bypasses around the built blockers. It is separate from the real-physics capsule checks.

Capture actual rendered views with a non-headless Godot process:

```sh
godot --path . --resolution 1440x900 --script res://tools/capture_rootbound_sanctum.gd -- --out=<capture-directory>
```

The capture tool writes six PNG files and a render report, then exits. It never starts the viewer scene.

## Deliberate limits

This is the first spatial voxel build, with simple blockout props. It is not a finished environment-art pass. It contains no player movement, combat, enemy navigation, encounter waves, procedural room reshuffle, functional rewards, recovery, or next-floor transition. Room-clear combat seals are not implemented. Water is decorative. The ascent is geometry, not a level-loading trigger. Combat readability, pacing, attacks near walls, moving-body collision, and performance under real encounters still need playtests.
