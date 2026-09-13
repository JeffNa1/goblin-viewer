class_name GoblinRogue
extends Node3D

@onready var hips: Node3D = $VisualRoot/Hips
@onready var torso: Node3D = $VisualRoot/Hips/Torso
@onready var head: Node3D = $VisualRoot/Hips/Torso/Head
@onready var left_arm: Node3D = $VisualRoot/Hips/Torso/LeftArm
@onready var left_forearm: Node3D = $VisualRoot/Hips/Torso/LeftArm/LeftForearm
@onready var left_dagger: Node3D = $VisualRoot/Hips/Torso/LeftArm/LeftForearm/LeftDagger
@onready var right_arm: Node3D = $VisualRoot/Hips/Torso/RightArm
@onready var right_forearm: Node3D = $VisualRoot/Hips/Torso/RightArm/RightForearm
@onready var right_dagger: Node3D = $VisualRoot/Hips/Torso/RightArm/RightForearm/RightDagger
@onready var left_thigh: Node3D = $VisualRoot/Hips/LeftThigh
@onready var left_shin: Node3D = $VisualRoot/Hips/LeftThigh/LeftShin
@onready var right_thigh: Node3D = $VisualRoot/Hips/RightThigh
@onready var right_shin: Node3D = $VisualRoot/Hips/RightThigh/RightShin

@onready var torso_mesh: MeshInstance3D = $VisualRoot/Hips/Torso/TorsoMesh
@onready var head_mesh: MeshInstance3D = $VisualRoot/Hips/Torso/Head/HeadMesh
@onready var left_arm_mesh: MeshInstance3D = $VisualRoot/Hips/Torso/LeftArm/LeftArmMesh
@onready var left_forearm_mesh: MeshInstance3D = $VisualRoot/Hips/Torso/LeftArm/LeftForearm/LeftForearmMesh
@onready var left_dagger_mesh: MeshInstance3D = $VisualRoot/Hips/Torso/LeftArm/LeftForearm/LeftDagger/LeftDaggerMesh
@onready var right_arm_mesh: MeshInstance3D = $VisualRoot/Hips/Torso/RightArm/RightArmMesh
@onready var right_forearm_mesh: MeshInstance3D = $VisualRoot/Hips/Torso/RightArm/RightForearm/RightForearmMesh
@onready var right_dagger_mesh: MeshInstance3D = $VisualRoot/Hips/Torso/RightArm/RightForearm/RightDagger/RightDaggerMesh
@onready var left_thigh_mesh: MeshInstance3D = $VisualRoot/Hips/LeftThigh/LeftThighMesh
@onready var left_shin_mesh: MeshInstance3D = $VisualRoot/Hips/LeftThigh/LeftShin/LeftShinMesh
@onready var right_thigh_mesh: MeshInstance3D = $VisualRoot/Hips/RightThigh/RightThighMesh
@onready var right_shin_mesh: MeshInstance3D = $VisualRoot/Hips/RightThigh/RightShin/RightShinMesh

# State
var current_anim: String = "idle" # "idle", "walk", "scurry", "dual_slash", "backstab", "parry", "hurt", "stunned"
var base_anim: String = "idle"
var anim_time: float = 0.0
var anim_speed: float = 1.0

# Action Timers
var action_time: float = 0.0
const SLASH_DURATION: float = 1.05
const BACKSTAB_DURATION: float = 1.60
const PARRY_DURATION: float = 0.85
const HURT_DURATION: float = 0.52

# Blending
var is_blending: bool = false
var blend_timer: float = 0.0
const BLEND_DURATION: float = 0.18
var source_pose: Dictionary = {}
var current_pose: Dictionary = {}

var ground_hips_y: float = 0.588
var current_stance: String = "idle"
var is_in_editor: bool = false
var default_stance_configs: Dictionary = {}
var stance_configs: Dictionary = {}

# Stun Stars
const StunStarsScript = preload("res://scripts/stun_stars.gd")
var stun_stars: Node3D = null

# Weapon Trails
const WeaponTrailScript = preload("res://scripts/weapon_trail.gd")
var right_weapon_trail: Node3D = null
var left_weapon_trail: Node3D = null

# Outfit System: 1 = Thô Sơ (Primitive Scavenger), 2 = Sát Thủ (Shadow Assassin)
var current_outfit: int = 1
var outfit_meshes: Dictionary = {}
signal outfit_changed(outfit_id: int)

signal anim_changed(anim_name: String)

func _ready() -> void:
	generate_voxel_meshes()
	_init_stun_stars()
	_init_weapon_trails()
	_init_default_stances()
	load_stance_config()
	current_pose = _compute_pose(current_anim, 0.0)
	_apply_pose(current_pose)

func _init_default_stances() -> void:
	default_stance_configs = {
		"idle": {
			"right_arm_rot": Vector3(-15.0, 15.0, 18.0),
			"right_forearm_rot": Vector3(-62.0, 0.0, 0.0),
			"right_dagger_rot": Vector3(-85.0, 15.0, -15.0),
			"left_arm_rot": Vector3(-15.0, -15.0, -18.0),
			"left_forearm_rot": Vector3(-62.0, 0.0, 0.0),
			"left_dagger_rot": Vector3(-85.0, -15.0, 15.0),
			"torso_rot": Vector3(22.0, 0.0, 0.0),
			"head_rot": Vector3(-16.0, 0.0, 0.0)
		},
		"dual_guard": {
			"right_arm_rot": Vector3(-42.0, -15.0, 12.0),
			"right_forearm_rot": Vector3(-85.0, 0.0, 0.0),
			"right_dagger_rot": Vector3(80.0, -25.0, 40.0),
			"left_arm_rot": Vector3(-40.0, 15.0, -12.0),
			"left_forearm_rot": Vector3(-85.0, 0.0, 0.0),
			"left_dagger_rot": Vector3(80.0, 25.0, -40.0),
			"torso_rot": Vector3(14.0, 0.0, 0.0),
			"head_rot": Vector3(-8.0, 0.0, 0.0)
		},
		"reverse": {
			"right_arm_rot": Vector3(-15.0, 15.0, 18.0),
			"right_forearm_rot": Vector3(-62.0, 0.0, 0.0),
			"right_dagger_rot": Vector3(-85.0, 15.0, -15.0),
			"left_arm_rot": Vector3(-15.0, -15.0, -18.0),
			"left_forearm_rot": Vector3(-62.0, 0.0, 0.0),
			"left_dagger_rot": Vector3(-85.0, -15.0, 15.0),
			"torso_rot": Vector3(22.0, 0.0, 0.0),
			"head_rot": Vector3(-16.0, 0.0, 0.0)
		},
		"forward": {
			"right_arm_rot": Vector3(-25.0, -10.0, 16.0),
			"right_forearm_rot": Vector3(-65.0, 0.0, 0.0),
			"right_dagger_rot": Vector3(85.0, -15.0, 15.0),
			"left_arm_rot": Vector3(-25.0, 10.0, -16.0),
			"left_forearm_rot": Vector3(-65.0, 0.0, 0.0),
			"left_dagger_rot": Vector3(85.0, 15.0, -15.0),
			"torso_rot": Vector3(18.0, 0.0, 0.0),
			"head_rot": Vector3(-12.0, 0.0, 0.0)
		},
		"walk": {
			"right_arm_rot": Vector3(-15.0, 15.0, 18.0),
			"right_forearm_rot": Vector3(-62.0, 0.0, 0.0),
			"right_dagger_rot": Vector3(-85.0, 15.0, -15.0),
			"left_arm_rot": Vector3(-15.0, -15.0, -18.0),
			"left_forearm_rot": Vector3(-62.0, 0.0, 0.0),
			"left_dagger_rot": Vector3(-85.0, -15.0, 15.0),
			"torso_rot": Vector3(18.0, 0.0, 0.0),
			"head_rot": Vector3(-16.0, 0.0, 0.0)
		},
		"scurry": {
			"right_arm_rot": Vector3(-20.0, 18.0, 20.0),
			"right_forearm_rot": Vector3(-68.0, 0.0, 0.0),
			"right_dagger_rot": Vector3(-85.0, 15.0, -15.0),
			"left_arm_rot": Vector3(-20.0, -18.0, -20.0),
			"left_forearm_rot": Vector3(-68.0, 0.0, 0.0),
			"left_dagger_rot": Vector3(-85.0, -15.0, 15.0),
			"torso_rot": Vector3(24.0, 0.0, 0.0),
			"head_rot": Vector3(-22.0, 0.0, 0.0)
		},
		"dual_slash": {
			"right_arm_rot": Vector3(-15.0, 15.0, 18.0),
			"right_forearm_rot": Vector3(-62.0, 0.0, 0.0),
			"right_dagger_rot": Vector3(-85.0, 15.0, -15.0),
			"left_arm_rot": Vector3(-15.0, -15.0, -18.0),
			"left_forearm_rot": Vector3(-62.0, 0.0, 0.0),
			"left_dagger_rot": Vector3(-85.0, -15.0, 15.0),
			"torso_rot": Vector3(22.0, 0.0, 0.0),
			"head_rot": Vector3(-16.0, 0.0, 0.0)
		},
		"backstab": {
			"right_arm_rot": Vector3(-135.0, 0.0, 15.0),
			"right_forearm_rot": Vector3(-25.0, 0.0, 0.0),
			"right_dagger_rot": Vector3(170.0, -10.0, 10.0),
			"left_arm_rot": Vector3(-135.0, 0.0, -15.0),
			"left_forearm_rot": Vector3(-25.0, 0.0, 0.0),
			"left_dagger_rot": Vector3(170.0, 10.0, -10.0),
			"torso_rot": Vector3(-45.0, 0.0, 0.0),
			"head_rot": Vector3(15.0, 0.0, 0.0)
		},
		"parry": {
			"right_arm_rot": Vector3(-14.0, 18.0, 34.0),
			"right_forearm_rot": Vector3(-66.0, 0.0, 0.0),
			"right_dagger_rot": Vector3(-85.0, 18.0, -14.0),
			"left_arm_rot": Vector3(-14.0, -18.0, -34.0),
			"left_forearm_rot": Vector3(-66.0, 0.0, 0.0),
			"left_dagger_rot": Vector3(-85.0, -18.0, 14.0),
			"torso_rot": Vector3(-18.0, 0.0, 0.0),
			"head_rot": Vector3(12.0, 0.0, 0.0)
		},
		"hurt": {
			"right_arm_rot": Vector3(-22.0, 14.0, 36.0),
			"right_forearm_rot": Vector3(-65.0, 0.0, 0.0),
			"right_dagger_rot": Vector3(-85.0, 16.0, -14.0),
			"left_arm_rot": Vector3(-28.0, -16.0, -38.0),
			"left_forearm_rot": Vector3(-68.0, 0.0, 0.0),
			"left_dagger_rot": Vector3(-85.0, -16.0, 14.0),
			"torso_rot": Vector3(-22.0, -14.0, 6.0),
			"head_rot": Vector3(16.0, -18.0, 0.0)
		},
		"stunned": {
			"right_arm_rot": Vector3(-4.0, 12.0, 26.0),
			"right_forearm_rot": Vector3(-36.0, 0.0, 0.0),
			"right_dagger_rot": Vector3(-85.0, 20.0, -18.0),
			"left_arm_rot": Vector3(-4.0, -12.0, -26.0),
			"left_forearm_rot": Vector3(-36.0, 0.0, 0.0),
			"left_dagger_rot": Vector3(-85.0, -20.0, 18.0),
			"torso_rot": Vector3(14.0, 0.0, 0.0),
			"head_rot": Vector3(-6.0, 0.0, 0.0)
		}
	}

