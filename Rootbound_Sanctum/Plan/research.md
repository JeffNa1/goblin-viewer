# Goblin map study — design review, not game implementation

## Recommendation

Use authored combat rooms, constrained room connections, and curated encounter variations. For this project's first floor, prefer a compact connected dungeon with a readable branch and a return shortcut. Preserve forward momentum, but allow limited exploration. This is a design recommendation, not a claim that one algorithm is best for every roguelike.

This study covers ten representative games and contrasting design approaches. It is not an exhaustive ranking of every top roguelike. Sources describe the cited games and development periods, not necessarily their latest sequels or DLC. The Hades source is its designer's talk; Dead Cells has a lead designer article. Spelunky uses a secondary account. Exact internals remain unknown where the sources only describe player-facing behavior. Official-page search passages support the Returnal and Slay the Spire claims after direct page retrieval failed. The retained Spelunky page capture is truncated; its relevant path-and-template passage is present.

## What the games actually do

### Hades — the closest combat reference

Eduardo Gorinstein describes handcrafted chambers, a mostly forward-only run, and rewards shown on exit doors. Styx is an explicit exception to the usual no-backtracking rule.[1]

Randomization uses authored locations for props and enemy spawn points. Encounter rules constrain the possibilities, rather than placing arbitrary content everywhere.[1]

Rooms and enemies must support different player weapons. The talk specifically rejects mandatory enemies that only ranged attacks can reach.[1]

The designer's Blocktober thread describes smaller early chambers, larger later chambers, and biome-specific room principles. Walls, cover, hazards, and enemy movement form a combined design problem.[12]

**Borrow:** combat clarity, short transitions, early choices, encounter pacing, and readable reward signals.

**Do not copy blindly:** Hades' restrictions partly follow its hand-painted production method. A connected voxel dungeon can allow a small exploration loop. Do not add full backtracking merely because the reference image has corridors.

### Enter the Gungeon — the closest floor-layout reference

Dave Crooks says the team hand-designed and repeatedly played rooms, then connected them using rules for dungeon layouts.[3]

BorisTheBrave's implementation analysis describes pre-authored connection graphs called flows, with branches, loops, reward rooms, hubs, and connectors. Its page includes a Dodge Roll account comment that confirms the intent behind the loops and overall layout feel. Treat the detailed implementation as secondary analysis, not an official specification.[4]

**Borrow:** a distinct route structure before spatial placement, a small loop, and rewards behind meaningful commitments.

**Do not copy blindly:** long search paths and cover intended for gunfire can frustrate a melee-focused game. Give melee players flanking access to ranged enemies.

### Dead Cells — the strongest generation-method reference

The lead designer describes a fixed world framework, hand-designed chunks, and a concept graph for each biome. That graph constrains length, special rooms, connections, and entrance-to-exit separation. Suitable room chunks fill the graph afterward.[2]

Different biomes use different room sets and structures. Enemy placement also has restrictions based on enemy type and available space.[2]

**Borrow:** separate progression, room geometry, and encounter composition. Make different regions play differently, not merely use different colors.

**Do not copy blindly:** platforming distances and vertical routes do not transfer directly to a top-down melee game.

### The Binding of Isaac — stable goals inside a variable floor

Edmund McMillen's 2011 design blog describes recurring treasure, boss, shop, and secret-room roles, plus predesigned room pools arranged by difficulty and chapter. The post also describes context-sensitive extra rooms.[5]

**Borrow:** stable expectations about resources and goals, combined with variable room contents.

**Do not copy blindly:** the original post is not a guarantee about every floor or expansion in modern Isaac. Its compact shooting arenas do not establish suitable melee dimensions.

### Spelunky — connectivity before decoration

PCMag's account of the original game's design describes a room grid, an entrance-to-exit path, room templates, and subsequent interior variation. This is a secondary explanation, not a source-code audit.[14]

**Borrow:** reserve a reachable progression path before hazards and decoration appear. Keep interactions consistent across different arrangements.

**Do not copy blindly:** platforming traps, destructible terrain, and tightly packed hazards create a different risk profile from continuous melee combat.

### Slay the Spire — meaningful route selection

Mega Crit's store description explicitly describes changing layouts and a choice between risky and safe paths.[7]

**Borrow:** show enough information for route choices to reflect current health and resources. A branch should offer a different opportunity, not an arbitrary left/right coin flip.

**Do not copy blindly:** its route map is an abstract encounter selector, not a continuous traversable floor plan. It does not solve corridor placement or melee movement.

### Risk of Rain 2 — an important counterexample

Hopoo's interview describes premade maps with variations and randomized objects and enemies. The team tried procedural terrain but found the challenge of memorable 3D maps too large for its team size.[8]

**Borrow:** recognizable landmarks and controlled variations. Random terrain is not mandatory for a replayable roguelike.

