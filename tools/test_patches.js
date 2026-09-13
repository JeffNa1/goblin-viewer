const fs = require('fs');

let vb = fs.readFileSync('scripts/voxel_builder.gd', 'utf8').replace(/\r\n/g, '\n');

// 1. Warrior steps
const steps = [97, 103, 107, 113, 117, 123, 127, 131, 135];
for (const s of steps) {
  const data = JSON.parse(fs.readFileSync('warrior_edit_' + s + '.json', 'utf8'));
  vb = vb.replace(data.TargetContent.replace(/\r\n/g, '\n'), data.ReplacementContent.replace(/\r\n/g, '\n'));
}

// 2. Archer checks
const old_head_disp = `static func build_archer_head_mesh(outfit: int = 2) -> ArrayMesh:
	if outfit == 1:
		return build_archer_head_mesh_outfit1()
	return build_archer_head_mesh_outfit2()`;
console.log('Archer head disp in vb:', vb.includes(old_head_disp));

const old_torso_disp = `static func build_archer_torso_mesh(outfit: int = 2) -> ArrayMesh:
	if outfit == 1:
		return build_archer_torso_mesh_outfit1()
	return build_archer_torso_mesh_outfit2()`;
console.log('Archer torso disp in vb:', vb.includes(old_torso_disp));

const old_uarm_disp = `static func build_archer_upper_arm_mesh(outfit: int = 2) -> ArrayMesh:
	if outfit == 1:
		return build_archer_upper_arm_mesh_outfit1()
	return build_archer_upper_arm_mesh_outfit2()`;
console.log('Archer uarm disp in vb:', vb.includes(old_uarm_disp));

const old_forearm_disp = `static func build_archer_forearm_mesh(is_right: bool, outfit: int = 2) -> ArrayMesh:
	if outfit == 1:
		return build_archer_forearm_mesh_outfit1(is_right)
	return build_archer_forearm_mesh_outfit2(is_right)`;
console.log('Archer forearm disp in vb:', vb.includes(old_forearm_disp));

const old_thigh_disp = `static func build_archer_thigh_mesh(outfit: int = 2) -> ArrayMesh:
	if outfit == 1:
		return build_archer_thigh_mesh_outfit1()
	return build_archer_thigh_mesh_outfit2()`;
console.log('Archer thigh disp in vb:', vb.includes(old_thigh_disp));

const old_shin_disp = `static func build_archer_shin_mesh(outfit: int = 2) -> ArrayMesh:
	if outfit == 1:
		return build_archer_shin_mesh_outfit1()
	return build_archer_shin_mesh_outfit2()`;
console.log('Archer shin disp in vb:', vb.includes(old_shin_disp));

// 3. Shaman checks
const old_shaman_head = `static func build_shaman_head_mesh(outfit: int = 1) -> ArrayMesh:
	if outfit == 2:
		return build_shaman_head_mesh_outfit2()
	return build_shaman_head_mesh_outfit1()`;
console.log('Shaman head disp in vb:', vb.includes(old_shaman_head));

const old_shaman_torso = `static func build_shaman_torso_mesh(outfit: int = 1) -> ArrayMesh:
	if outfit == 2:
		return build_shaman_torso_mesh_outfit2()
	return build_shaman_torso_mesh_outfit1()`;
console.log('Shaman torso disp in vb:', vb.includes(old_shaman_torso));