func load_stance_config() -> void:
	if default_stance_configs.is_empty() and has_method("_init_default_stances"):
		_init_default_stances()
	stance_configs = {}
	for k in default_stance_configs:
		stance_configs[k] = default_stance_configs[k].duplicate()
		
	var r_cfg: Dictionary = {}
	
	# 1. Check res://data/stance_config.json
	var res_path = "res://data/stance_config.json"
	if FileAccess.file_exists(res_path):
		var f = FileAccess.open(res_path, FileAccess.READ)
		if f:
			var txt = f.get_as_text()
			f.close()
			var json = JSON.new()
			if json.parse(txt) == OK and json.data is Dictionary:
				var d: Dictionary = json.data
				if d.has("rogue") and d["rogue"] is Dictionary:
					r_cfg = d["rogue"].duplicate()
					
	# 2. Check user://stance_config.json for overrides
	var user_path = "user://stance_config.json"
	if FileAccess.file_exists(user_path):
		var f_u = FileAccess.open(user_path, FileAccess.READ)
		if f_u:
			var txt_u = f_u.get_as_text()
			f_u.close()
			var json_u = JSON.new()
			if json_u.parse(txt_u) == OK and json_u.data is Dictionary:
				var d_u: Dictionary = json_u.data
				if d_u.has("rogue") and d_u["rogue"] is Dictionary:
					for k in d_u["rogue"]:
						r_cfg[k] = d_u["rogue"][k]
						
	if r_cfg.has("ground_hips_y"):
		ground_hips_y = float(r_cfg["ground_hips_y"])
		
	for s_key in r_cfg:
		if s_key == "ground_hips_y":
			continue
		if r_cfg[s_key] is Dictionary:
			if not stance_configs.has(s_key):
				stance_configs[s_key] = {}
			var s_dict = r_cfg[s_key]
			for prop in ["right_arm_rot", "right_forearm_rot", "right_dagger_rot", "left_arm_rot", "left_forearm_rot", "left_dagger_rot", "torso_rot", "head_rot"]:
				if s_dict.has(prop) and s_dict[prop] is Array and s_dict[prop].size() == 3:
					stance_configs[s_key][prop] = Vector3(float(s_dict[prop][0]), float(s_dict[prop][1]), float(s_dict[prop][2]))

func get_stance_definitions() -> Array:
	return [
		{"id": "idle", "name": "Dao Ngược", "shortcut": "[ Q ]"},
		{"id": "dual_guard", "name": "Bắt Chéo X", "shortcut": "[ W ]"},
		{"id": "forward", "name": "Dao Xuôi", "shortcut": "[ E ]"},
		{"id": "walk", "name": "Lẻn Đi", "shortcut": "[ 1 ]"},
		{"id": "scurry", "name": "Lướt Nhanh", "shortcut": "[ 2 ]"},
		{"id": "dual_slash", "name": "Chém Chéo X", "shortcut": "[ 3 ]"},
		{"id": "backstab", "name": "Đâm Lén", "shortcut": "[ 4 ]"},
		{"id": "parry", "name": "Gạt Dao", "shortcut": "[ 5 ]"},
		{"id": "hurt", "name": "Trúng Đòn", "shortcut": "[ 6 ]"},
		{"id": "stunned", "name": "Choáng", "shortcut": "[ 7 ]"}
	]

func set_editor_mode(val: bool) -> void:
	is_in_editor = val
	if is_in_editor:
		is_blending = false
		_stop_all_weapon_trails()
	current_pose = _compute_pose(current_anim, anim_time)
	_apply_pose(current_pose)

func get_weapon_info() -> Dictionary:
	var title = "👑 SONG HOÀNG KIM ĐOẢN KIẾM (GÓC LƯỠI DAO)" if current_outfit == 3 else ("🥷 SONG DAO GĂM SÁT THỦ (GÓC LƯỠI DAO)" if current_outfit == 2 else "🗡️ DAO XƯƠNG & ĐÁ ĐẼO (GÓC LƯỠI DAO)")
	return {
		"title": title,
		"prop": "right_dagger_rot"
	}

func copy_weapon_from_idle(target_anim: String) -> void:
	if not stance_configs.has("idle") or not stance_configs.has(target_anim):
		return
	var src = stance_configs["idle"]
	var dst = stance_configs[target_anim]
	if src.has("right_dagger_rot"):
		dst["right_dagger_rot"] = src["right_dagger_rot"]
	if src.has("left_dagger_rot"):
		dst["left_dagger_rot"] = src["left_dagger_rot"]

func serialize_stances() -> Dictionary:
	if default_stance_configs.is_empty() and has_method("_init_default_stances"):
		_init_default_stances()
	var out: Dictionary = {
		"ground_hips_y": ground_hips_y
	}
	for s_key in stance_configs:
		out[s_key] = _serialize_stance(stance_configs[s_key])
	return out

func save_stance_config() -> bool:
	var master_cfg: Dictionary = {}
	
	# 1. Read existing from res://data/stance_config.json if available
	var res_path = "res://data/stance_config.json"
	if FileAccess.file_exists(res_path):
		var f_in = FileAccess.open(res_path, FileAccess.READ)
		if f_in:
			var json = JSON.new()
			if json.parse(f_in.get_as_text()) == OK and json.data is Dictionary:
				master_cfg = json.data
			f_in.close()
			
	# 2. Merge user://stance_config.json if available
	var user_path = "user://stance_config.json"
	if FileAccess.file_exists(user_path):
		var f_u = FileAccess.open(user_path, FileAccess.READ)
		if f_u:
			var txt_u = f_u.get_as_text()
			f_u.close()
			var json_u = JSON.new()
			if json_u.parse(txt_u) == OK and json_u.data is Dictionary:
				for k in json_u.data:
					master_cfg[k] = json_u.data[k]
					
	# 3. Save rogue stances
	master_cfg["rogue"] = serialize_stances()
	
	# 4. Save to user:// (guaranteed writable)
	var f_out_user = FileAccess.open(user_path, FileAccess.WRITE)
	if f_out_user:
		f_out_user.store_string(JSON.stringify(master_cfg, "\t"))
		f_out_user.close()
		
	# 5. Save to res:// (dev environment)
	var f_out_res = FileAccess.open(res_path, FileAccess.WRITE)
	if f_out_res:
		f_out_res.store_string(JSON.stringify(master_cfg, "\t"))
		f_out_res.close()
		
	return true

func _serialize_stance(s: Dictionary) -> Dictionary:
	var out = {}
	for k in ["right_arm_rot", "right_forearm_rot", "right_dagger_rot", "left_arm_rot", "left_forearm_rot", "left_dagger_rot", "torso_rot", "head_rot"]:
		var v: Vector3 = s.get(k, Vector3.ZERO)
		out[k] = [snappedf(v.x, 0.1), snappedf(v.y, 0.1), snappedf(v.z, 0.1)]
	return out

func set_stance(st_name: String) -> void:
	if current_stance == st_name and current_anim == st_name:
		return
	current_stance = st_name
	play_anim(st_name)

func reset_stance_to_default(s_name: String) -> void:
	if default_stance_configs.has(s_name):
		stance_configs[s_name] = default_stance_configs[s_name].duplicate()
		if current_stance == s_name or current_anim == s_name:
			current_pose = _compute_pose(current_anim, anim_time)
			_apply_pose(current_pose)

func update_live_stance(s_name: String, prop: String, val: Variant) -> void:
	if not stance_configs.has(s_name):
		stance_configs[s_name] = {}
	stance_configs[s_name][prop] = val
	if prop == "right_dagger_rot" and val is Vector3:
		stance_configs[s_name]["left_dagger_rot"] = Vector3(val.x, -val.y, -val.z)
	if s_name in ["idle", "dual_guard", "forward"]:
		current_stance = s_name
	current_pose = _compute_pose(current_anim, anim_time)
	_apply_pose(current_pose)

func set_live_ground_hips_y(val: float) -> void:
	ground_hips_y = val
	current_pose = _compute_pose(current_anim, anim_time)
	_apply_pose(current_pose)

func _lerp_angles(a: Vector3, b: Vector3, weight: float) -> Vector3:
	return Vector3(
		lerpf(a.x, b.x, weight),
		lerpf(a.y, b.y, weight),
		lerpf(a.z, b.z, weight)
	)

# 3-Point Non-Clipping Outward Dagger Flip via Quaternion Slerp
# Ensures blade rolls laterally away from the forearm through mid_rot instead of slicing through the arm
func _compute_dagger_flip(base_rot: Vector3, mid_rot: Vector3, fwd_rot: Vector3, t: float) -> Vector3:
	var q1 = Basis.from_euler(Vector3(deg_to_rad(base_rot.x), deg_to_rad(base_rot.y), deg_to_rad(base_rot.z))).get_rotation_quaternion()
	var q2 = Basis.from_euler(Vector3(deg_to_rad(mid_rot.x), deg_to_rad(mid_rot.y), deg_to_rad(mid_rot.z))).get_rotation_quaternion()
	var q3 = Basis.from_euler(Vector3(deg_to_rad(fwd_rot.x), deg_to_rad(fwd_rot.y), deg_to_rad(fwd_rot.z))).get_rotation_quaternion()
	var res_q: Quaternion
	if t < 0.5:
		var st = smoothstep(0.0, 1.0, t * 2.0)
		res_q = q1.slerp(q2, st)
	else:
		var st = smoothstep(0.0, 1.0, (t - 0.5) * 2.0)
		res_q = q2.slerp(q3, st)
	var euler = Basis(res_q).get_euler()
	return Vector3(rad_to_deg(euler.x), rad_to_deg(euler.y), rad_to_deg(euler.z))

func generate_voxel_meshes() -> void:
	# Pre-build meshes for Outfit 1 (Thô Sơ / Primitive Scavenger)
	outfit_meshes[1] = {
		"head": VoxelBuilder.build_rogue_head_mesh(1),
		"torso": VoxelBuilder.build_rogue_torso_mesh(1),
		"left_arm": VoxelBuilder.build_rogue_upper_arm_mesh(1),
		"left_forearm": VoxelBuilder.build_rogue_forearm_mesh(false, 1),
		"right_arm": VoxelBuilder.build_rogue_upper_arm_mesh(1),
		"right_forearm": VoxelBuilder.build_rogue_forearm_mesh(true, 1),
		"left_dagger": VoxelBuilder.build_dagger_mesh(1),
		"right_dagger": VoxelBuilder.build_dagger_mesh(1),
		"left_thigh": VoxelBuilder.build_rogue_thigh_mesh(1),
		"left_shin": VoxelBuilder.build_rogue_shin_mesh(1),
		"right_thigh": VoxelBuilder.build_rogue_thigh_mesh(1),
		"right_shin": VoxelBuilder.build_rogue_shin_mesh(1)
	}
	# Pre-build meshes for Outfit 2 (Sát Thủ / Shadow Assassin)
	outfit_meshes[2] = {
		"head": VoxelBuilder.build_rogue_head_mesh(2),
		"torso": VoxelBuilder.build_rogue_torso_mesh(2),
		"left_arm": VoxelBuilder.build_rogue_upper_arm_mesh(2),
		"left_forearm": VoxelBuilder.build_rogue_forearm_mesh(false, 2),
		"right_arm": VoxelBuilder.build_rogue_upper_arm_mesh(2),
		"right_forearm": VoxelBuilder.build_rogue_forearm_mesh(true, 2),
		"left_dagger": VoxelBuilder.build_dagger_mesh(2),
		"right_dagger": VoxelBuilder.build_dagger_mesh(2),
		"left_thigh": VoxelBuilder.build_rogue_thigh_mesh(2),
		"left_shin": VoxelBuilder.build_rogue_shin_mesh(2),
		"right_thigh": VoxelBuilder.build_rogue_thigh_mesh(2),
		"right_shin": VoxelBuilder.build_rogue_shin_mesh(2)
	}
	# Pre-build meshes for Outfit 3 (Hoàng Kim / Imperial Golden Assassin)
	outfit_meshes[3] = {
		"head": VoxelBuilder.build_rogue_head_mesh(3),
		"torso": VoxelBuilder.build_rogue_torso_mesh(3),
		"left_arm": VoxelBuilder.build_rogue_upper_arm_mesh(3),
		"left_forearm": VoxelBuilder.build_rogue_forearm_mesh(false, 3),
		"right_arm": VoxelBuilder.build_rogue_upper_arm_mesh(3),
		"right_forearm": VoxelBuilder.build_rogue_forearm_mesh(true, 3),
		"left_dagger": VoxelBuilder.build_dagger_mesh(3),
		"right_dagger": VoxelBuilder.build_dagger_mesh(3),
		"left_thigh": VoxelBuilder.build_rogue_thigh_mesh(3),
		"left_shin": VoxelBuilder.build_rogue_shin_mesh(3),
		"right_thigh": VoxelBuilder.build_rogue_thigh_mesh(3),
		"right_shin": VoxelBuilder.build_rogue_shin_mesh(3)
	}
	apply_outfit(current_outfit)