**Do not copy blindly:** large open spaces suit a different camera, movement model, and combat scale. They can produce empty travel in this proposed dungeon.

### Returnal — authored spaces can still feel different

Housemarque describes handcrafted environments, combat, and narrative moments that the game connects procedurally.[9]

**Borrow:** a reusable room can carry a strong identity. Room connections and encounter variations can change the run without arbitrary geometry.

**Do not copy blindly:** do not inherit AAA-scale streaming, verticality, or production scope for a first floor.

### Wizard of Legend — hybrid rooms for fast combat

The official press kit describes fast combat, quick movement, chained spells, and generated levels that include both random and precrafted rooms.[10]

**Borrow:** make the room support chains of attacks and movement. Interior obstacles should create combat decisions.

**Evidence limit:** the press kit does not establish its exact graph algorithm, dimensions, or spawn rules.

### Curse of the Dead Gods — the environment participates

The official store description presents a dark temple with rooms, corridors, pits, traps, and secrets. It identifies light, fire, and curses as important parts of the experience.[11]

**Borrow:** restrained environmental hazards and a strong temple identity. A hazardous branch can signal greater risk before the player commits.

**Evidence limit:** this source does not reveal the precise generation algorithm. Do not claim it uses a specific graph method.

## Synthesis for this project

The common useful pattern is controlled variation, not maximum randomness. Hades, Gungeon, and Dead Cells give particularly strong support for authored spaces and constrained assembly.[1][2][3]

For this proposal, use three design layers:

1. **Progression:** entrance, opening encounters, route choice, recovery, final encounter, boss, exit.
2. **Space:** compatible room shapes, doors, short connectors, and a single clearly controlled shortcut.
3. **Contents:** encounter variants, reward offers, and decoration within tested positions.

These are proposed design rules for Goblin Viewer, not exact rules copied from any source game.

## Reference-image reading

The supplied image combines rectilinear ceremonial rooms, a rounded chamber, a large irregular cave, and an underground waterway with a boat. Colored floors and distinct silhouettes differentiate spaces. Long corridors occupy significant space, especially on the right side. The image alone does not establish entrance, objective, encounter rules, or traversal permissions.

Retain the contrast between stone architecture and organic cave walls. Retain water as an edge landmark, warm torchlight, roots, and a visually distinct final space. Replace dense decorative floors with quieter combat surfaces. Avoid copying the actual room arrangement, art, or ornamental motifs.

## Local project observations

Read-only inspection found a monster viewer and stance editor, rather than a verified playable dungeon. The main scene contains the five named monster instances and an orbit camera. The scripts search did not find CharacterBody3D, move_and_slide, or _physics_process. This is evidence of the current inspected scope, not proof that no movement code exists anywhere.

The source uses VoxelBuilder.V_SCALE = 0.03. Do not replace that scale with a generic voxel convention from a skill. The map uses planning units relative to the future player footprint, not the source's voxel resolution.

Local references: README.md; project.godot; scenes/viewer.tscn; scripts/viewer.gd; scripts/voxel_builder.gd:4.

The codegraph command was unavailable on PATH, and targeted file searches under .gemini and the active Hermes skills found no matching file. Standard read-only inspection was used afterward. No package was installed. Existing project modifications were present before this study. The project was not launched because its startup includes an outfit-capture routine.

## What is still unproven

The proposed camera angle, player footprint, attack reach, dash length, enemy pursuit behavior, room durations, and spawn counts have not been playtested. These determine the final geometry. No game scene, generator, combat script, or asset was created or modified for this review.

Approve the floor's route structure and visual direction first. A later playable graybox is a separate approval step. Approval of this document alone must not be treated as permission to build the complete game.

## Sources

[1] https://www.youtube.com/watch?v=qv_vUa7bxks

[2] https://deepnight.net/tutorial/the-level-design-of-dead-cells-a-hybrid-approach

[3] https://www.gamedeveloper.com/design/q-a-the-guns-and-dungeons-of-i-enter-the-gungeon-i-

[4] https://www.boristhebrave.com/2019/07/28/dungeon-generation-in-enter-the-gungeon

[5] https://edmundmcmillen.blogspot.com/2011/09/binding-of-isaac-gameplay-explained.html

[7] https://store.steampowered.com/app/646570/Slay_the_Spire

[8] https://www.gamedeveloper.com/design/how-moving-from-2d-to-3d-shaped-the-design-of-i-risk-of-rain-2-i-

[9] https://www.unrealengine.com/developer-interviews/deciphering-the-narrative-driven-procedural-horror-of-returnal

[10] https://wizardoflegend.com/press/wizard_of_legend/index.html

[11] https://store.steampowered.com/app/1123770/Curse_of_the_Dead_Gods

[12] https://threadreaderapp.com/scrolly/1311777010239193088

[14] https://www.pcmag.com/news/how-spelunky-made-procedural-generation-fun
