# Voxel Goblin Viewer

An interactive 3D Voxel Monster Viewer, Showcase, and Stance Editor built with **Godot Engine 4** (GL Compatibility).

Featuring 5 distinct goblin monster archetypes with fully custom seamless voxel modeling, modular weapon systems, tailored animation suites, and an in-engine real-time stance editor.

---

## 👹 Monster Roster

### 1. Goblin Warrior (Chiến Binh Chùy Gai)
- **Dual Outfit System**:
  - **Outfit 1 (Feral Primitive / Thô Sơ)**: Tattered raw burlap tunic, rope belt with bone trophy, primitive spiked wooden club, bare clawed feet. Single classic overhead smash (`1.3s`).
  - **Outfit 2 (Ironclad Battle Warrior / Chiến Binh Thép)**: Forged iron horned combat helmet with steel nasal guard, heavy steel cuirass with central keel ridge over crimson war gambeson, tiered spiked shoulder pauldrons, steel vambraces and solid iron gauntlets, heavy steel greaves with spiked war sabaton boots, and an upgraded **Heavy Flanged & Spiked War Mace** (4 razor flanges, 360° corner cleat spikes, golden crown ring, and top armor-piercing thrust spike).
- **Special Action**: **🔥 Combo 1-2-3 Attack** (Exclusive to Outfit 2, 3.2s continuous sequence):
  - **Hit 1 (Overhead Slam / Bổ Chùy)**: Forward lunge leap and ground impact with molten solar-crimson trail and earth shockwave.
  - **Hit 2 (180° Horizontal Cleave / Quét Ngang)**: Instant hip recoil into a full 180° sweeping slash with celestial amber crescent ribbon trail.
  - **Hit 3 (Reverse Rising Uppercut / Quét Ngược Hất Tung)**: Low pivot crouch into an explosive skyward rising uppercut launcher with ice-cyan golden flare burst, settling into victory ready stance.
- **Animations**: Idle, Walk, Run, Heavy Overhead Smash / Combo 1-2-3, Horizontal Cleave, Parry Smash, Parry Cleave, Stunned.
- **Stances**: Low Carriage (`Vác Thấp`), Guard (`Thủ Thế`), Shoulder Rest (`Vác Vai`).

### 2. Goblin Archer (Xạ Thủ Cung)
- **Dual Outfit System**:
  - **Outfit 1 (Tribal Hunter / Thô Sơ)**: Tattered raw animal pelt vest, canine tooth chest trophy, sinew wrist bindings, wild fur loincloth, bare clawed feral feet with grounded sole support.
  - **Outfit 2 (Forest Ranger / Xạ Thủ Kiểm Lâm)**: Quilted forest-green gambeson, hardened leather chest plastron with bronze studs, vambraces, and tall laced hunting boots.
- **Equipment**: Recurve wooden bow, fletched arrows, back quiver resting flush on harness.
- **Animations**: Aim (`Ngắm Bắn`), Shoot (`Bắn Tên`), Backstep Dodge (`Lùi Né Đòn`), Hurt, Stunned (grounded feet, zero floor clipping), Walk, Sprint.
- **Stances**: Aim (`Ngắm Bắn`), Draw Release (`Buông Cung`), Sheathed (`Thủ Cung`).

### 3. Goblin Shaman (Pháp Sư Totem)
- **Equipment**: Ritual purple robes, beast skull mask with cyan soul flame eyes, floating soul orb skull staff, summonable demon totem pillar.
- **Animations**: Chant (`Niệm Chú`), Summon Totem (`Gọi Totem`), Hex Shockwave (`Phóng Phép`), Hurt, Stunned.
- **Stances**: Staff Grounded (`Chống Gậy`), Incantation (`Tụ Chú`), Seal Cast (`Pháp Ấn`).

### 4. Goblin Rogue (Sát Thủ Song Dao)
- **Equipment**: Dark assassin cowl/bandana, twin serrated bone daggers with hook teeth.
- **Animations**: Stealth Stalk (`Rình Rập`), Dash (`Lướt Nhanh`), Dual Cross Slash (`Chém Chéo X`), Stunned.
- **Stances**: Stalk (`Rình Rập`), Cross Guard (`Bắt Chéo X`), Reverse Grip (`Dao Ngược`).

### 5. Goblin Chieftain (Boss Tù Trưởng Khổng Lồ)
- **Equipment**: Heavy horned iron helmet, spiked steel shoulder pauldron, studded iron chest bands, colossal spiked warhammer.
- **Animations**: Heavy March, War Roar (`Gầm Thét`), Earthshaker Slam (`Địa Chấn`), 360 Whirlwind (`Bão Chùy 360°`), Kneel Stunned.
- **Stances**: Great Hammer Shoulder (`Vác Đại Búa`), Ground Rest (`Chống Búa Đất`), Heavy Guard (`Thủ Trọng Lực`).

---

## 🛠 Features

- **Live Stance Editor**: Modify and fine-tune bone transforms, weapon carriage angles, and ground offsets live with sliders, with one-click permanent JSON saving (`data/stance_config.json`).
- **Seamless Voxel Mesher**: Dynamic runtime voxel-to-mesh generation using `SurfaceTool` with custom voxel palettes.
- **Procedural Environment**: Expansive meadow terrain with wildflowers, towering forest sentinels, and studio 3-point lighting setup.
- **Free Camera Orbit**: Smooth mouse drag orbit, pitch adjustment, mouse wheel zoom, and auto-rotation toggle.

---

## 🚀 How to Run

1. Download and install [Godot Engine 4.3+](https://godotengine.org/).
2. Clone this repository:
   ```bash
   git clone https://github.com/JeffNa1/goblin-viewer.git
   ```
3. Open Godot, click **Import**, select `project.godot` inside the cloned folder.
4. Press **F5** (or click Run) to launch the viewer.

---

## 🎮 Controls

- **F1 - F5**: Switch active monster (Warrior, Archer, Shaman, Rogue, Chieftain Boss).
- **1 - 8**: Trigger specific animations.
- **Q / W / E**: Switch weapon stances.
- **O**: Switch monster outfit (Warrior & Archer: Outfit 1 <-> Outfit 2).
- **Left Mouse Drag**: Rotate camera around character.
- **Mouse Wheel**: Zoom in / out.
- **Spacebar**: Toggle auto-rotation.