func set_outfit(outfit_id: int) -> void:
	current_outfit = clamp(outfit_id, 1, 3)
	apply_outfit(current_outfit)
	outfit_changed.emit(current_outfit)

func apply_outfit(outfit_id: int) -> void:
	if not outfit_meshes.has(outfit_id):
		return
	var m: Dictionary = outfit_meshes[outfit_id]
	head_mesh.mesh = m["head"]
	torso_mesh.mesh = m["torso"]
	left_arm_mesh.mesh = m["left_arm"]
	left_forearm_mesh.mesh = m["left_forearm"]
	right_arm_mesh.mesh = m["right_arm"]
	right_forearm_mesh.mesh = m["right_forearm"]
	left_dagger_mesh.mesh = m["left_dagger"]
	right_dagger_mesh.mesh = m["right_dagger"]
	left_thigh_mesh.mesh = m["left_thigh"]
	left_shin_mesh.mesh = m["left_shin"]
	right_thigh_mesh.mesh = m["right_thigh"]
	right_shin_mesh.mesh = m["right_shin"]

func _init_stun_stars() -> void:
	stun_stars = StunStarsScript.new()
	stun_stars.name = "StunStarsFX"
	head.add_child(stun_stars)

func _init_weapon_trails() -> void:
	right_weapon_trail = WeaponTrailScript.new()
	right_weapon_trail.name = "RightWeaponTrail"
	right_weapon_trail.tip_offset = Vector3(0.0, 0.46, 0.15)
	right_weapon_trail.base_offset = Vector3(0.0, 0.04, 0.0)
	$VisualRoot.add_child(right_weapon_trail)
	right_weapon_trail.set_target(right_dagger)
	
	left_weapon_trail = WeaponTrailScript.new()
	left_weapon_trail.name = "LeftWeaponTrail"
	left_weapon_trail.tip_offset = Vector3(0.0, 0.46, 0.15)
	left_weapon_trail.base_offset = Vector3(0.0, 0.04, 0.0)
	$VisualRoot.add_child(left_weapon_trail)
	left_weapon_trail.set_target(left_dagger)

func _update_weapon_trails(t_act: float) -> void:
	if not right_weapon_trail or not left_weapon_trail:
		return
		
	if current_anim == "dual_slash":
		var tau = clampf(t_act / SLASH_DURATION, 0.0, 1.0)
		var col_tip = Color(0.35, 1.0, 0.80, 0.98)
		var col_base = Color(0.06, 0.65, 0.35, 0.85)
		if current_outfit == 3:
			col_tip = Color(1.0, 0.88, 0.35, 0.98) # Radiant imperial gold
			col_base = Color(0.95, 0.25, 0.15, 0.85) # Imperial ruby flame
		elif current_outfit == 2:
			col_tip = Color(0.25, 1.0, 0.95, 0.98)
			col_base = Color(0.08, 0.45, 0.40, 0.85)
		
		# Strike 1: Right Upward Slash (tau in [0.16, 0.38])
		if tau >= 0.16 and tau < 0.38:
			if not right_weapon_trail.is_emitting:
				right_weapon_trail.start_trail(col_tip, col_base, 0.22)
		else:
			if right_weapon_trail.is_emitting:
				right_weapon_trail.stop_trail()
				
		# Strike 2: Left Upward Slash (tau in [0.50, 0.72])
		if tau >= 0.50 and tau < 0.72:
			if not left_weapon_trail.is_emitting:
				left_weapon_trail.start_trail(col_tip, col_base, 0.22)
		else:
			if left_weapon_trail.is_emitting:
				left_weapon_trail.stop_trail()
				
	elif current_anim == "backstab":
		var tau = clampf(t_act / BACKSTAB_DURATION, 0.0, 1.0)
		var blood_tip = Color(1.0, 0.22, 0.30, 0.98)
		var blood_base = Color(0.65, 0.04, 0.10, 0.85)
		# Thrust & Lateral Tear Outward (tau in [0.28, 0.74])
		if tau >= 0.28 and tau < 0.74:
			if not right_weapon_trail.is_emitting:
				right_weapon_trail.start_trail(blood_tip, blood_base, 0.28)
			if not left_weapon_trail.is_emitting:
				left_weapon_trail.start_trail(blood_tip, blood_base, 0.28)
		else:
			if right_weapon_trail.is_emitting:
				right_weapon_trail.stop_trail()
			if left_weapon_trail.is_emitting:
				left_weapon_trail.stop_trail()
	else:
		_stop_all_weapon_trails()

func _stop_all_weapon_trails() -> void:
	if right_weapon_trail and right_weapon_trail.is_emitting:
		right_weapon_trail.stop_trail()
	if left_weapon_trail and left_weapon_trail.is_emitting:
		left_weapon_trail.stop_trail()

func play_anim(anim_name: String) -> void:
	if current_anim == anim_name and current_anim not in ["dual_slash", "backstab", "parry", "hurt"]:
		return
	_stop_all_weapon_trails()
	_start_blend()
	current_anim = anim_name
	action_time = 0.0
	
	if current_anim in ["idle", "dual_guard", "reverse", "walk", "scurry", "stunned"]:
		base_anim = current_anim
		
	if stun_stars:
		stun_stars.set_active(current_anim == "stunned")
		
	emit_signal("anim_changed", current_anim)

func set_speed(val: float) -> void:
	anim_speed = clampf(val, 0.2, 3.0)

func _start_blend() -> void:
	source_pose = current_pose.duplicate(true)
	blend_timer = 0.0
	is_blending = true

func _process(delta: float) -> void:
	var dt = delta * anim_speed
	anim_time += dt
	
	if current_anim in ["dual_slash", "backstab", "parry", "hurt"]:
		if not is_in_editor:
			action_time += dt
			if current_anim == "dual_slash":
				_update_weapon_trails(action_time)
				if action_time >= SLASH_DURATION:
					_stop_all_weapon_trails()
					current_anim = base_anim
					action_time = 0.0
					_start_blend()
					emit_signal("anim_changed", current_anim)
			elif current_anim == "backstab":
				_update_weapon_trails(action_time)
				if action_time >= BACKSTAB_DURATION:
					_stop_all_weapon_trails()
					current_anim = base_anim
					action_time = 0.0
					_start_blend()
					emit_signal("anim_changed", current_anim)
			elif current_anim == "parry":
				if action_time >= PARRY_DURATION:
					current_anim = base_anim
					action_time = 0.0
					_start_blend()
					emit_signal("anim_changed", current_anim)
			elif current_anim == "hurt":
				if action_time >= HURT_DURATION:
					current_anim = base_anim
					action_time = 0.0
					_start_blend()
					emit_signal("anim_changed", current_anim)
		else:
			action_time = 0.45 # Hold apex pose in editor
			
	if stun_stars:
		stun_stars.set_active(current_anim == "stunned")
		
	var eval_time = action_time if current_anim in ["dual_slash", "backstab", "parry", "hurt"] else anim_time
	var target_pose = _compute_pose(current_anim, eval_time)
	
	if is_blending and not is_in_editor:
		blend_timer += dt
		var factor = clampf(blend_timer / BLEND_DURATION, 0.0, 1.0)
		var smooth_f = smoothstep(0.0, 1.0, factor)
		current_pose = _blend_poses(source_pose, target_pose, smooth_f)
		if factor >= 1.0:
			is_blending = false
	else:
		current_pose = target_pose
		
	_apply_pose(current_pose)

func _compute_pose(anim: String, time_val: float) -> Dictionary:
	var p: Dictionary = {}
	match anim:
		"idle": p = _compute_idle(time_val)
		"dual_guard": p = _compute_dual_guard(time_val)
		"reverse": p = _compute_idle(time_val)
		"forward": p = _compute_forward(time_val)
		"walk": p = _compute_walk(time_val)
		"scurry": p = _compute_scurry(time_val)
		"dual_slash": p = _compute_dual_slash(time_val)
		"backstab": p = _compute_backstab(time_val)
		"parry": p = _compute_parry(time_val)
		"hurt": p = _compute_hurt(time_val)
		"stunned": p = _compute_stunned(time_val)
		_: p = _compute_idle(time_val)

	if is_in_editor and stance_configs.has(anim):
		var cfg = stance_configs[anim]
		for k in ["right_arm_rot", "right_forearm_rot", "right_dagger_rot", "left_arm_rot", "left_forearm_rot", "left_dagger_rot", "torso_rot", "head_rot"]:
			if cfg.has(k):
				p[k] = cfg[k]
		p["hips_pos"] = Vector3(p.get("hips_pos", Vector3.ZERO).x, ground_hips_y, p.get("hips_pos", Vector3.ZERO).z)

	return p

# --- 1. IDLE (Low Stalking Reverse Grip Crouch - Default Stance) ---
func _compute_idle(time_val: float) -> Dictionary:
	var p: Dictionary = {}
	var t = time_val * 3.2
	var bob = sin(t) * 0.012
	var cfg = stance_configs.get("idle", default_stance_configs.get("idle", {}))
	
	p["hips_pos"] = Vector3(0.0, ground_hips_y + bob, 0.0)
	p["hips_rot"] = Vector3(12.0, sin(t * 0.5) * 5.0, 0.0)
	p["torso_rot"] = cfg.get("torso_rot", Vector3(22.0, 0.0, 0.0)) + Vector3(sin(t) * 1.8, 0, 0)
	p["head_rot"] = cfg.get("head_rot", Vector3(-16.0, 0.0, 0.0)) + Vector3(0, sin(t * 0.7) * 8.0, 0)
	
	p["left_arm_rot"] = cfg.get("left_arm_rot", Vector3(-15.0, -15.0, -18.0)) + Vector3(-bob * 20.0, 0, 0)
	p["left_forearm_rot"] = cfg.get("left_forearm_rot", Vector3(-62.0, 0.0, 0.0))
	var base_dag_r: Vector3 = cfg.get("right_dagger_rot", Vector3(-85.0, 15.0, -15.0))
	var base_dag_l: Vector3 = cfg.get("left_dagger_rot", Vector3(-85.0, -15.0, 15.0))
	p["left_dagger_rot"] = base_dag_l
	
	p["right_arm_rot"] = cfg.get("right_arm_rot", Vector3(-15.0, 15.0, 18.0)) + Vector3(bob * 20.0, 0, 0)
	p["right_forearm_rot"] = cfg.get("right_forearm_rot", Vector3(-62.0, 0.0, 0.0))
	p["right_dagger_rot"] = base_dag_r
	
	# Low athletic predatory crouch
	p["left_thigh_rot"] = Vector3(-18.0, 0.0, -8.0)
	p["left_shin_rot"] = Vector3(28.0, 0.0, 0.0)
	p["right_thigh_rot"] = Vector3(12.0, 0.0, 8.0)
	p["right_shin_rot"] = Vector3(24.0, 0.0, 0.0)
	return p

