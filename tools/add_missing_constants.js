const fs = require('fs');

let content = fs.readFileSync('scripts/voxel_builder_test.gd', 'utf8');

const missingBlock = `
# Archer & Shaman Additional Palette Constants
const C_GOLD_RICH: int = 0xf59e0b
const C_GOLD_DEEP: int = 0xd97706
const C_ROYAL_CRIMSON: int = 0x991b1b
const C_ROYAL_CRIMSON_DARK: int = 0x581010
const C_GEM_RUBY: int = 0xef4444
const C_FEATHER_GOLD: int = 0xfef08a
const C_GEM_SAPPHIRE: int = 0x0284c7
`;

const marker = "const C_SINEW: int = 0xb59e7f";
content = content.replace(marker, marker + "\n" + missingBlock);

fs.writeFileSync('scripts/voxel_builder_test.gd', content, 'utf8');
console.log('Added missing constants.');
