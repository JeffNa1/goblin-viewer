const fs = require('fs');

let vb = fs.readFileSync('scripts/voxel_builder_test.gd', 'utf8');

// 1. Comment out class_name in test file so it doesn't collide
vb = vb.replace('class_name VoxelBuilder', '# class_name VoxelBuilder');

// 2. Fix the battlement block in build_head_mesh_outfit3
const oldBattlement = `	# 7. Upper Imperial Crown Capital & Ruby Battlements (y: 28 to 30)
	for x in range(-3, 4):
		for z in range(-3, 4):
			if abs(x) == 3 and abs(z) == 3: continue
			if abs(x) == 3 or abs(z) == 3:
				var is_battlement = ((x == 0 or z == 0) and y >= 29)
				var col = C_IMP_GOLD_LIGHT
				if is_battlement:
					col = C_RUBY if y == 29 else C_IMP_GOLD_GLEAM
				voxels[Vector3i(x, 28, z)] = C_IMP_GOLD_GLEAM
				if is_battlement:
					voxels[Vector3i(x, 29, z)] = col
					voxels[Vector3i(x, 30, z)] = C_IMP_GOLD_GLEAM`;

const newBattlement = `	# 7. Upper Imperial Crown Capital & Ruby Battlements (y: 28 to 30)
	for x in range(-3, 4):
		for z in range(-3, 4):
			if abs(x) == 3 and abs(z) == 3: continue
			if abs(x) == 3 or abs(z) == 3:
				var is_battlement = (x == 0 or z == 0)
				voxels[Vector3i(x, 28, z)] = C_IMP_GOLD_GLEAM
				if is_battlement:
					voxels[Vector3i(x, 29, z)] = C_RUBY
					voxels[Vector3i(x, 30, z)] = C_IMP_GOLD_GLEAM`;

if (vb.includes(oldBattlement)) {
  vb = vb.replace(oldBattlement, newBattlement);
  console.log('Fixed battlement block in build_head_mesh_outfit3.');
} else {
  console.error('Battlement block not found!');
}

fs.writeFileSync('scripts/voxel_builder_test.gd', vb, 'utf8');