# --- DUAL GUARD (Bắt Chéo X) ---
func _compute_dual_guard(time_val: float) -> Dictionary:
	var p: Dictionary = {}
	var t = time_val * 2.5
	var bob = sin(t) * 0.008
	var cfg = stance_configs.get("dual_guard", default_stance_configs.get("dual_guard", {}))
	
	p["hips_pos"] = Vector3(0.0, ground_hips_y + bob, 0.0)
	p["hips_rot"] = Vector3(10.0, 0.0, 0.0)
	p["torso_rot"] = cfg.get("torso_rot", Vector3(14.0, 0.0, 0.0)) + Vector3(sin(t) * 1.5, 0, 0)
	p["head_rot"] = cfg.get("head_rot", Vector3(-8.0, 0.0, 0.0))
	
	var base_dag_r: Vector3 = cfg.get("right_dagger_rot", Vector3(80.0, -25.0, 40.0))
	var base_dag_l: Vector3 = cfg.get("left_dagger_rot", Vector3(80.0, 25.0, -40.0))
	
	p["left_arm_rot"] = cfg.get("left_arm_rot", Vector3(-40.0, 15.0, -12.0))
	p["left_forearm_rot"] = cfg.get("left_forearm_rot", Vector3(-85.0, 0.0, 0.0))
	p["left_dagger_rot"] = base_dag_l
	
	p["right_arm_rot"] = cfg.get("right_arm_rot", Vector3(-42.0, -15.0, 12.0))
	p["right_forearm_rot"] = cfg.get("right_forearm_rot", Vector3(-85.0, 0.0, 0.0))
	p["right_dagger_rot"] = base_dag_r
	
	p["left_thigh_rot"] = Vector3(-12.0, 0.0, -6.0)
	p["left_shin_rot"] = Vector3(20.0, 0.0, 0.0)
	p["right_thigh_rot"] = Vector3(8.0, 0.0, 6.0)
	p["right_shin_rot"] = Vector3(18.0, 0.0, 0.0)
	return p

# --- REVERSE (Dao Ngược - Alias to Idle) ---
func _compute_reverse(time_val: float) -> Dictionary:
	return _compute_idle(time_val)

# --- FORWARD GRIP (Dao Xuôi) ---
func _compute_forward(time_val: float) -> Dictionary:
	var p: Dictionary = {}
	var t = time_val * 3.0
	var bob = sin(t) * 0.012
	var cfg = stance_configs.get("forward", default_stance_configs.get("forward", {}))
	
	p["hips_pos"] = Vector3(0.0, ground_hips_y + bob, 0.0)
	p["hips_rot"] = Vector3(8.0, sin(t * 0.5) * 4.0, 0.0)
	p["torso_rot"] = cfg.get("torso_rot", Vector3(18.0, 0.0, 0.0)) + Vector3(sin(t) * 2.0, 0, 0)
	p["head_rot"] = cfg.get("head_rot", Vector3(-12.0, 0.0, 0.0)) + Vector3(0, sin(t * 0.8) * 12.0, 0)
	
	p["left_arm_rot"] = cfg.get("left_arm_rot", Vector3(-25.0, 10.0, -16.0)) + Vector3(-bob * 30.0, 0, 0)
	p["left_forearm_rot"] = cfg.get("left_forearm_rot", Vector3(-65.0, 0.0, 0.0))
	var base_dag_r: Vector3 = cfg.get("right_dagger_rot", Vector3(85.0, -15.0, 15.0))
	var base_dag_l: Vector3 = cfg.get("left_dagger_rot", Vector3(85.0, 15.0, -15.0))
	p["left_dagger_rot"] = base_dag_l
	
	p["right_arm_rot"] = cfg.get("right_arm_rot", Vector3(-25.0, -10.0, 16.0)) + Vector3(bob * 30.0, 0, 0)
	p["right_forearm_rot"] = cfg.get("right_forearm_rot", Vector3(-65.0, 0.0, 0.0))
	p["right_dagger_rot"] = base_dag_r
	
	p["left_thigh_rot"] = Vector3(-16.0, 0.0, -6.0)
	p["left_shin_rot"] = Vector3(26.0, 0.0, 0.0)
	p["right_thigh_rot"] = Vector3(10.0, 0.0, 6.0)
	p["right_shin_rot"] = Vector3(22.0, 0.0, 0.0)
	return p

# --- 2. WALK (Silent Prowling Stride - Reverse Grip) ---
func _compute_walk(time_val: float) -> Dictionary:
	var p: Dictionary = {}
	var t = time_val * 4.8
	var s_leg = sin(t)
	
	p["hips_pos"] = Vector3(0.0, ground_hips_y + abs(sin(t * 2.0)) * 0.018, 0.0)
	p["hips_rot"] = Vector3(12.0, s_leg * 8.0, 0.0)
	p["torso_rot"] = Vector3(18.0, -s_leg * 6.0, 0.0)
	p["head_rot"] = Vector3(-16.0, 0.0, 0.0)
	
	p["left_thigh_rot"] = Vector3(-s_leg * 30.0, 0.0, 0.0)
	p["left_shin_rot"] = Vector3(maxf(0.0, s_leg * 36.0), 0.0, 0.0)
	p["right_thigh_rot"] = Vector3(s_leg * 30.0, 0.0, 0.0)
	p["right_shin_rot"] = Vector3(maxf(0.0, -s_leg * 36.0), 0.0, 0.0)
	
	var st_key = "walk" if stance_configs.has("walk") else current_stance
	var cfg = stance_configs.get(st_key, default_stance_configs.get(st_key, default_stance_configs.get("idle", {})))
	var base_dag_r: Vector3 = cfg.get("right_dagger_rot", Vector3(-85.0, 15.0, -15.0))
	var base_dag_l: Vector3 = cfg.get("left_dagger_rot", Vector3(-85.0, -15.0, 15.0))
	var base_r_arm: Vector3 = cfg.get("right_arm_rot", Vector3(-15.0, 15.0, 18.0))
	var base_r_fore: Vector3 = cfg.get("right_forearm_rot", Vector3(-62.0, 0.0, 0.0))
	var base_l_arm: Vector3 = cfg.get("left_arm_rot", Vector3(-15.0, -15.0, -18.0))
	var base_l_fore: Vector3 = cfg.get("left_forearm_rot", Vector3(-62.0, 0.0, 0.0))
	
	p["left_arm_rot"] = base_l_arm + Vector3(-s_leg * 16.0, 0.0, 0.0)
	p["left_forearm_rot"] = base_l_fore
	p["left_dagger_rot"] = base_dag_l + Vector3(-sin(t) * 3.0, 0.0, 0.0)
	
	p["right_arm_rot"] = base_r_arm + Vector3(s_leg * 16.0, 0.0, 0.0)
	p["right_forearm_rot"] = base_r_fore
	p["right_dagger_rot"] = base_dag_r + Vector3(sin(t) * 3.0, 0.0, 0.0)
	return p

# --- 3. SCURRY (Low Profile Ninja Sprint - Reverse Grip) ---
func _compute_scurry(time_val: float) -> Dictionary:
	var p: Dictionary = {}
	var t = time_val * 8.5
	var s_leg = sin(t)
	
	p["hips_pos"] = Vector3(0.0, ground_hips_y - 0.04 + abs(sin(t * 2.0)) * 0.025, 0.0)
	p["hips_rot"] = Vector3(22.0, s_leg * 14.0, 0.0)
	p["torso_rot"] = Vector3(24.0, -s_leg * 12.0, 0.0)
	p["head_rot"] = Vector3(-22.0, 0.0, 0.0)
	
	p["left_thigh_rot"] = Vector3(-s_leg * 48.0, 0.0, 0.0)
	p["left_shin_rot"] = Vector3(maxf(0.0, s_leg * 58.0), 0.0, 0.0)
	p["right_thigh_rot"] = Vector3(s_leg * 48.0, 0.0, 0.0)
	p["right_shin_rot"] = Vector3(maxf(0.0, -s_leg * 58.0), 0.0, 0.0)
	
	var st_key = "scurry" if stance_configs.has("scurry") else current_stance
	var cfg = stance_configs.get(st_key, default_stance_configs.get(st_key, default_stance_configs.get("idle", {})))
	var base_dag_r: Vector3 = cfg.get("right_dagger_rot", Vector3(-85.0, 15.0, -15.0))
	var base_dag_l: Vector3 = cfg.get("left_dagger_rot", Vector3(-85.0, -15.0, 15.0))
	var base_r_arm: Vector3 = cfg.get("right_arm_rot", Vector3(-20.0, 18.0, 20.0))
	var base_r_fore: Vector3 = cfg.get("right_forearm_rot", Vector3(-68.0, 0.0, 0.0))
	var base_l_arm: Vector3 = cfg.get("left_arm_rot", Vector3(-20.0, -18.0, -20.0))
	var base_l_fore: Vector3 = cfg.get("left_forearm_rot", Vector3(-68.0, 0.0, 0.0))
	
	p["left_arm_rot"] = base_l_arm + Vector3(-s_leg * 28.0, 0.0, 0.0)
	p["left_forearm_rot"] = base_l_fore
	p["left_dagger_rot"] = base_dag_l + Vector3(-sin(t) * 6.0, 0.0, 0.0)
	
	p["right_arm_rot"] = base_r_arm + Vector3(s_leg * 28.0, 0.0, 0.0)
	p["right_forearm_rot"] = base_r_fore
	p["right_dagger_rot"] = base_dag_r + Vector3(sin(t) * 6.0, 0.0, 0.0)
	return p

