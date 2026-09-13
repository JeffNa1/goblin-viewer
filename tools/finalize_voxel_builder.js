const fs = require('fs');

let vb = fs.readFileSync('scripts/voxel_builder_test.gd', 'utf8');
// Restore class_name VoxelBuilder
vb = vb.replace('# class_name VoxelBuilder', 'class_name VoxelBuilder');

fs.writeFileSync('scripts/voxel_builder.gd', vb, 'utf8');
console.log('Successfully written scripts/voxel_builder.gd! Size:', vb.length);

// Clean up test file
fs.unlinkSync('scripts/voxel_builder_test.gd');
console.log('Removed scripts/voxel_builder_test.gd');
