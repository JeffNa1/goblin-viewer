const fs = require('fs');

const patchCode = fs.readFileSync('C:/Users/Administrator/.gemini/antigravity/brain/26739e25-6360-4de3-a46b-386f58c284da/scratch/build_patch.js', 'utf8');

// Replace voxel_builder.gd with voxel_builder_test.gd
const testPatch = patchCode.replace(/voxel_builder\.gd/g, 'voxel_builder_test.gd');
fs.writeFileSync('tools/test_shaman_patch.js', testPatch, 'utf8');

console.log('Running tools/test_shaman_patch.js...');