# --- 4. DUAL SLASH (2-Hit Sequential Reverse UPWARD Diagonal Slash Combo) ---
# Strike 1: Right hand upward diagonal rip from below right hip up past chin/left shoulder
# Strike 2: Left hand upward diagonal rip from below left hip up past chin/right shoulder
# Weight: Low scoop dips, explosive upward rising momentum, dynamic torso uncoiling & grounded combat lunges
func _compute_dual_slash(t_s: float) -> Dictionary:
	var p: Dictionary = {}
	var tau = clampf(t_s / SLASH_DURATION, 0.0, 1.0)
	
	var st_key = "idle"
	var cfg = stance_configs.get(st_key, default_stance_configs.get(st_key, {}))
	var base_dag_r: Vector3 = cfg.get("right_dagger_rot", Vector3(-85.0, 15.0, -15.0))
	var base_dag_l: Vector3 = cfg.get("left_dagger_rot", Vector3(-85.0, -15.0, 15.0))
	var base_r_arm: Vector3 = cfg.get("right_arm_rot", Vector3(-15.0, 15.0, 18.0))
	var base_r_fore: Vector3 = cfg.get("right_forearm_rot", Vector3(-62.0, 0.0, 0.0))
	var base_l_arm: Vector3 = cfg.get("left_arm_rot", Vector3(-15.0, -15.0, -18.0))
	var base_l_fore: Vector3 = cfg.get("left_forearm_rot", Vector3(-62.0, 0.0, 0.0))
	var base_torso: Vector3 = cfg.get("torso_rot", Vector3(22.0, 0.0, 0.0))
	var base_head: Vector3 = cfg.get("head_rot", Vector3(-16.0, 0.0, 0.0))
	
	if tau < 0.16:
		# PHASE 1: WINDUP & SCOOP DIP RIGHT (0.00s - 0.168s)
		# Drops low into crouching scoop on right flank, pulls right reverse blade low and back behind hip
		var u = tau / 0.16
		var s = smoothstep(0.0, 1.0, u)
		
		p["hips_pos"] = Vector3(0.0, ground_hips_y - 0.04 * s, -0.05 * s)
		p["hips_rot"] = Vector3(12.0, 14.0 * s, 0.0)
		p["torso_rot"] = Vector3(lerp(base_torso.x, 26.0, s), lerp(base_torso.y, 22.0, s), lerp(base_torso.z, 6.0, s))
		p["head_rot"] = Vector3(lerp(base_head.x, -16.0, s), lerp(base_head.y, -22.0, s), 0.0)
		
		p["right_arm_rot"] = _lerp_angles(base_r_arm, Vector3(18.0, 18.0, 18.0), s)
		p["right_forearm_rot"] = _lerp_angles(base_r_fore, Vector3(-45.0, 0.0, 0.0), s)
		p["right_dagger_rot"] = _lerp_angles(base_dag_r, Vector3(-85.0, 15.0, -15.0), s)
		
		p["left_arm_rot"] = _lerp_angles(base_l_arm, Vector3(-35.0, -10.0, -15.0), s)
		p["left_forearm_rot"] = _lerp_angles(base_l_fore, Vector3(-75.0, 0.0, 0.0), s)
		p["left_dagger_rot"] = _lerp_angles(base_dag_l, Vector3(-85.0, -15.0, 15.0), s)
		
		p["left_thigh_rot"] = Vector3(lerp(-18.0, -24.0, s), 0.0, -8.0)
		p["left_shin_rot"] = Vector3(lerp(28.0, 36.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(12.0, 18.0, s), 0.0, 8.0)
		p["right_shin_rot"] = Vector3(lerp(24.0, 38.0, s), 0.0, 0.0)
		
	elif tau < 0.38:
		# PHASE 2: STRIKE 1 - RIGHT UPWARD DIAGONAL SLASH (0.168s - 0.399s)
		# Explosive rising surge: Legs drive upward-forward, torso uncoils from +22° to -25°, right reverse blade rips up from below
		var u = (tau - 0.16) / 0.22
		var whip_curve: float = 0.0
		if u < 0.65:
			var strike_sub = u / 0.65
			whip_curve = 1.0 - pow(1.0 - strike_sub, 3.5)
		else:
			var follow_sub = (u - 0.65) / 0.35
			whip_curve = 1.0 + sin(follow_sub * PI * 0.5) * 0.08
			
		p["hips_pos"] = Vector3(0.0, lerp(ground_hips_y - 0.04, ground_hips_y - 0.015, whip_curve), lerp(-0.05, 0.14, whip_curve))
		p["hips_rot"] = Vector3(lerp(12.0, 8.0, whip_curve), lerp(14.0, -18.0, whip_curve), 0.0)
		p["torso_rot"] = Vector3(lerp(26.0, 12.0, whip_curve), lerp(22.0, -25.0, whip_curve), lerp(6.0, -12.0, whip_curve))
		p["head_rot"] = Vector3(lerp(-16.0, -10.0, whip_curve), lerp(-22.0, 22.0, whip_curve), 0.0)
		
		# Right reverse dagger rips up-diagonally across from low right past chin to high left
		p["right_arm_rot"] = Vector3(lerp(18.0, -105.0, whip_curve), lerp(18.0, -10.0, whip_curve), lerp(18.0, -15.0, whip_curve))
		p["right_forearm_rot"] = Vector3(lerp(-45.0, -35.0, whip_curve), 0.0, 0.0)
		p["right_dagger_rot"] = Vector3(-85.0, 15.0, -15.0)
		
		# Left arm draws down/back to left ribs in counter-balance, coiling for Strike 2
		p["left_arm_rot"] = Vector3(lerp(-35.0, 12.0, whip_curve), lerp(-10.0, -15.0, whip_curve), lerp(-15.0, -18.0, whip_curve))
		p["left_forearm_rot"] = Vector3(lerp(-75.0, -65.0, whip_curve), 0.0, 0.0)
		p["left_dagger_rot"] = Vector3(-85.0, -15.0, 15.0)
		
		# Deep forward combat lunge on front left foot
		p["left_thigh_rot"] = Vector3(lerp(-24.0, -30.0, whip_curve), 0.0, -8.0)
		p["left_shin_rot"] = Vector3(lerp(36.0, 42.0, whip_curve), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(18.0, 20.0, whip_curve), 0.0, 8.0)
		p["right_shin_rot"] = Vector3(lerp(38.0, 18.0, whip_curve), 0.0, 0.0)
		
	elif tau < 0.50:
		# PHASE 3: KINETIC TRANSITION & SCOOP DIP LEFT (0.399s - 0.525s)
		# Momentum of Strike 1 whips torso left, right arm lowers to high guard, left arm drops low and back behind hip
		var u = (tau - 0.38) / 0.12
		var s = smoothstep(0.0, 1.0, u)
		
		p["hips_pos"] = Vector3(0.0, lerp(ground_hips_y - 0.015, ground_hips_y - 0.04, s), lerp(0.14, 0.12, s))
		p["hips_rot"] = Vector3(lerp(8.0, 12.0, s), lerp(-18.0, -14.0, s), 0.0)
		p["torso_rot"] = Vector3(lerp(12.0, 26.0, s), lerp(-25.0, -22.0, s), lerp(-12.0, -6.0, s))
		p["head_rot"] = Vector3(lerp(-10.0, -16.0, s), lerp(22.0, 22.0, s), 0.0)
		
		# Right arm retracts into mid/high guard
		p["right_arm_rot"] = Vector3(lerp(-105.0, -35.0, s), lerp(-10.0, 10.0, s), lerp(-15.0, 15.0, s))
		p["right_forearm_rot"] = Vector3(lerp(-35.0, -75.0, s), 0.0, 0.0)
		p["right_dagger_rot"] = Vector3(-85.0, 15.0, -15.0)
		
		# Left arm drops low and back behind left hip, cocked for upward rip
		p["left_arm_rot"] = Vector3(lerp(12.0, 18.0, s), lerp(-15.0, -18.0, s), lerp(-18.0, -18.0, s))
		p["left_forearm_rot"] = Vector3(lerp(-65.0, -45.0, s), 0.0, 0.0)
		p["left_dagger_rot"] = Vector3(-85.0, -15.0, 15.0)
		
		p["left_thigh_rot"] = Vector3(lerp(-30.0, 18.0, s), 0.0, -8.0)
		p["left_shin_rot"] = Vector3(lerp(42.0, 38.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(20.0, -24.0, s), 0.0, 8.0)
		p["right_shin_rot"] = Vector3(lerp(18.0, 36.0, s), 0.0, 0.0)
		
	elif tau < 0.72:
		# PHASE 4: STRIKE 2 - LEFT UPWARD DIAGONAL SLASH (0.525s - 0.756s)
		# Explosive counter-whip from -22° across to +25°, left reverse blade rips up from below across right shoulder
		var u = (tau - 0.50) / 0.22
		var whip_curve: float = 0.0
		if u < 0.65:
			var strike_sub = u / 0.65
			whip_curve = 1.0 - pow(1.0 - strike_sub, 3.5)
		else:
			var follow_sub = (u - 0.65) / 0.35
			whip_curve = 1.0 + sin(follow_sub * PI * 0.5) * 0.08
			
		p["hips_pos"] = Vector3(0.0, lerp(ground_hips_y - 0.04, ground_hips_y - 0.015, whip_curve), lerp(0.12, 0.18, whip_curve))
		p["hips_rot"] = Vector3(lerp(12.0, 8.0, whip_curve), lerp(-14.0, 18.0, whip_curve), 0.0)
		p["torso_rot"] = Vector3(lerp(26.0, 12.0, whip_curve), lerp(-22.0, 25.0, whip_curve), lerp(-6.0, 12.0, whip_curve))
		p["head_rot"] = Vector3(lerp(-16.0, -10.0, whip_curve), lerp(22.0, -22.0, whip_curve), 0.0)
		
		# Left reverse dagger rips up-diagonally across from low left past chin to high right
		p["left_arm_rot"] = Vector3(lerp(18.0, -105.0, whip_curve), lerp(-18.0, 10.0, whip_curve), lerp(-18.0, 15.0, whip_curve))
		p["left_forearm_rot"] = Vector3(lerp(-45.0, -35.0, whip_curve), 0.0, 0.0)
		p["left_dagger_rot"] = Vector3(-85.0, -15.0, 15.0)
		
		# Right arm anchors at ribs in reverse guard
		p["right_arm_rot"] = Vector3(lerp(-35.0, 12.0, whip_curve), lerp(10.0, 15.0, whip_curve), lerp(15.0, 18.0, whip_curve))
		p["right_forearm_rot"] = Vector3(lerp(-75.0, -65.0, whip_curve), 0.0, 0.0)
		p["right_dagger_rot"] = Vector3(-85.0, 15.0, -15.0)
		
		# Powerful combat lunge planting onto right foot
		p["right_thigh_rot"] = Vector3(lerp(-24.0, -30.0, whip_curve), 0.0, 8.0)
		p["right_shin_rot"] = Vector3(lerp(36.0, 42.0, whip_curve), 0.0, 0.0)
		p["left_thigh_rot"] = Vector3(lerp(18.0, 20.0, whip_curve), 0.0, -8.0)
		p["left_shin_rot"] = Vector3(lerp(38.0, 18.0, whip_curve), 0.0, 0.0)
		
	else:
		# PHASE 5: FOLLOW-THROUGH FLOURISH & RESET TO REVERSE IDLE (0.756s - 1.05s)
		# Decelerates blades with crisp wrist flourish, springs back into low stalking reverse stance
		var u = (tau - 0.72) / 0.28
		var s = smoothstep(0.0, 1.0, u)
		
		p["hips_pos"] = Vector3(0.0, lerp(ground_hips_y - 0.015, ground_hips_y, s), lerp(0.18, 0.0, s))
		p["hips_rot"] = Vector3(lerp(8.0, 12.0, s), lerp(18.0, 0.0, s), 0.0)
		p["torso_rot"] = Vector3(lerp(12.0, base_torso.x, s), lerp(25.0, base_torso.y, s), lerp(12.0, base_torso.z, s))
		p["head_rot"] = Vector3(lerp(-10.0, base_head.x, s), lerp(-22.0, base_head.y, s), 0.0)
		
		p["left_arm_rot"] = _lerp_angles(Vector3(-105.0, 10.0, 15.0), base_l_arm, s)
		p["left_forearm_rot"] = _lerp_angles(Vector3(-35.0, 0.0, 0.0), base_l_fore, s)
		p["left_dagger_rot"] = _lerp_angles(Vector3(-85.0, -15.0, 15.0), base_dag_l, s)
		
		p["right_arm_rot"] = _lerp_angles(Vector3(12.0, 15.0, 18.0), base_r_arm, s)
		p["right_forearm_rot"] = _lerp_angles(Vector3(-65.0, 0.0, 0.0), base_r_fore, s)
		p["right_dagger_rot"] = _lerp_angles(Vector3(-85.0, 15.0, -15.0), base_dag_r, s)
		
		p["right_thigh_rot"] = Vector3(lerp(-30.0, 12.0, s), 0.0, 8.0)
		p["right_shin_rot"] = Vector3(lerp(42.0, 24.0, s), 0.0, 0.0)
		p["left_thigh_rot"] = Vector3(lerp(20.0, -18.0, s), 0.0, -8.0)
		p["left_shin_rot"] = Vector3(lerp(18.0, 28.0, s), 0.0, 0.0)
		
	return p

# --- 5. BACKSTAB (Lethal Ambush: Dedicated Smooth Non-Clipping Grip Flip to Dao Xuôi, Explosive Forward Lunge & Deep Impale, Brutal Twist Tear & Non-Clipping Recovery Flip) ---
func _compute_backstab(t_b: float) -> Dictionary:
	var p: Dictionary = {}
	var tau = clampf(t_b / BACKSTAB_DURATION, 0.0, 1.0)
	var st_key = "idle"
	var cfg = stance_configs.get(st_key, default_stance_configs.get(st_key, {}))
	var base_dag_r: Vector3 = cfg.get("right_dagger_rot", Vector3(-85.0, 15.0, -15.0))
	var base_dag_l: Vector3 = cfg.get("left_dagger_rot", Vector3(-85.0, -15.0, 15.0))
	var base_r_arm: Vector3 = cfg.get("right_arm_rot", Vector3(-15.0, 15.0, 18.0))
	var base_r_fore: Vector3 = cfg.get("right_forearm_rot", Vector3(-62.0, 0.0, 0.0))
	var base_l_arm: Vector3 = cfg.get("left_arm_rot", Vector3(-15.0, -15.0, -18.0))
	var base_l_fore: Vector3 = cfg.get("left_forearm_rot", Vector3(-62.0, 0.0, 0.0))
	var base_torso: Vector3 = cfg.get("torso_rot", Vector3(22.0, 0.0, 0.0))
	var base_head: Vector3 = cfg.get("head_rot", Vector3(-16.0, 0.0, 0.0))
	
	# Forward Grip (Dao Xuôi) targets for lethal backstab
	var fwd_dag_r = Vector3(88.0, -10.0, 12.0)
	var fwd_dag_l = Vector3(88.0, 10.0, -12.0)
	
	# Lateral outward roll waypoints: rolls the blade through outer space, completely avoiding forearm collision
	var mid_dag_r = Vector3(10.0, 15.0, -95.0)
	var mid_dag_l = Vector3(10.0, -15.0, 95.0)
	
	if tau < 0.28:
		# PHASE 1: DEDICATED TRANSITION - SMOOTH OUTWARD NON-CLIPPING DAGGER FLIP & SHADOW COIL (0.00s - 0.448s)
		# Low stalking windup: weight shifts to rear right foot, forearms lift slightly to open clearance,
		# daggers roll fluidly through outer lateral arc into forward grip (Dao Xuôi) with zero arm clipping.
		var u = tau / 0.28
		var s = smoothstep(0.0, 1.0, u)
		
		# Hips sink and coil back
		p["hips_pos"] = Vector3(0.0, ground_hips_y - 0.06 * s, -0.05 * s)
		p["hips_rot"] = Vector3(lerp(12.0, 14.0, s), lerp(0.0, 18.0, s), 0.0)
		
		# Torso coils back and twists right (+28° yaw, -8° roll, 14° pitch)
		p["torso_rot"] = Vector3(lerp(base_torso.x, 14.0, s), lerp(0.0, 28.0, s), lerp(0.0, -8.0, s))
		p["head_rot"] = Vector3(lerp(base_head.x, -14.0, s), lerp(0.0, -22.0, s), 0.0) # Head locked on target
		
		# Flip timing inside Stage 1: dedicated fluid roll starting at u=0.10 through u=0.90
		var flip_u = clampf((u - 0.10) / 0.80, 0.0, 1.0)
		p["right_dagger_rot"] = _compute_dagger_flip(base_dag_r, mid_dag_r, fwd_dag_r, flip_u)
		p["left_dagger_rot"] = _compute_dagger_flip(base_dag_l, mid_dag_l, fwd_dag_l, flip_u)
		
		# Clearance lift: slightly uncurls elbow and expands arms during the flip to give generous margin
		var clear_lift = sin(flip_u * PI) * 16.0
		
		# Right arm cocks back behind ribs, elbow drawn back high for spear thrust
		p["right_arm_rot"] = _lerp_angles(base_r_arm, Vector3(34.0, 26.0, 22.0), s) + Vector3(0.0, 0.0, clear_lift * 0.4)
		p["right_forearm_rot"] = _lerp_angles(base_r_fore, Vector3(-88.0, 0.0, 0.0), s) + Vector3(clear_lift * 0.5, 0.0, 0.0)
		
		# Left arm reaches forward to grapple target
		p["left_arm_rot"] = _lerp_angles(base_l_arm, Vector3(-32.0, -18.0, -24.0), s) - Vector3(0.0, 0.0, clear_lift * 0.4)
		p["left_forearm_rot"] = _lerp_angles(base_l_fore, Vector3(-38.0, 0.0, 0.0), s) + Vector3(clear_lift * 0.5, 0.0, 0.0)
		
		# Stance loading onto rear foot
		p["left_thigh_rot"] = Vector3(lerp(-18.0, -24.0, s), 0.0, -10.0)
		p["left_shin_rot"] = Vector3(lerp(28.0, 38.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(12.0, 24.0, s), 0.0, 10.0)
		p["right_shin_rot"] = Vector3(lerp(24.0, 16.0, s), 0.0, 0.0)
		
	elif tau < 0.52:
		# PHASE 2: EXPLOSIVE FORWARD LUNGE & DEEP FORWARD IMPALE (0.448s - 0.832s)
		# Drives off back foot, surges forward (+0.48m!), torso uncoils, arm reaches FULL EXTENSION with forward blade
		var u = (tau - 0.28) / 0.24
		var thrust_curve: float = 0.0
		if u < 0.65:
			var strike_sub = u / 0.65
			thrust_curve = 1.0 - pow(1.0 - strike_sub, 3.5)
		else:
			# Deep penetration resistance hold & micro impact shudder
			var sub = (u - 0.65) / 0.35
			thrust_curve = 1.0 + sin(sub * PI) * 0.03
			
		p["hips_pos"] = Vector3(0.0, lerp(ground_hips_y - 0.06, ground_hips_y - 0.05, thrust_curve), lerp(-0.05, 0.48, thrust_curve))
		p["hips_rot"] = Vector3(lerp(14.0, 10.0, thrust_curve), lerp(18.0, -14.0, thrust_curve), 0.0)
		
		# Torso drives upper body weight into the thrust: leans forward 36°, rotates from +28° to -16°
		p["torso_rot"] = Vector3(lerp(14.0, 36.0, thrust_curve), lerp(28.0, -16.0, thrust_curve), lerp(-8.0, 8.0, thrust_curve))
		p["head_rot"] = Vector3(lerp(-14.0, -24.0, thrust_curve), lerp(-22.0, 14.0, thrust_curve), 0.0)
		
		# Both daggers locked firmly in DAO XUÔI (Forward Grip)
		p["right_dagger_rot"] = fwd_dag_r
		p["left_dagger_rot"] = fwd_dag_l
		
		# Right arm punches straight through with maximum wide extension!
		p["right_arm_rot"] = Vector3(lerp(34.0, -68.0, thrust_curve), lerp(26.0, -10.0, thrust_curve), lerp(22.0, 8.0, thrust_curve))
		p["right_forearm_rot"] = Vector3(lerp(-88.0, -14.0, thrust_curve), 0.0, 0.0) # Almost completely straightened arm!
		
		# Left arm grasps target and drives secondary forward dagger into flank
		p["left_arm_rot"] = Vector3(lerp(-32.0, -56.0, thrust_curve), lerp(-18.0, 14.0, thrust_curve), lerp(-24.0, -14.0, thrust_curve))
		p["left_forearm_rot"] = Vector3(lerp(-38.0, -42.0, thrust_curve), 0.0, 0.0)
		
		# Deep combat lunge planting onto lead left foot
		p["left_thigh_rot"] = Vector3(lerp(-24.0, -44.0, thrust_curve), 0.0, -10.0)
		p["left_shin_rot"] = Vector3(lerp(38.0, 60.0, thrust_curve), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(24.0, 32.0, thrust_curve), 0.0, 10.0)
		p["right_shin_rot"] = Vector3(lerp(16.0, 10.0, thrust_curve), 0.0, 0.0)
		
	elif tau < 0.74:
		# PHASE 3: BRUTAL INTERNAL TWIST & LATERAL RIPPING TEAR (0.832s - 1.184s)
		# Drives full body weight deeper (torso 42°), twists forward blades 90°, violently wrenches arms outward
		var u = (tau - 0.52) / 0.22
		var rip_curve = 1.0 - pow(1.0 - u, 2.5)
		
		p["hips_pos"] = Vector3(0.0, lerp(ground_hips_y - 0.05, ground_hips_y - 0.07, rip_curve), lerp(0.48, 0.50, rip_curve))
		p["hips_rot"] = Vector3(10.0, -14.0, 0.0)
		p["torso_rot"] = Vector3(lerp(36.0, 42.0, rip_curve), lerp(-16.0, -18.0, rip_curve), 8.0)
		p["head_rot"] = Vector3(-24.0, 14.0, 0.0)
		
		# Wrists twist blades to expand wound
		p["right_dagger_rot"] = Vector3(82.0, lerp(-10.0, 25.0, rip_curve), lerp(12.0, 45.0, rip_curve))
		p["left_dagger_rot"] = Vector3(82.0, lerp(10.0, -25.0, rip_curve), lerp(-12.0, -45.0, rip_curve))
		
		# Broad, forceful lateral extraction rip
		p["right_arm_rot"] = Vector3(lerp(-68.0, -42.0, rip_curve), lerp(-10.0, 32.0, rip_curve), lerp(8.0, 40.0, rip_curve))
		p["right_forearm_rot"] = Vector3(lerp(-14.0, -58.0, rip_curve), 0.0, 0.0)
		
		p["left_arm_rot"] = Vector3(lerp(-56.0, -42.0, rip_curve), lerp(14.0, -32.0, rip_curve), lerp(-14.0, -40.0, rip_curve))
		p["left_forearm_rot"] = Vector3(lerp(-42.0, -58.0, rip_curve), 0.0, 0.0)
		
		p["left_thigh_rot"] = Vector3(-44.0, 0.0, -10.0)
		p["left_shin_rot"] = Vector3(60.0, 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(32.0, 0.0, 10.0)
		p["right_shin_rot"] = Vector3(10.0, 0.0, 0.0)
		
	else:
		# PHASE 4: RECOIL EXTRACTION, BLOOD FLICK & FLIP BACK TO REVERSE IDLE (1.184s - 1.60s)
		# Springs back from front foot to neutral, stylish wrist snap flicks blood, daggers spin back to DAO NGƯỢC
		# using outward non-clipping quaternion roll trajectory.
		var u = (tau - 0.74) / 0.26
		var s = smoothstep(0.0, 1.0, u)
		
		p["hips_pos"] = Vector3(0.0, lerp(ground_hips_y - 0.07, ground_hips_y, s), lerp(0.50, 0.0, s))
		p["hips_rot"] = Vector3(lerp(10.0, 12.0, s), lerp(-14.0, 0.0, s), 0.0)
		p["torso_rot"] = Vector3(lerp(42.0, base_torso.x, s), lerp(-18.0, base_torso.y, s), lerp(8.0, base_torso.z, s))
		p["head_rot"] = Vector3(lerp(-24.0, base_head.x, s), lerp(14.0, base_head.y, s), 0.0)
		
		# Grip Flip Back: Daggers roll outward smoothly from forward grip back to reverse grip
		var unflip_u = clampf((u - 0.20) / 0.65, 0.0, 1.0)
		var tear_dag_r = Vector3(82.0, 25.0, 45.0)
		var tear_dag_l = Vector3(82.0, -25.0, -45.0)
		p["right_dagger_rot"] = _compute_dagger_flip(tear_dag_r, mid_dag_r, base_dag_r, unflip_u)
		p["left_dagger_rot"] = _compute_dagger_flip(tear_dag_l, mid_dag_l, base_dag_l, unflip_u)
		
		var unflip_lift = sin(unflip_u * PI) * 12.0
		p["right_arm_rot"] = _lerp_angles(Vector3(-42.0, 32.0, 40.0), base_r_arm, s) + Vector3(0.0, 0.0, unflip_lift * 0.3)
		p["right_forearm_rot"] = _lerp_angles(Vector3(-58.0, 0.0, 0.0), base_r_fore, s) + Vector3(unflip_lift * 0.4, 0.0, 0.0)
		
		p["left_arm_rot"] = _lerp_angles(Vector3(-42.0, -32.0, -40.0), base_l_arm, s) - Vector3(0.0, 0.0, unflip_lift * 0.3)
		p["left_forearm_rot"] = _lerp_angles(Vector3(-58.0, 0.0, 0.0), base_l_fore, s) + Vector3(unflip_lift * 0.4, 0.0, 0.0)
		
		p["left_thigh_rot"] = Vector3(lerp(-44.0, -18.0, s), 0.0, -8.0)
		p["left_shin_rot"] = Vector3(lerp(60.0, 28.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(32.0, 12.0, s), 0.0, 8.0)
		p["right_shin_rot"] = Vector3(lerp(10.0, 24.0, s), 0.0, 0.0)
		
	return p


# --- 6. PARRY REACTION (Lethal Clashing Deflection, Violent Stagger Recoil & Combat Recovery) ---
func _compute_parry(t_p: float) -> Dictionary:
	var p: Dictionary = {}
	var tau = clampf(t_p / PARRY_DURATION, 0.0, 1.0)
	
	# Resolve baseline grip: Respect current combat stance (reverse grip vs forward grip)
	var is_fwd = (current_stance == "forward")
	var base_dag_r = Vector3(85.0, -15.0, 15.0) if is_fwd else Vector3(-85.0, 16.0, -14.0)
	var base_dag_l = Vector3(85.0, 15.0, -15.0) if is_fwd else Vector3(-85.0, -16.0, 14.0)
	
	var idle_cfg = stance_configs.get("idle", default_stance_configs.get("idle", {}))
	var base_r_arm: Vector3 = idle_cfg.get("right_arm_rot", Vector3(-15.0, 15.0, 18.0))
	var base_r_fore: Vector3 = idle_cfg.get("right_forearm_rot", Vector3(-62.0, 0.0, 0.0))
	var base_l_arm: Vector3 = idle_cfg.get("left_arm_rot", Vector3(-15.0, -15.0, -18.0))
	var base_l_fore: Vector3 = idle_cfg.get("left_forearm_rot", Vector3(-62.0, 0.0, 0.0))
	var base_torso: Vector3 = idle_cfg.get("torso_rot", Vector3(22.0, 0.0, 0.0))
	var base_head: Vector3 = idle_cfg.get("head_rot", Vector3(-16.0, 0.0, 0.0))
	
	if tau < 0.22:
		# PHASE 1: VIOLENT CLASH & IMPACT DEFLECTION (0.0s - 0.187s)
		# Heavy recoil drives arms outward, torso recoils backward, rear leg absorbs momentum
		var prog = tau / 0.22
		var snap = 1.0 - pow(1.0 - prog, 3.2)
		
		# Hips drive backward and sink slightly onto rear foot
		p["hips_pos"] = Vector3(
			0.0,
			lerp(ground_hips_y, ground_hips_y - 0.032, snap),
			lerp(0.0, -0.14, snap)
		)
		p["hips_rot"] = Vector3(lerp(12.0, -8.0, snap), lerp(0.0, 10.0, snap), 0.0)
		
		# Torso snaps back and twists away from clash point
		p["torso_rot"] = Vector3(lerp(base_torso.x, -22.0, snap), lerp(0.0, -14.0, snap), lerp(0.0, -6.0, snap))
		# Head snaps back in surprise, chin raised
		p["head_rot"] = Vector3(lerp(base_head.x, 16.0, snap), lerp(0.0, 18.0, snap), 0.0)
		
		# Daggers: Blades deflect backward and outward with shock compliance
		# Forearms flex to -68° so reverse daggers remain entirely outside chest clearance
		p["right_arm_rot"] = _lerp_angles(base_r_arm, Vector3(-8.0, 22.0, 42.0), snap)
		p["right_forearm_rot"] = _lerp_angles(base_r_fore, Vector3(-68.0, 0.0, 0.0), snap)
		p["right_dagger_rot"] = base_dag_r + Vector3(snap * 8.0, snap * 4.0, 0.0)
		
		p["left_arm_rot"] = _lerp_angles(base_l_arm, Vector3(-12.0, -22.0, -42.0), snap)
		p["left_forearm_rot"] = _lerp_angles(base_l_fore, Vector3(-68.0, 0.0, 0.0), snap)
		p["left_dagger_rot"] = base_dag_l + Vector3(snap * 8.0, -snap * 4.0, 0.0)
		
		# Legs: Left leg slides back, right leg catches weight
		p["left_thigh_rot"] = Vector3(lerp(-18.0, 16.0, snap), 0.0, -10.0)
		p["left_shin_rot"] = Vector3(lerp(28.0, 16.0, snap), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(12.0, -22.0, snap), 0.0, 12.0)
		p["right_shin_rot"] = Vector3(lerp(24.0, 40.0, snap), 0.0, 0.0)
		
	elif tau < 0.58:
		# PHASE 2: OFF-BALANCE STAGGER & DEFENSIVE FLANK GUARD (0.187s - 0.493s)
		# Rogue recoils forward, tucks daggers into wide defensive flanks, glares back at opponent
		var prog = (tau - 0.22) / 0.36
		var s = smoothstep(0.0, 1.0, prog)
		
		# Hips hold rearward position, stabilizing
		p["hips_pos"] = Vector3(
			0.0,
			lerp(ground_hips_y - 0.032, ground_hips_y - 0.015, s),
			lerp(-0.14, -0.16, s)
		)
		p["hips_rot"] = Vector3(lerp(-8.0, 10.0, s), lerp(10.0, -6.0, s), 0.0)
		
		# Torso rebounds forward aggressively into a low combat hunch (+18° to +24°)
		p["torso_rot"] = Vector3(lerp(-22.0, 24.0, s), lerp(-14.0, 6.0, s), lerp(-6.0, 4.0, s))
		# Head locks on target, eyes narrowed, chin tucked (-14° pitch)
		p["head_rot"] = Vector3(lerp(16.0, -14.0, s), lerp(18.0, -6.0, s), 0.0)
		
		# Arms draw into tight flanking guard (elbows flared at +/- 26° so blades flank ribs with 12cm clearance)
		p["right_arm_rot"] = _lerp_angles(Vector3(-8.0, 22.0, 42.0), Vector3(-20.0, 16.0, 26.0), s)
		p["right_forearm_rot"] = _lerp_angles(Vector3(-68.0, 0.0, 0.0), Vector3(-60.0, 0.0, 0.0), s)
		p["right_dagger_rot"] = base_dag_r
		
		p["left_arm_rot"] = _lerp_angles(Vector3(-12.0, -22.0, -42.0), Vector3(-20.0, -16.0, -26.0), s)
		p["left_forearm_rot"] = _lerp_angles(Vector3(-68.0, 0.0, 0.0), Vector3(-60.0, 0.0, 0.0), s)
		p["left_dagger_rot"] = base_dag_l
		
		# Stance bracing and weight transfer
		p["left_thigh_rot"] = Vector3(lerp(16.0, -12.0, s), 0.0, -8.0)
		p["left_shin_rot"] = Vector3(lerp(16.0, 24.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(-22.0, 6.0, s), 0.0, 8.0)
		p["right_shin_rot"] = Vector3(lerp(40.0, 28.0, s), 0.0, 0.0)
		
	else:
		# PHASE 3: REGAIN COMBAT FOOTING & RESET TO STANCE (0.493s - 0.85s)
		# Springs smoothly back to neutral stalking crouch
		var prog = (tau - 0.58) / 0.42
		var s = smoothstep(0.0, 1.0, prog)
		
		p["hips_pos"] = Vector3(
			0.0,
			lerp(ground_hips_y - 0.015, ground_hips_y, s),
			lerp(-0.16, 0.0, s)
		)
		p["hips_rot"] = Vector3(lerp(10.0, 12.0, s), lerp(-6.0, 0.0, s), 0.0)
		p["torso_rot"] = Vector3(lerp(24.0, base_torso.x, s), lerp(6.0, base_torso.y, s), lerp(4.0, base_torso.z, s))
		p["head_rot"] = Vector3(lerp(-14.0, base_head.x, s), lerp(-6.0, base_head.y, s), 0.0)
		
		p["right_arm_rot"] = _lerp_angles(Vector3(-20.0, 16.0, 26.0), base_r_arm, s)
		p["right_forearm_rot"] = _lerp_angles(Vector3(-60.0, 0.0, 0.0), base_r_fore, s)
		p["right_dagger_rot"] = base_dag_r
		
		p["left_arm_rot"] = _lerp_angles(Vector3(-20.0, -16.0, -26.0), base_l_arm, s)
		p["left_forearm_rot"] = _lerp_angles(Vector3(-60.0, 0.0, 0.0), base_l_fore, s)
		p["left_dagger_rot"] = base_dag_l
		
		p["left_thigh_rot"] = Vector3(lerp(-12.0, -18.0, s), 0.0, -8.0)
		p["left_shin_rot"] = Vector3(lerp(24.0, 28.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(6.0, 12.0, s), 0.0, 8.0)
		p["right_shin_rot"] = Vector3(lerp(28.0, 24.0, s), 0.0, 0.0)
		
	return p

# --- 7. HURT (Heavy Visceral Impact Flinch, Torso Compression & Spring Recovery) ---
func _compute_hurt(t_h: float) -> Dictionary:
	var p: Dictionary = {}
	var tau = clampf(t_h / HURT_DURATION, 0.0, 1.0)
	
	var is_fwd = (current_stance == "forward")
	var base_dag_r = Vector3(85.0, -15.0, 15.0) if is_fwd else Vector3(-85.0, 16.0, -14.0)
	var base_dag_l = Vector3(85.0, 15.0, -15.0) if is_fwd else Vector3(-85.0, -16.0, 14.0)
	
	var idle_cfg = stance_configs.get("idle", default_stance_configs.get("idle", {}))
	var base_r_arm: Vector3 = idle_cfg.get("right_arm_rot", Vector3(-15.0, 15.0, 18.0))
	var base_r_fore: Vector3 = idle_cfg.get("right_forearm_rot", Vector3(-62.0, 0.0, 0.0))
	var base_l_arm: Vector3 = idle_cfg.get("left_arm_rot", Vector3(-15.0, -15.0, -18.0))
	var base_l_fore: Vector3 = idle_cfg.get("left_forearm_rot", Vector3(-62.0, 0.0, 0.0))
	var base_torso: Vector3 = idle_cfg.get("torso_rot", Vector3(22.0, 0.0, 0.0))
	var base_head: Vector3 = idle_cfg.get("head_rot", Vector3(-16.0, 0.0, 0.0))
	
	if tau < 0.28:
		# PHASE 1: SUDDEN HIT IMPACT (0.0s - 0.145s)
		# Body caves backward, head twists sideways in pain, shoulders splay wide to preserve dagger clearance
		var prog = tau / 0.28
		var snap = 1.0 - pow(1.0 - prog, 3.5)
		var jitter = sin(prog * PI * 8.0) * (1.0 - prog) * 2.0
		
		p["hips_pos"] = Vector3(
			0.0,
			lerp(ground_hips_y, ground_hips_y - 0.038, snap),
			lerp(0.0, -0.12, snap)
		)
		p["hips_rot"] = Vector3(lerp(12.0, -14.0, snap) + jitter, lerp(0.0, 8.0, snap), 0.0)
		
		# Torso doubles back and wrenches to the side
		p["torso_rot"] = Vector3(lerp(base_torso.x, -24.0, snap) + jitter, lerp(0.0, -16.0, snap), lerp(0.0, 6.0, snap))
		# Head snaps up and sideways
		p["head_rot"] = Vector3(lerp(base_head.x, 20.0, snap), lerp(0.0, -22.0, snap), lerp(0.0, -8.0, snap))
		
		# Arms flare OUTWARD (+38° / -40° Z) so reverse blades flank outside ribs with zero body penetration
		p["right_arm_rot"] = _lerp_angles(base_r_arm, Vector3(-24.0, 14.0, 38.0), snap)
		p["right_forearm_rot"] = _lerp_angles(base_r_fore, Vector3(-66.0, 0.0, 0.0), snap)
		p["right_dagger_rot"] = base_dag_r
		
		p["left_arm_rot"] = _lerp_angles(base_l_arm, Vector3(-30.0, -16.0, -40.0), snap)
		p["left_forearm_rot"] = _lerp_angles(base_l_fore, Vector3(-70.0, 0.0, 0.0), snap)
		p["left_dagger_rot"] = base_dag_l
		
		# Legs step back to brace against fall
		p["left_thigh_rot"] = Vector3(lerp(-18.0, -22.0, snap), 0.0, -10.0)
		p["left_shin_rot"] = Vector3(lerp(28.0, 36.0, snap), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(12.0, 18.0, snap), 0.0, 10.0)
		p["right_shin_rot"] = Vector3(lerp(24.0, 20.0, snap), 0.0, 0.0)
		
	elif tau < 0.65:
		# PHASE 2: PAIN REBOUND & RESISTANCE (0.145s - 0.338s)
		# Spine rebounds forward from extreme arch, stabilizing balance
		var prog = (tau - 0.28) / 0.37
		var s = smoothstep(0.0, 1.0, prog)
		
		p["hips_pos"] = Vector3(
			0.0,
			lerp(ground_hips_y - 0.038, ground_hips_y - 0.015, s),
			lerp(-0.12, -0.06, s)
		)
		p["hips_rot"] = Vector3(lerp(-14.0, 8.0, s), lerp(8.0, 0.0, s), 0.0)
		p["torso_rot"] = Vector3(lerp(-24.0, 14.0, s), lerp(-16.0, -4.0, s), lerp(6.0, 0.0, s))
		p["head_rot"] = Vector3(lerp(20.0, -8.0, s), lerp(-22.0, -4.0, s), 0.0)
		
		p["right_arm_rot"] = _lerp_angles(Vector3(-24.0, 14.0, 38.0), Vector3(-18.0, 15.0, 26.0), s)
		p["right_forearm_rot"] = _lerp_angles(Vector3(-66.0, 0.0, 0.0), Vector3(-62.0, 0.0, 0.0), s)
		p["right_dagger_rot"] = base_dag_r
		
		p["left_arm_rot"] = _lerp_angles(Vector3(-30.0, -16.0, -40.0), Vector3(-18.0, -15.0, -26.0), s)
		p["left_forearm_rot"] = _lerp_angles(Vector3(-70.0, 0.0, 0.0), Vector3(-62.0, 0.0, 0.0), s)
		p["left_dagger_rot"] = base_dag_l
		
		p["left_thigh_rot"] = Vector3(lerp(-22.0, -16.0, s), 0.0, -8.0)
		p["left_shin_rot"] = Vector3(lerp(36.0, 26.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(18.0, 10.0, s), 0.0, 8.0)
		p["right_shin_rot"] = Vector3(lerp(20.0, 22.0, s), 0.0, 0.0)
		
	else:
		# PHASE 3: FAST RE-ENGAGEMENT TO COMBAT CROUCH (0.338s - 0.52s)
		var prog = (tau - 0.65) / 0.35
		var s = smoothstep(0.0, 1.0, prog)
		
		p["hips_pos"] = Vector3(
			0.0,
			lerp(ground_hips_y - 0.015, ground_hips_y, s),
			lerp(-0.06, 0.0, s)
		)
		p["hips_rot"] = Vector3(lerp(8.0, 12.0, s), 0.0, 0.0)
		p["torso_rot"] = Vector3(lerp(14.0, base_torso.x, s), lerp(-4.0, base_torso.y, s), 0.0)
		p["head_rot"] = Vector3(lerp(-8.0, base_head.x, s), lerp(-4.0, base_head.y, s), 0.0)
		
		p["right_arm_rot"] = _lerp_angles(Vector3(-18.0, 15.0, 26.0), base_r_arm, s)
		p["right_forearm_rot"] = _lerp_angles(Vector3(-62.0, 0.0, 0.0), base_r_fore, s)
		p["right_dagger_rot"] = base_dag_r
		
		p["left_arm_rot"] = _lerp_angles(Vector3(-18.0, -15.0, -26.0), base_l_arm, s)
		p["left_forearm_rot"] = _lerp_angles(Vector3(-62.0, 0.0, 0.0), base_l_fore, s)
		p["left_dagger_rot"] = base_dag_l
		
		p["left_thigh_rot"] = Vector3(lerp(-16.0, -18.0, s), 0.0, -8.0)
		p["left_shin_rot"] = Vector3(lerp(26.0, 28.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(10.0, 12.0, s), 0.0, 8.0)
		p["right_shin_rot"] = Vector3(lerp(22.0, 24.0, s), 0.0, 0.0)
		
	return p

# --- 8. STUNNED (Dazed Concussed Lissajous Sway, Grounded Knee Buckling, Non-Clipping Loose Dagger Grip) ---
func _compute_stunned(time_val: float) -> Dictionary:
	var p: Dictionary = {}
	var t = time_val * 2.6
	
	var is_fwd = (current_stance == "forward")
	# In reverse grip: Blade points along forearm. With wrist slightly rolled outward, tips point into empty air
	var base_dag_r = Vector3(85.0, -15.0, 15.0) if is_fwd else Vector3(-85.0, 22.0, -18.0)
	var base_dag_l = Vector3(85.0, 15.0, -15.0) if is_fwd else Vector3(-85.0, -22.0, 18.0)
	
	# Hips: Organic 3D elliptical sway with calibrated height so soles remain 100% grounded
	p["hips_pos"] = Vector3(
		sin(t) * 0.028,
		ground_hips_y - 0.034 + cos(t * 2.0) * 0.008,
		cos(t) * 0.022
	)
	p["hips_rot"] = Vector3(cos(t) * 4.0, sin(t) * 8.0, sin(t) * 5.0)
	
	# Torso: Dazed drunken lean, wobbling with inertia
	p["torso_rot"] = Vector3(
		14.0 + sin(t) * 9.0,
		-cos(t) * 12.0,
		-sin(t) * 6.0
	)
	
	# Head: Groggily rolling and bobbing with asymmetric harmonics
	p["head_rot"] = Vector3(
		-6.0 + cos(t * 1.3) * 14.0,
		sin(t) * 16.0,
		-cos(t * 0.7) * 15.0
	)
	
	# Legs: Knees buckle clumsily inward and outward in drunken stagger, feet flat on floor
	p["left_thigh_rot"] = Vector3(-12.0 + sin(t) * 6.0, 0.0, -6.0 + cos(t) * 3.0)
	p["left_shin_rot"] = Vector3(18.0 + cos(t) * 7.0, 0.0, 0.0)
	p["right_thigh_rot"] = Vector3(8.0 - sin(t) * 6.0, 0.0, 6.0 - cos(t) * 3.0)
	p["right_shin_rot"] = Vector3(14.0 - cos(t) * 7.0, 0.0, 0.0)
	
	# Arms & Daggers: Loose, limp, concussed hang
	# Forearms hold a natural relaxed bend (-36°), upper arms flare outward (+/- 26° Z)
	# This keeps the hands and blades 15cm outside the hips/thighs at all times! ZERO CLIPPING!
	var arm_sway = sin(t) * 5.0
	p["right_arm_rot"] = Vector3(-4.0 + arm_sway, 12.0, 26.0 + cos(t) * 4.0)
	p["right_forearm_rot"] = Vector3(-36.0 + arm_sway * 0.5, 0.0, 0.0)
	p["right_dagger_rot"] = base_dag_r + Vector3(cos(t) * 4.0, 0.0, 0.0)
	
	p["left_arm_rot"] = Vector3(-4.0 - arm_sway, -12.0, -26.0 - cos(t) * 4.0)
	p["left_forearm_rot"] = Vector3(-36.0 - arm_sway * 0.5, 0.0, 0.0)
	p["left_dagger_rot"] = base_dag_l + Vector3(cos(t) * 4.0, 0.0, 0.0)
	
	return p

func _blend_poses(a: Dictionary, b: Dictionary, f: float) -> Dictionary:
	var out: Dictionary = {}
	for k in b:
		if a.has(k):
			if b[k] is Vector3:
				out[k] = a[k].lerp(b[k], f)
			elif b[k] is float:
				out[k] = lerpf(a[k], b[k], f)
		else:
			out[k] = b[k]
	return out

func _apply_pose(p: Dictionary) -> void:
	if not is_inside_tree() or not hips:
		return
	if p.has("hips_pos"): hips.position = p["hips_pos"]
	if p.has("hips_rot"): hips.rotation_degrees = p["hips_rot"]
	if p.has("torso_rot"): torso.rotation_degrees = p["torso_rot"]
	if p.has("head_rot"): head.rotation_degrees = p["head_rot"]
	
	if p.has("left_arm_rot"): left_arm.rotation_degrees = p["left_arm_rot"]
	if p.has("left_forearm_rot"): left_forearm.rotation_degrees = p["left_forearm_rot"]
	if p.has("left_dagger_rot"): left_dagger.rotation_degrees = p["left_dagger_rot"]
	
	if p.has("right_arm_rot"): right_arm.rotation_degrees = p["right_arm_rot"]
	if p.has("right_forearm_rot"): right_forearm.rotation_degrees = p["right_forearm_rot"]
	if p.has("right_dagger_rot"): right_dagger.rotation_degrees = p["right_dagger_rot"]
	
	if p.has("left_thigh_rot"): left_thigh.rotation_degrees = p["left_thigh_rot"]
	if p.has("left_shin_rot"): left_shin.rotation_degrees = p["left_shin_rot"]
	if p.has("right_thigh_rot"): right_thigh.rotation_degrees = p["right_thigh_rot"]
	if p.has("right_shin_rot"): right_shin.rotation_degrees = p["right_shin_rot"]
