# Voxel Goblin Viewer

An interactive 3D Voxel Monster Viewer, Showcase, and Stance Editor built with **Godot Engine 4** (GL Compatibility).

Featuring 6 distinct monster & undead archetypes with fully custom seamless voxel modeling, modular weapon systems, tailored animation suites, and an in-engine real-time stance editor.

---

## 👹 Monster Roster

### 1. Goblin Warrior (Chiến Binh Chùy Gai)
- **Triple Outfit System**:
  - **Outfit 1 (Feral Primitive / Thô Sơ)**: Tattered raw burlap tunic, rope belt with bone trophy, primitive spiked wooden club, bare clawed feet. Single classic overhead smash (`1.3s`).
  - **Outfit 2 (Ironclad Battle Warrior / Chiến Binh Thép)**: Forged iron horned combat helmet with steel nasal guard, heavy steel cuirass with central keel ridge over crimson war gambeson, tiered spiked shoulder pauldrons, steel vambraces and solid iron gauntlets, heavy steel greaves with spiked war sabaton boots, and an upgraded **Heavy Flanged & Spiked War Mace** (4 razor flanges, 360° corner cleat spikes, golden crown ring, and top armor-piercing thrust spike).
  - **Outfit 3 (Imperial Golden Sovereign / Hoàng Kim Chiến Tướng)**: Imperial gold plate regalia, royal crimson velvet gambeson with gold mail trim, Dragon Diadem crown with 6 faceted rubies, sweeping majestic Imperial Dragon Horns, flowing royal crimson & white silk plume, gold-capped lower boar tusks, septum ring, sunburst cuirass centered with a glowing Heart Ruby, 3-tiered dragon-wing pauldrons, ruby-studded golden gauntlets and sabatons, and the ultimate **Sunburst Divine War Mace / Hoàng Kim Thần Chùy** (8-way solar starburst flanges reaching width 6, inner glowing ruby sun core, 4-cardinal rubies on sunburst guard, crown pommel with teardrop ruby pendant, and towering diamond-profile apex sun lance).
- **Special Action**: **🔥 / 👑 Combo 1-2-3 Attack** (Available on Outfit 2 & 3, 3.0s continuous sequence):
  - **Hit 1 (Overhead Slam / Bổ Chùy)**: Forward lunge leap and ground impact with molten solar-crimson trail (Outfit 2) / blinding Sun Gold arc (Outfit 3) and earth shockwave.
  - **Hit 2 (180° Horizontal Cleave / Quét Thuận)**: Instant hip recoil into a full 180° sweeping slash with celestial amber crescent ribbon trail (Outfit 2) / imperial ruby crescent ribbon (Outfit 3).
  - **Hit 3 (Reverse Horizontal Cleave / Quét Ngược Mượt Mà)**: Low spring coil into an explosive 160° reverse horizontal cleave with ice-cyan burst (Outfit 2) / divine solar starburst (Outfit 3), flowing seamlessly back into the combat stance with zero hitch or stutter.
- **Animations**: Idle, Walk, Run, Heavy Overhead Smash / Combo 1-2-3, Horizontal Cleave, Parry Smash, Parry Cleave, Stunned.
- **Stances**: Low Carriage (`Vác Thấp`), Guard (`Thủ Thế`), Shoulder Rest (`Vác Vai`).

### 2. Goblin Archer (Xạ Thủ Cung)
- **Triple Outfit System**:
  - **Outfit 1 (Tribal Hunter / Thô Sơ)**: Tattered raw animal pelt vest, canine tooth chest trophy, sinew wrist bindings, wild fur loincloth, bare clawed feral feet with grounded sole support.
  - **Outfit 2 (Forest Ranger / Xạ Thủ Kiểm Lâm)**: Quilted forest-green gambeson, hardened leather chest plastron with bronze studs, vambraces, and tall laced hunting boots.
  - **Outfit 3 (Imperial Golden Marksman / Xạ Thủ Hoàng Kim Đế Quốc)**: Opulent gilded imperial armor, royal velvet crimson gambeson with gold diamond quilting, winged falcon diadem crown with twin phoenix plumes (crimson & gold), ornate sapphire ocular targeting monocle, ruby-crested eagle buckle & gorget, sculpted golden vambraces with claw thimbles, fluted golden greaves with winged sabatons, and an upgraded magnificent **Imperial Recurve Warbow** (dragon-bone limbs, sculpted gold filigree armor, ruby sighting crystal, divine gold bowstring) accompanied by a fluted golden quiver and gilded phoenix-fletched broadhead arrows.
- **Equipment**: Recurve wooden bow, fletched arrows, back quiver resting flush on harness.
- **Animations**: Aim (`Ngắm Bắn`), Shoot (`Bắn Tên`), Backstep Dodge (`Lùi Né Đòn`), Hurt, Stunned (grounded feet, zero floor clipping), Walk, Sprint.
- **Stances**: Aim (`Ngắm Bắn`), Draw Release (`Buông Cung`), Sheathed (`Thủ Cung`).

