const fs = require('fs');

let vb = fs.readFileSync('scripts/voxel_builder_test.gd', 'utf8').replace(/\r\n/g, '\n');

// Apply the 9 warrior steps
const steps = [97, 103, 107, 113, 117, 123, 127, 131, 135];
for (const s of steps) {
  const data = JSON.parse(fs.readFileSync('warrior_edit_' + s + '.json', 'utf8'));
  const target = data.TargetContent.replace(/\r\n/g, '\n');
  const repl = data.ReplacementContent.replace(/\r\n/g, '\n');
  if (!vb.includes(target)) {
    console.error('Failed to find target for warrior step ' + s);
    process.exit(1);
  }
  vb = vb.replace(target, repl);
  console.log('Warrior step ' + s + ' applied.');
}

// Add the archer constants if not present
const archerPalette = `
# Imperial Golden Marksman Palette (Bộ đồ 3: Xạ Thủ Hoàng Kim Đế Quốc)
const C_GOLD_RICH: int = 0xf59e0b   # Polished royal gold plate
const C_GOLD_DEEP: int = 0xd97706   # Burnished warm gold bevels
const C_GOLD_DARK: int = 0x92400e   # Antique shadow gold crevice
const C_ROYAL_CRIMSON: int = 0x991b1b # Imperial velvet crimson
const C_ROYAL_CRIMSON_DARK: int = 0x581010 # Dark shadow velvet fold
const C_GEM_RUBY: int = 0xef4444    # Sparkling ruby gem
const C_GEM_RUBY_GLOW: int = 0xf87171 # Glowing ruby core
const C_GEM_SAPPHIRE: int = 0x0284c7 # Monocle targeting crystal
const C_FEATHER_GOLD: int = 0xfef08a # Phoenix gilded feather
const C_STRING_GOLD: int = 0xfde047 # Divine golden bowstring
`;

// Insert after C_PELT_LIGHT if not present
if (!vb.includes("C_GOLD_RICH")) {
  const marker = "const C_SINEW: int = 0xb59e7f";
  vb = vb.replace(marker, marker + "\n" + archerPalette);
  console.log('Archer constants added.');
}

fs.writeFileSync('scripts/voxel_builder_test.gd', vb, 'utf8');
console.log('Successfully written voxel_builder_test.gd! Total size:', vb.length);