### 3. Goblin Shaman (Pháp Sư Totem)
- **Triple Outfit System**:
  - **Outfit 1 (Tribal Witch Doctor / Thầy Mo Bộ Lạc)**: Ritual purple robes, beast skull mask with cyan soul flame eyes, floating soul orb skull staff, summonable tribal demon totem pillar.
  - **Outfit 2 (Grand Arch-Shaman / Đại Pháp Sư Hoàng Gia)**: Long billowing royal magenta robes with double gold embroidered hems, high flared arcane collar, sweeping curved dragon horns with cyan soul flame eyes, gilded dragon amulet, and a dual-color soul star staff.
  - **Outfit 3 (Imperial Golden Archon / Pháp Vương Hoàng Kim Đế Quốc)**: Full imperial golden plate armor with chased filigree and radiant heart ruby breastplate, flared golden gorget with velvet lining, tiered golden pauldrons with lion reliefs, royal crimson velvet cape with ermine fur collar and embossed 3D golden sun sigil, enlarged ancient dragon skull mask (0.87m width) with glowing solar soul fire, **thick majestic swept 3D dragon horns** (2x2 / 3x3 cross-sections) wrapped in ribbed golden bands, the upgraded **Scepter of the Solar Dragon** (twin coiled golden celestial dragons, crowned dragon skull, 4 horns, and floating radiant multi-layer Solar Star with orbiting ruby/gold rings and flame spires), and the summonable **Imperial Golden Totem Monolith** (stepped obsidian/gold altar, gilded dragon column, thick golden horns, and dancing solar soul brazier).
- **Equipment**: Scepter of the Solar Dragon / Skull Staff, summonable demon totem / golden monolith.
- **Animations**: Chant (`Niệm Chú`), Summon Totem (`Gọi Totem`), Hex Shockwave (`Phóng Phép` with solar gold & ruby projectile), Hurt, Stunned.
- **Stances**: Staff Grounded (`Chống Gậy`), Incantation (`Tụ Chú`), Seal Cast (`Pháp Ấn`).

### 4. Goblin Rogue (Sát Thủ Song Dao)
- **Equipment**: Dark assassin cowl/bandana, twin serrated bone daggers with hook teeth.
- **Animations**: Stealth Stalk (`Rình Rập`), Dash (`Lướt Nhanh`), Dual Cross Slash (`Chém Chéo X`), Stunned.
- **Stances**: Stalk (`Rình Rập`), Cross Guard (`Bắt Chéo X`), Reverse Grip (`Dao Ngược`).

### 5. Mace Ogre (Boss Ogre Cầm Chùy Nguyên Thủy)
- **Equipment**: Beast fur pelt draped shoulder sash, crude leather & sinew harness, trophy fangs necklace, tattered loincloth, braided rope belt, bone septum piercing & earrings, warrior mohawk topknot, and a colossal primitive chipped-stone great mace bound with sinew and jagged spikes.
- **Animations**: Heavy March (`Bước Nặng`), War Roar (`Gầm Thét`), Earthshaker Slam (`Địa Chấn`), 360 Whirlwind (`Bão Chùy 360°`), Stagger Kneel (`Quỳ Gối`), Stunned (`Choáng`).
- **Stances**: Great Mace Shoulder (`Vác Đại Chùy`), Ground Rest (`Chống Chùy Đất`), Heavy Guard (`Thủ Trọng Lực`).

### 6. Skeleton Warrior (Chiến Binh Bộ Xương)
- **Primitive Gear & Skeletal Anatomy**: Weathered ancient skull with brow ridge and deep cavernous eye sockets with faint amber soul embers, hollow nasal cavity, snarling teeth with battle-chipped gaps, cracked rawhide headband with dangling wolf canine charm, exposed hollow ribcage revealing the complete spinal column and scapulae, ragged burlap loincloth with frayed hemp rope tie, slender dual forearm bones (radius & ulna) and shin bones (tibia & fibula), and articulated skeletal feet with grounded soles (0.64m hip elevation, zero floor clipping).
- **Armaments**:
  - **Shoddy Notched Sword**: Crude pitted rusted iron broadsword with asymmetrical bent quillons, leather-wrapped grip, chipped battle notches along cutting edges, broken razor tip, and a ghostly pale steel slash trail FX.
  - **Splintered Wooden Shield**: Primitive curved timber plank shield with weathered grain, splintered rim damage, horizontal rusted iron reinforcement brackets, and a hammered iron central umbo shield boss with defensive spike.
- **Animations**: Idle (`Khua Xương` with eerie bone-rattling sway), Walk (`Khập Khiễng`), Run (`Lao Cuồng Nộ`), Slash (`Chém Kiếm Cũ`), Thrust (`Đâm Kiếm Rỉ`), Block (`Chắn Khiên Gỗ`), Hurt (`Rơi Vụn Bone`), Stunned (`Rụng Rời` with spinning stun stars).
- **Stances**:
  - Ready (`[ Q ] Thủ Thế`): Forward combat poise, raised notched blade and angled wooden shield.
  - High Guard (`[ W ] Thủ Khiên`): Raised defensive shield posture, sword held high over shoulder for counter-thrust.
  - Low Drag (`[ E ] Kéo Kiếm`): Low blade carriage trailing backward, shield held tight to protect the ribcage.

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

- **F1 - F6**: Switch active monster (Warrior, Archer, Shaman, Rogue, Mace Ogre Boss, Skeleton Warrior).
- **1 - 8**: Trigger specific animations.
- **Q / W / E**: Switch weapon stances.
- **O**: Switch monster outfit (Warrior: Outfit 1 <-> 2 <-> 3; Archer: Outfit 1 ➔ 2 ➔ 3; Shaman: Outfit 1 ➔ 2 ➔ 3; Rogue: Outfit 1 ➔ 2; Ogre: Outfit 1 ➔ 2).
- **Left Mouse Drag**: Rotate camera around character.
- **Mouse Wheel**: Zoom in / out.
- **Spacebar**: Toggle auto-rotation.
