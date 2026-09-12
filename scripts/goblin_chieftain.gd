class_name GoblinChieftain
extends Node3D

@onready var hips: Node3D = $VisualRoot/Hips
@onready var torso: Node3D = $VisualRoot/Hips/Torso
@onready var head: Node3D = $VisualRoot/Hips/Torso/Head
@onready var left_arm: Node3D = $VisualRoot/Hips/Torso/LeftArm
@onready var left_forearm: Node3D = $VisualRoot/Hips/Torso/LeftArm/LeftForearm
@onready var right_arm: Node3D = $VisualRoot/Hips/Torso/RightArm
@onready var right_forearm: Node3D = $VisualRoot/Hips/Torso/RightArm/RightForearm
@onready var warhammer: Node3D = $VisualRoot/Hips/Torso/RightArm/RightForearm/Warhammer
@onready var left_thigh: Node3D = $VisualRoot/Hips/LeftThigh
@onready var left_shin: Node3D = $VisualRoot/Hips/LeftThigh/LeftShin
@onready var right_thigh: Node3D = $VisualRoot/Hips/RightThigh
@onready var right_shin: Node3D = $VisualRoot/Hips/RightThigh/RightShin

@onready var torso_mesh: MeshInstance3D = $VisualRoot/Hips/Torso/TorsoMesh
@onready var head_mesh: MeshInstance3D = $VisualRoot/Hips/Torso/Head/HeadMesh
@onready var left_arm_mesh: MeshInstance3D = $VisualRoot/Hips/Torso/LeftArm/LeftArmMesh
@onready var left_forearm_mesh: MeshInstance3D = $VisualRoot/Hips/Torso/LeftArm/LeftForearm/LeftForearmMesh
@onready var right_arm_mesh: MeshInstance3D = $VisualRoot/Hips/Torso/RightArm/RightArmMesh
@onready var right_forearm_mesh: MeshInstance3D = $VisualRoot/Hips/Torso/RightArm/RightForearm/RightForearmMesh
@onready var warhammer_mesh: MeshInstance3D = $VisualRoot/Hips/Torso/RightArm/RightForearm/Warhammer/WarhammerMesh
@onready var left_thigh_mesh: MeshInstance3D = $VisualRoot/Hips/LeftThigh/LeftThighMesh
@onready var left_shin_mesh: MeshInstance3D = $VisualRoot/Hips/LeftThigh/LeftShin/LeftShinMesh
@onready var right_thigh_mesh: MeshInstance3D = $VisualRoot/Hips/RightThigh/RightThighMesh
@onready var right_shin_mesh: MeshInstance3D = $VisualRoot/Hips/RightThigh/RightShin/RightShinMesh

# State
var current_anim: String = "idle" # "idle", "walk", "roar", "earthshaker", "whirlwind", "stagger", "stunned"
var base_anim: String = "idle"
var anim_time: float = 0.0
var anim_speed: float = 1.0

# Action Timers
var action_time: float = 0.0
const ROAR_DURATION: float = 1.30
const EARTHSHAKER_DURATION: float = 1.45
const WHIRLWIND_DURATION: float = 1.25
const STAGGER_DURATION: float = 1.10

# Blending
var is_blending: bool = false
var blend_timer: float = 0.0
const BLEND_DURATION: float = 0.22
var source_pose: Dictionary = {}
var current_pose: Dictionary = {}

var ground_hips_y: float = 0.65
var current_stance: String = "shoulder"
var default_stance_configs: Dictionary = {}
var stance_configs: Dictionary = {}

# Stun Stars
const StunStarsScript = preload("res://scripts/stun_stars.gd")
var stun_stars: Node3D = null

signal anim_changed(anim_name: String)

func _ready() -> void:
	generate_voxel_meshes()
	_init_stun_stars()
	_init_default_stances()
	load_stance_config()
	current_pose = _compute_pose(current_anim, 0.0)
	_apply_pose(current_pose)

func generate_voxel_meshes() -> void:
	head_mesh.mesh = VoxelBuilder.build_ogre_head_mesh()
	torso_mesh.mesh = VoxelBuilder.build_ogre_torso_mesh()
	warhammer_mesh.mesh = VoxelBuilder.build_ogre_mace_mesh()
	left_arm_mesh.mesh = VoxelBuilder.build_ogre_upper_arm_mesh()
	left_forearm_mesh.mesh = VoxelBuilder.build_ogre_forearm_mesh(false)
	right_arm_mesh.mesh = VoxelBuilder.build_ogre_upper_arm_mesh()
	right_forearm_mesh.mesh = VoxelBuilder.build_ogre_forearm_mesh(true)
	left_thigh_mesh.mesh = VoxelBuilder.build_ogre_thigh_mesh()
	left_shin_mesh.mesh = VoxelBuilder.build_ogre_shin_mesh()
	right_thigh_mesh.mesh = VoxelBuilder.build_ogre_thigh_mesh()
	right_shin_mesh.mesh = VoxelBuilder.build_ogre_shin_mesh()

func _init_stun_stars() -> void:
	stun_stars = StunStarsScript.new()
	stun_stars.name = "StunStarsFX"
	head.add_child(stun_stars)

func _init_default_stances() -> void:
	default_stance_configs = {
		"idle": {
			"right_arm_rot": Vector3(-32.0, 25.0, 35.0),
			"right_forearm_rot": Vector3(-115.0, 0.0, 0.0),
			"warhammer_rot": Vector3(65.0, 0.0, -30.0),
			"left_arm_rot": Vector3(15.0, 0.0, -15.0),
			"left_forearm_rot": Vector3(-25.0, 0.0, 0.0),
			"torso_rot": Vector3(6.0, 0.0, 0.0),
			"head_rot": Vector3(-4.0, 0.0, 0.0)
		},
		"walk": {
			"right_arm_rot": Vector3(25.0, -10.0, 30.0),
			"right_forearm_rot": Vector3(-20.0, 0.0, 0.0),
			"warhammer_rot": Vector3(145.0, 0.0, -10.0),
			"left_arm_rot": Vector3(0.0, 0.0, -20.0),
			"left_forearm_rot": Vector3(-25.0, 0.0, 0.0),
			"torso_rot": Vector3(12.0, 0.0, 0.0),
			"head_rot": Vector3(-8.0, 0.0, 0.0)
		},
		"roar": {
			"right_arm_rot": Vector3(-35.0, 0.0, 35.0),
			"right_forearm_rot": Vector3(-65.0, 0.0, 0.0),
			"warhammer_rot": Vector3(65.0, 0.0, -30.0),
			"left_arm_rot": Vector3(15.0, 0.0, -15.0),
			"left_forearm_rot": Vector3(-25.0, 0.0, 0.0),
			"torso_rot": Vector3(18.0, 0.0, 0.0),
			"head_rot": Vector3(-12.0, 0.0, 0.0)
		},
		"earthshaker": {
			"right_arm_rot": Vector3(-145.0, 0.0, 15.0),
			"right_forearm_rot": Vector3(-35.0, 0.0, 0.0),
			"warhammer_rot": Vector3(-35.0, 0.0, 0.0),
			"left_arm_rot": Vector3(-135.0, 0.0, -15.0),
			"left_forearm_rot": Vector3(-45.0, 0.0, 0.0),
			"torso_rot": Vector3(-32.0, 0.0, 0.0),
			"head_rot": Vector3(12.0, 0.0, 0.0)
		},
		"whirlwind": {
			"right_arm_rot": Vector3(-10.0, 0.0, 75.0),
			"right_forearm_rot": Vector3(-15.0, 0.0, 0.0),
			"warhammer_rot": Vector3(90.0, 0.0, 0.0),
			"left_arm_rot": Vector3(-10.0, 0.0, -75.0),
			"left_forearm_rot": Vector3(-15.0, 0.0, 0.0),
			"torso_rot": Vector3(16.0, 0.0, 0.0),
			"head_rot": Vector3(-10.0, 0.0, 0.0)
		},
		"stagger": {
			"right_arm_rot": Vector3(-35.0, 0.0, 18.0),
			"right_forearm_rot": Vector3(-65.0, 0.0, 0.0),
			"warhammer_rot": Vector3(75.0, 0.0, 0.0),
			"left_arm_rot": Vector3(25.0, 0.0, -25.0),
			"left_forearm_rot": Vector3(-20.0, 0.0, 0.0),
			"torso_rot": Vector3(32.0, 0.0, 0.0),
			"head_rot": Vector3(-22.0, 0.0, 0.0)
		},
		"stunned": {
			"right_arm_rot": Vector3(-32.0, 25.0, 35.0),
			"right_forearm_rot": Vector3(-115.0, 0.0, 0.0),
			"warhammer_rot": Vector3(65.0, 0.0, -30.0),
			"left_arm_rot": Vector3(15.0, 0.0, -15.0),
			"left_forearm_rot": Vector3(-25.0, 0.0, 0.0),
			"torso_rot": Vector3(14.0, 0.0, 0.0),
			"head_rot": Vector3(-8.0, 0.0, 0.0)
		},
		"shoulder": {
			"right_arm_rot": Vector3(-32.0, 25.0, 35.0),
			"right_forearm_rot": Vector3(-115.0, 0.0, 0.0),
			"warhammer_rot": Vector3(65.0, 0.0, -30.0),
			"left_arm_rot": Vector3(15.0, 0.0, -15.0),
			"left_forearm_rot": Vector3(-25.0, 0.0, 0.0),
			"torso_rot": Vector3(6.0, 0.0, 0.0),
			"head_rot": Vector3(-4.0, 0.0, 0.0)
		},
		"ground": {
			"right_arm_rot": Vector3(-15.0, 10.0, 24.0),
			"right_forearm_rot": Vector3(-42.0, 0.0, 0.0),
			"warhammer_rot": Vector3(15.0, 0.0, -10.0),
			"left_arm_rot": Vector3(0.0, 0.0, -18.0),
			"left_forearm_rot": Vector3(-18.0, 0.0, 0.0),
			"torso_rot": Vector3(8.0, 0.0, 0.0),
			"head_rot": Vector3(-2.0, 0.0, 0.0)
		},
		"guard": {
			"right_arm_rot": Vector3(-38.0, -10.0, 18.0),
			"right_forearm_rot": Vector3(-75.0, 0.0, 0.0),
			"warhammer_rot": Vector3(120.0, 25.0, -45.0),
			"left_arm_rot": Vector3(-42.0, 18.0, -15.0),
			"left_forearm_rot": Vector3(-80.0, 0.0, 0.0),
			"torso_rot": Vector3(12.0, 0.0, 0.0),
			"head_rot": Vector3(-6.0, 0.0, 0.0)
		}
	}

func load_stance_config() -> void:
	stance_configs = {}
	for k in default_stance_configs:
		stance_configs[k] = default_stance_configs[k].duplicate()
		
	var path = "res://data/stance_config.json"
	if not FileAccess.file_exists(path):
		path = "user://stance_config.json"
		
	if FileAccess.file_exists(path):
		var f = FileAccess.open(path, FileAccess.READ)
		if f:
			var txt = f.get_as_text()
			f.close()
			var json = JSON.new()
			if json.parse(txt) == OK and json.data is Dictionary:
				var d: Dictionary = json.data
				if d.has("mace_ogre") and d["mace_ogre"] is Dictionary:
					d = d["mace_ogre"]
				elif d.has("chieftain") and d["chieftain"] is Dictionary:
					d = d["chieftain"]
				if d.has("ground_hips_y"):
					ground_hips_y = float(d["ground_hips_y"])
				for s_key in d:
					if d[s_key] is Dictionary:
						if not stance_configs.has(s_key):
							stance_configs[s_key] = {}
						var s_dict = d[s_key]
						for prop in ["right_arm_rot", "right_forearm_rot", "warhammer_rot", "left_arm_rot", "left_forearm_rot", "torso_rot", "head_rot"]:
							if s_dict.has(prop) and s_dict[prop] is Array and s_dict[prop].size() == 3:
								stance_configs[s_key][prop] = Vector3(float(s_dict[prop][0]), float(s_dict[prop][1]), float(s_dict[prop][2]))

func get_stance_definitions() -> Array:
	return [
		{"id": "idle", "name": "Uy Vũ", "shortcut": "[ 1 ]"},
		{"id": "walk", "name": "Bước Nặng", "shortcut": "[ 2 ]"},
		{"id": "roar", "name": "Gầm Thét", "shortcut": "[ 3 ]"},
		{"id": "earthshaker", "name": "Địa Chấn", "shortcut": "[ 4 ]"},
		{"id": "whirlwind", "name": "Bão Chùy 360°", "shortcut": "[ 5 ]"},
		{"id": "stagger", "name": "Quỳ Gối", "shortcut": "[ 6 ]"},
		{"id": "stunned", "name": "Choáng", "shortcut": "[ 7 ]"},
		{"id": "shoulder", "name": "Vác Đại Chùy", "shortcut": "[ Q ]"},
		{"id": "ground", "name": "Chống Chùy Đất", "shortcut": "[ W ]"},
		{"id": "guard", "name": "Thủ Trọng Lực", "shortcut": "[ E ]"}
	]

func get_weapon_info() -> Dictionary:
	return {
		"title": "🔨 ĐẠI CHÙY NGUYÊN THỦY (GÓC CHÙY)",
		"prop": "warhammer_rot"
	}

func copy_weapon_from_idle(target_anim: String) -> void:
	var src_key = "idle" if stance_configs.has("idle") else "shoulder"
	if not stance_configs.has(src_key) or not stance_configs.has(target_anim):
		return
	var src = stance_configs[src_key]
	var dst = stance_configs[target_anim]
	if src.has("warhammer_rot"):
		dst["warhammer_rot"] = src["warhammer_rot"]

func serialize_stances() -> Dictionary:
	var out: Dictionary = {
		"ground_hips_y": ground_hips_y
	}
	for s_key in stance_configs:
		out[s_key] = _serialize_stance(stance_configs[s_key])
	return out

func save_stance_config() -> bool:
	var path = "res://data/stance_config.json"
	var all_cfg: Dictionary = {}
	if FileAccess.file_exists(path):
		var f_in = FileAccess.open(path, FileAccess.READ)
		if f_in:
			var json = JSON.new()
			if json.parse(f_in.get_as_text()) == OK and json.data is Dictionary:
				all_cfg = json.data
			f_in.close()
	var stances_serialized = serialize_stances()
	all_cfg["chieftain"] = stances_serialized
	all_cfg["mace_ogre"] = stances_serialized
	
	var f = FileAccess.open(path, FileAccess.WRITE)
	if f:
		f.store_string(JSON.stringify(all_cfg, "\t"))
		f.close()
	var f2 = FileAccess.open("user://stance_config.json", FileAccess.WRITE)
	if f2:
		f2.store_string(JSON.stringify(all_cfg, "\t"))
		f2.close()
	return true

func _serialize_stance(s: Dictionary) -> Dictionary:
	var out = {}
	for k in ["right_arm_rot", "right_forearm_rot", "warhammer_rot", "left_arm_rot", "left_forearm_rot", "torso_rot", "head_rot"]:
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
	current_pose = _compute_pose(current_anim, anim_time)
	_apply_pose(current_pose)

func _get_active_stance_cfg(anim: String = "") -> Dictionary:
	if anim != "" and stance_configs.has(anim):
		return stance_configs[anim]
	if current_anim != "" and stance_configs.has(current_anim):
		return stance_configs[current_anim]
	var st_key = current_stance if stance_configs.has(current_stance) else "shoulder"
	return stance_configs.get(st_key, default_stance_configs.get("shoulder", {}))

func _lerp_angles(a: Vector3, b: Vector3, weight: float) -> Vector3:
	return Vector3(
		lerpf(a.x, b.x, weight),
		lerpf(a.y, b.y, weight),
		lerpf(a.z, b.z, weight)
	)

func set_live_ground_hips_y(val: float) -> void:
	ground_hips_y = val
	current_pose = _compute_pose(current_anim, anim_time)
	_apply_pose(current_pose)

func play_anim(anim_name: String) -> void:
	if current_anim == anim_name and current_anim not in ["roar", "earthshaker", "whirlwind", "stagger"]:
		return
	_start_blend()
	current_anim = anim_name
	action_time = 0.0
	
	if current_anim in ["idle", "shoulder", "ground", "guard", "walk", "stunned"]:
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
	
	if current_anim == "roar":
		action_time += dt
		if action_time >= ROAR_DURATION:
			current_anim = base_anim
			action_time = 0.0
			_start_blend()
			emit_signal("anim_changed", current_anim)
	elif current_anim == "earthshaker":
		action_time += dt
		if action_time >= EARTHSHAKER_DURATION:
			current_anim = base_anim
			action_time = 0.0
			_start_blend()
			emit_signal("anim_changed", current_anim)
	elif current_anim == "whirlwind":
		action_time += dt
		if action_time >= WHIRLWIND_DURATION:
			current_anim = base_anim
			action_time = 0.0
			_start_blend()
			emit_signal("anim_changed", current_anim)
	elif current_anim == "stagger":
		action_time += dt
		if action_time >= STAGGER_DURATION:
			current_anim = base_anim
			action_time = 0.0
			_start_blend()
			emit_signal("anim_changed", current_anim)
			
	if stun_stars:
		stun_stars.set_active(current_anim == "stunned")
		
	var target_pose = _compute_pose(current_anim, anim_time)
	
	if is_blending:
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
	match anim:
		"idle":
			match current_stance:
				"shoulder": return _compute_shoulder(time_val)
				"ground": return _compute_ground(time_val)
				"guard": return _compute_guard(time_val)
				_: return _compute_shoulder(time_val)
		"shoulder": return _compute_shoulder(time_val)
		"ground": return _compute_ground(time_val)
		"guard": return _compute_guard(time_val)
		"walk": return _compute_walk(time_val)
		"roar": return _compute_roar(action_time)
		"earthshaker": return _compute_earthshaker(action_time)
		"whirlwind": return _compute_whirlwind(action_time)
		"stagger": return _compute_stagger(action_time)
		"stunned": return _compute_stunned(time_val)
		_: return _compute_shoulder(time_val)

# --- 1. SHOULDER (Vác Đại Búa Trên Vai) ---
func _compute_shoulder(time_val: float) -> Dictionary:
	var p: Dictionary = {}
	var t = time_val * 1.8
	var breath = sin(t) * 0.012
	var cfg = stance_configs.get("shoulder", default_stance_configs.get("shoulder", {}))
	
	p["hips_pos"] = Vector3(0.0, ground_hips_y + breath, 0.0)
	p["hips_rot"] = Vector3(4.0, sin(t * 0.5) * 4.0, 0.0)
	p["torso_rot"] = cfg.get("torso_rot", Vector3(6.0, 0.0, 0.0)) + Vector3(sin(t) * 2.0, 0, 0)
	p["head_rot"] = cfg.get("head_rot", Vector3(-4.0, 0.0, 0.0)) + Vector3(0, sin(t * 0.7) * 8.0, 0)
	
	p["right_arm_rot"] = cfg.get("right_arm_rot", Vector3(-32.0, 25.0, 35.0)) + Vector3(breath * 20.0, 0, 0)
	p["right_forearm_rot"] = cfg.get("right_forearm_rot", Vector3(-115.0, 0.0, 0.0))
	p["warhammer_rot"] = cfg.get("warhammer_rot", Vector3(65.0, 0.0, -30.0))
	
	p["left_arm_rot"] = cfg.get("left_arm_rot", Vector3(15.0, 0.0, -15.0)) + Vector3(-breath * 20.0, 0, 0)
	p["left_forearm_rot"] = cfg.get("left_forearm_rot", Vector3(-25.0, 0.0, 0.0))
	
	p["left_thigh_rot"] = Vector3(-4.0, 0.0, -5.0)
	p["left_shin_rot"] = Vector3(8.0, 0.0, 0.0)
	p["right_thigh_rot"] = Vector3(4.0, 0.0, 5.0)
	p["right_shin_rot"] = Vector3(6.0, 0.0, 0.0)
	return p

# --- 2. GROUND (Chống Đại Búa Xuống Mặt Đất) ---
func _compute_ground(time_val: float) -> Dictionary:
	var p: Dictionary = {}
	var t = time_val * 1.8
	var breath = sin(t) * 0.015
	var cfg = stance_configs.get("ground", default_stance_configs.get("ground", {}))
	
	p["hips_pos"] = Vector3(0.0, ground_hips_y + breath, 0.0)
	p["hips_rot"] = Vector3(4.0, sin(t * 0.5) * 4.0, 0.0)
	p["torso_rot"] = cfg.get("torso_rot", Vector3(8.0, 0.0, 0.0)) + Vector3(sin(t) * 3.0, 0.0, 0.0)
	p["head_rot"] = cfg.get("head_rot", Vector3(-2.0, 0.0, 0.0)) + Vector3(0, sin(t * 0.7) * 8.0, 0.0)
	
	p["right_arm_rot"] = cfg.get("right_arm_rot", Vector3(-15.0, 10.0, 24.0)) + Vector3(breath * 30.0, 0, 0)
	p["right_forearm_rot"] = cfg.get("right_forearm_rot", Vector3(-42.0, 0.0, 0.0))
	p["warhammer_rot"] = cfg.get("warhammer_rot", Vector3(15.0, 0.0, -10.0))
	
	p["left_arm_rot"] = cfg.get("left_arm_rot", Vector3(0.0, 0.0, -18.0)) + Vector3(-breath * 20.0, 0, 0)
	p["left_forearm_rot"] = cfg.get("left_forearm_rot", Vector3(-18.0, 0.0, 0.0))
	
	p["left_thigh_rot"] = Vector3(-4.0, 0.0, -5.0)
	p["left_shin_rot"] = Vector3(8.0, 0.0, 0.0)
	p["right_thigh_rot"] = Vector3(4.0, 0.0, 5.0)
	p["right_shin_rot"] = Vector3(6.0, 0.0, 0.0)
	return p

# --- 3. GUARD (Thủ Trọng Lực Giữ Búa Trước Thân) ---
func _compute_guard(time_val: float) -> Dictionary:
	var p: Dictionary = {}
	var t = time_val * 2.2
	var breath = sin(t) * 0.010
	var cfg = stance_configs.get("guard", default_stance_configs.get("guard", {}))
	
	p["hips_pos"] = Vector3(0.0, ground_hips_y + breath - 0.03, 0.0)
	p["hips_rot"] = Vector3(8.0, sin(t * 0.4) * 3.0, 0.0)
	p["torso_rot"] = cfg.get("torso_rot", Vector3(12.0, 0.0, 0.0)) + Vector3(sin(t) * 1.5, 0, 0)
	p["head_rot"] = cfg.get("head_rot", Vector3(-6.0, 0.0, 0.0))
	
	p["right_arm_rot"] = cfg.get("right_arm_rot", Vector3(-38.0, -10.0, 18.0))
	p["right_forearm_rot"] = cfg.get("right_forearm_rot", Vector3(-75.0, 0.0, 0.0))
	p["warhammer_rot"] = cfg.get("warhammer_rot", Vector3(120.0, 25.0, -45.0))
	
	p["left_arm_rot"] = cfg.get("left_arm_rot", Vector3(-42.0, 18.0, -15.0))
	p["left_forearm_rot"] = cfg.get("left_forearm_rot", Vector3(-80.0, 0.0, 0.0))
	
	p["left_thigh_rot"] = Vector3(-12.0, 0.0, -8.0)
	p["left_shin_rot"] = Vector3(18.0, 0.0, 0.0)
	p["right_thigh_rot"] = Vector3(8.0, 0.0, 8.0)
	p["right_shin_rot"] = Vector3(14.0, 0.0, 0.0)
	return p

# --- 2. WALK (Earth-Shaking Heavy Lumbering Stride with Colossal Weight & Dynamic Inertia) ---
func _compute_walk(time_val: float) -> Dictionary:
	var p: Dictionary = {}
	# Heavy, deliberate, intimidating pace (2.5 rad/s ~ 1.25s full stride cycle)
	var t = time_val * 2.5
	var s_leg = sin(t)
	var c_leg = cos(t)
	
	# HIPS DYNAMICS:
	# 1. Lateral weight shift (Side-to-side sway as weight shifts over bearing foot: +/-0.042m)
	# 2. Smooth vertical bobbing: Lowest on foot plants (-cos(2t)), highest on passing leg
	p["hips_pos"] = Vector3(
		sin(t) * 0.042,
		ground_hips_y - cos(2.0 * t) * 0.030,
		0.0
	)
	
	# Hips Rotation:
	# Pitch (12° forward lean + 1.5° stomp bounce), Yaw (7° rotation with stride), Roll (4.2° pelvic list tilt)
	p["hips_rot"] = Vector3(
		12.0 + cos(2.0 * t) * 1.5,
		s_leg * 7.0,
		-c_leg * 4.2
	)
	
	# TORSO DYNAMICS:
	# Counter-rotates spine and counter-tilts roll to maintain center of mass balance
	p["torso_rot"] = Vector3(
		14.0 - cos(2.0 * t) * 2.0,
		-s_leg * 6.0,
		c_leg * 3.2
	)
	
	# HEAD DYNAMICS:
	# Cervical stabilization: keeps eyes focused forward on horizon, chin tucked, slight aggressive head bob
	p["head_rot"] = Vector3(
		-8.0 + cos(2.0 * t) * 2.0,
		-s_leg * 3.5,
		-c_leg * 2.0
	)
	
	# LEGS KINEMATICS (2-Phase Biomechanical Knee Flexion: Stance Shock Absorption + Passing High Lift):
	# Left Leg:
	var thigh_l = -c_leg * 24.0
	var stance_l = pow(maxf(0.0, cos(t - 0.25 * PI)), 2.0) * 12.0 # Elastic weight absorption on plant
	var swing_l = pow(maxf(0.0, cos(t - 1.35 * PI)), 1.8) * 38.0  # High clearance lift on swing
	p["left_thigh_rot"] = Vector3(thigh_l, 0.0, -6.0) # Wide beastly stance (-6° outward splay)
	p["left_shin_rot"] = Vector3(8.0 + stance_l + swing_l, 0.0, 0.0) # Never locked straight!
	
	# Right Leg (180° / PI phase shifted):
	var t_r = t + PI
	var thigh_r = -cos(t_r) * 24.0
	var stance_r = pow(maxf(0.0, cos(t_r - 0.25 * PI)), 2.0) * 12.0
	var swing_r = pow(maxf(0.0, cos(t_r - 1.35 * PI)), 1.8) * 38.0
	p["right_thigh_rot"] = Vector3(thigh_r, 0.0, 6.0) # Wide beastly stance (+6° outward splay)
	p["right_shin_rot"] = Vector3(8.0 + stance_r + swing_r, 0.0, 0.0)
	
	# UPPER BODY, ARMS & WARHAMMER DYNAMICS:
	var st_key = "walk" if stance_configs.has("walk") else (current_stance if (stance_configs.has(current_stance) and current_stance != "guard") else "shoulder")
	var cfg = stance_configs.get(st_key, default_stance_configs.get(st_key, default_stance_configs.get("shoulder", {})))
	var base_hammer: Vector3 = cfg.get("warhammer_rot", Vector3(145.0, 0.0, -10.0))
	var base_r_arm: Vector3 = cfg.get("right_arm_rot", Vector3(25.0, -10.0, 30.0))
	var base_r_fore: Vector3 = cfg.get("right_forearm_rot", Vector3(-20.0, 0.0, 0.0))
	var base_l_arm: Vector3 = cfg.get("left_arm_rot", Vector3(0.0, 0.0, -20.0))
	var base_l_fore: Vector3 = cfg.get("left_forearm_rot", Vector3(-25.0, 0.0, 0.0))
	
	# Right Arm & Warhammer: Heavy inertia lag and bicep cushioning on stomp impacts
	var hammer_heave = cos(2.0 * t) * 3.5
	var arm_r_swing = cos(t) * 8.0
	var elbow_r_cushion = -cos(2.0 * t) * 5.0
	var hammer_inertia = cos(t - 0.3) * 5.0 + sin(2.0 * t) * 3.0
	p["right_arm_rot"] = base_r_arm + Vector3(arm_r_swing + hammer_heave, 0.0, sin(t) * 2.0)
	p["right_forearm_rot"] = base_r_fore + Vector3(elbow_r_cushion, 0.0, 0.0)
	p["warhammer_rot"] = base_hammer + Vector3(hammer_inertia, 0.0, 0.0)
	
	# Left Arm: Free natural counter-swing with rhythmic forearm flexing & breathing elbow articulation
	var arm_l_swing = -s_leg * 22.0
	var elbow_l_flex = s_leg * 16.0 # Dynamic flex: bends on forward swing, relaxes on backswing
	p["left_arm_rot"] = base_l_arm + Vector3(arm_l_swing, 0.0, -c_leg * 3.0)
	p["left_forearm_rot"] = base_l_fore + Vector3(elbow_l_flex, 0.0, 0.0)
	
	return p

# --- 3. WAR ROAR (Pound Chest, Skyward Roar with Hammer Aloft) ---
func _compute_roar(t_r: float) -> Dictionary:
	var p: Dictionary = {}
	var tau = clampf(t_r / ROAR_DURATION, 0.0, 1.0)
	var cfg = _get_active_stance_cfg()
	var base_hammer: Vector3 = cfg.get("warhammer_rot", Vector3(65.0, 0.0, -30.0))
	var base_r_arm: Vector3 = cfg.get("right_arm_rot", Vector3(-32.0, 25.0, 35.0))
	var base_r_fore: Vector3 = cfg.get("right_forearm_rot", Vector3(-115.0, 0.0, 0.0))
	var base_l_arm: Vector3 = cfg.get("left_arm_rot", Vector3(15.0, 0.0, -15.0))
	var base_l_fore: Vector3 = cfg.get("left_forearm_rot", Vector3(-25.0, 0.0, 0.0))
	
	if tau < 0.35:
		# Chest pound windup
		var s = smoothstep(0.0, 1.0, tau / 0.35)
		p["hips_pos"] = Vector3(0.0, ground_hips_y - 0.04, 0.0)
		p["hips_rot"] = Vector3(14.0, 0.0, 0.0)
		p["torso_rot"] = Vector3(18.0, 0.0, 0.0)
		p["head_rot"] = Vector3(-12.0, 0.0, 0.0)
		
		# Left fist strikes chest
		p["left_arm_rot"] = _lerp_angles(base_l_arm, Vector3(-45.0, 45.0, 15.0), s)
		p["left_forearm_rot"] = _lerp_angles(base_l_fore, Vector3(-110.0, 0.0, 0.0), s)
		
		# Right hand lifts warhammer off ground
		p["right_arm_rot"] = _lerp_angles(base_r_arm, Vector3(-35.0, 0.0, 35.0), s)
		p["right_forearm_rot"] = _lerp_angles(base_r_fore, Vector3(-65.0, 0.0, 0.0), s)
		p["warhammer_rot"] = _lerp_angles(base_hammer, Vector3(90.0, 0.0, 0.0), s)
		
		p["left_thigh_rot"] = Vector3(-16.0, 0.0, -8.0)
		p["left_shin_rot"] = Vector3(26.0, 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(12.0, 0.0, 8.0)
		p["right_shin_rot"] = Vector3(20.0, 0.0, 0.0)
		
	elif tau < 0.85:
		# ROAR TO THE HEAVENS! (Hammer held high skyward, head arched back, chest shaking)
		var _s = smoothstep(0.0, 1.0, (tau - 0.35) / 0.15)
		var roar_shake = sin(t_r * 55.0) * 1.5
		
		p["hips_pos"] = Vector3(0.0, ground_hips_y + 0.05, 0.0)
		p["hips_rot"] = Vector3(-8.0, 0.0, 0.0)
		p["torso_rot"] = Vector3(-24.0 + roar_shake, 0.0, 0.0)
		p["head_rot"] = Vector3(-35.0 + roar_shake, 0.0, 0.0)
		
		# Warhammer raised straight up into the air
		p["right_arm_rot"] = Vector3(-135.0 + roar_shake, 10.0, 20.0)
		p["right_forearm_rot"] = Vector3(-15.0, 0.0, 0.0)
		p["warhammer_rot"] = Vector3(0.0, 0.0, 0.0)
		
		# Left arm splayed in roar
		p["left_arm_rot"] = Vector3(-115.0 + roar_shake, -15.0, -45.0)
		p["left_forearm_rot"] = Vector3(-45.0, 0.0, 0.0)
		
		p["left_thigh_rot"] = Vector3(10.0, 0.0, -8.0)
		p["left_shin_rot"] = Vector3(12.0, 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(8.0, 0.0, 8.0)
		p["right_shin_rot"] = Vector3(14.0, 0.0, 0.0)
		
	else:
		# Recovery
		var s = smoothstep(0.0, 1.0, (tau - 0.85) / 0.15)
		p["hips_pos"] = Vector3(0.0, ground_hips_y, 0.0)
		p["hips_rot"] = Vector3(lerp(-8.0, 4.0, s), 0.0, 0.0)
		p["torso_rot"] = Vector3(lerp(-24.0, 8.0, s), 0.0, 0.0)
		p["head_rot"] = Vector3(lerp(-35.0, -4.0, s), 0.0, 0.0)
		
		p["right_arm_rot"] = _lerp_angles(Vector3(-135.0, 10.0, 20.0), base_r_arm, s)
		p["right_forearm_rot"] = _lerp_angles(Vector3(-15.0, 0.0, 0.0), base_r_fore, s)
		p["warhammer_rot"] = _lerp_angles(Vector3(0.0, 0.0, 0.0), base_hammer, s)
		
		p["left_arm_rot"] = _lerp_angles(Vector3(-115.0, -15.0, -45.0), base_l_arm, s)
		p["left_forearm_rot"] = _lerp_angles(Vector3(-45.0, 0.0, 0.0), base_l_fore, s)
		
		p["left_thigh_rot"] = Vector3(-4.0, 0.0, -5.0)
		p["left_shin_rot"] = Vector3(8.0, 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(4.0, 0.0, 5.0)
		p["right_shin_rot"] = Vector3(6.0, 0.0, 0.0)
	return p

# --- 4. EARTHSHAKER SLAM (High Leap, Titanic 2-Handed Ground Smash) ---
func _compute_earthshaker(t_e: float) -> Dictionary:
	var p: Dictionary = {}
	var tau = clampf(t_e / EARTHSHAKER_DURATION, 0.0, 1.0)
	var cfg = _get_active_stance_cfg()
	var base_hammer: Vector3 = cfg.get("warhammer_rot", Vector3(65.0, 0.0, -30.0))
	var base_r_arm: Vector3 = cfg.get("right_arm_rot", Vector3(-32.0, 25.0, 35.0))
	var base_r_fore: Vector3 = cfg.get("right_forearm_rot", Vector3(-115.0, 0.0, 0.0))
	var base_l_arm: Vector3 = cfg.get("left_arm_rot", Vector3(15.0, 0.0, -15.0))
	var base_l_fore: Vector3 = cfg.get("left_forearm_rot", Vector3(-25.0, 0.0, 0.0))
	
	if tau < 0.38:
		# WINDUP LEAP (0.0s - 0.55s): Leap into the air raising massive hammer overhead
		var s = tau / 0.38
		var y_rise = sin(s * PI) * 0.28
		var z_adv = s * 0.22
		
		p["hips_pos"] = Vector3(0.0, ground_hips_y + y_rise, z_adv)
		p["hips_rot"] = Vector3(lerp(4.0, -18.0, s), 0.0, 0.0)
		p["torso_rot"] = Vector3(lerp(8.0, -32.0, s), 0.0, 0.0)
		p["head_rot"] = Vector3(lerp(-4.0, 12.0, s), 0.0, 0.0)
		
		# Both hands gripping hammer high overhead
		p["right_arm_rot"] = _lerp_angles(base_r_arm, Vector3(-145.0, 0.0, 15.0), s)
		p["right_forearm_rot"] = _lerp_angles(base_r_fore, Vector3(-35.0, 0.0, 0.0), s)
		p["warhammer_rot"] = _lerp_angles(base_hammer, Vector3(-35.0, 0.0, 0.0), s)
		
		p["left_arm_rot"] = _lerp_angles(base_l_arm, Vector3(-135.0, 0.0, -15.0), s)
		p["left_forearm_rot"] = _lerp_angles(base_l_fore, Vector3(-45.0, 0.0, 0.0), s)
		
		p["left_thigh_rot"] = Vector3(-35.0, 0.0, -6.0)
		p["left_shin_rot"] = Vector3(50.0, 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(-20.0, 0.0, 6.0)
		p["right_shin_rot"] = Vector3(45.0, 0.0, 0.0)
		
	elif tau < 0.52:
		# CATACLYSMIC IMPACT (0.38s - 0.75s): Smash down into earth!
		var s = smoothstep(0.0, 1.0, (tau - 0.38) / 0.14)
		p["hips_pos"] = Vector3(0.0, lerp(ground_hips_y + 0.15, ground_hips_y - 0.12, s), 0.22)
		p["hips_rot"] = Vector3(lerp(-18.0, 32.0, s), 0.0, 0.0)
		p["torso_rot"] = Vector3(lerp(-32.0, 48.0, s), 0.0, 0.0)
		p["head_rot"] = Vector3(lerp(12.0, -18.0, s), 0.0, 0.0)
		
		# Hammer slammed into ground
		p["right_arm_rot"] = Vector3(lerp(-145.0, -35.0, s), 0.0, 12.0)
		p["right_forearm_rot"] = Vector3(lerp(-35.0, -75.0, s), 0.0, 0.0)
		p["warhammer_rot"] = Vector3(lerp(-35.0, 75.0, s), 0.0, 0.0)
		
		p["left_arm_rot"] = Vector3(lerp(-135.0, -25.0, s), 0.0, -25.0)
		p["left_forearm_rot"] = Vector3(-55.0, 0.0, 0.0)
		
		# Deep impact squat
		p["left_thigh_rot"] = Vector3(lerp(-35.0, -36.0, s), 0.0, -10.0)
		p["left_shin_rot"] = Vector3(lerp(50.0, 52.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(-20.0, 24.0, s), 0.0, 10.0)
		p["right_shin_rot"] = Vector3(lerp(45.0, 35.0, s), 0.0, 0.0)
		
	elif tau < 0.75:
		# HIT-STOP CRATER FREEZE & SHAKE (0.52s - 1.08s)
		var shake = sin(t_e * 60.0) * 0.8
		p["hips_pos"] = Vector3(0.0, ground_hips_y - 0.12, 0.22)
		p["hips_rot"] = Vector3(32.0, 0.0, 0.0)
		p["torso_rot"] = Vector3(48.0 + shake, 0.0, 0.0)
		p["head_rot"] = Vector3(-18.0, 0.0, 0.0)
		
		p["right_arm_rot"] = Vector3(-35.0, 0.0, 12.0)
		p["right_forearm_rot"] = Vector3(-75.0, 0.0, 0.0)
		p["warhammer_rot"] = Vector3(75.0, 0.0, 0.0)
		
		p["left_arm_rot"] = Vector3(-25.0, 0.0, -25.0)
		p["left_forearm_rot"] = Vector3(-55.0, 0.0, 0.0)
		
		p["left_thigh_rot"] = Vector3(-36.0, 0.0, -10.0)
		p["left_shin_rot"] = Vector3(52.0, 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(24.0, 0.0, 10.0)
		p["right_shin_rot"] = Vector3(35.0, 0.0, 0.0)
		
	else:
		# PULL HAMMER OUT & RECOVER (0.75s - 1.45s)
		var s = smoothstep(0.0, 1.0, (tau - 0.75) / 0.25)
		p["hips_pos"] = Vector3(0.0, lerp(ground_hips_y - 0.12, ground_hips_y, s), lerp(0.22, 0.0, s))
		p["hips_rot"] = Vector3(lerp(32.0, 4.0, s), 0.0, 0.0)
		p["torso_rot"] = Vector3(lerp(48.0, 8.0, s), 0.0, 0.0)
		p["head_rot"] = Vector3(lerp(-18.0, -4.0, s), 0.0, 0.0)
		
		p["right_arm_rot"] = _lerp_angles(Vector3(-35.0, 0.0, 12.0), base_r_arm, s)
		p["right_forearm_rot"] = _lerp_angles(Vector3(-75.0, 0.0, 0.0), base_r_fore, s)
		p["warhammer_rot"] = _lerp_angles(Vector3(75.0, 0.0, 0.0), base_hammer, s)
		
		p["left_arm_rot"] = _lerp_angles(Vector3(-25.0, 0.0, -25.0), base_l_arm, s)
		p["left_forearm_rot"] = _lerp_angles(Vector3(-55.0, 0.0, 0.0), base_l_fore, s)
		
		p["left_thigh_rot"] = Vector3(lerp(-36.0, -4.0, s), 0.0, -5.0)
		p["left_shin_rot"] = Vector3(lerp(52.0, 8.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(24.0, 4.0, s), 0.0, 5.0)
		p["right_shin_rot"] = Vector3(lerp(35.0, 6.0, s), 0.0, 0.0)
	return p

# --- 5. WHIRLWIND 360 (Full Centrifugal Spin Hammer Sweep) ---
func _compute_whirlwind(t_w: float) -> Dictionary:
	var p: Dictionary = {}
	var tau = clampf(t_w / WHIRLWIND_DURATION, 0.0, 1.0)
	var cfg = _get_active_stance_cfg()
	var base_hammer: Vector3 = cfg.get("warhammer_rot", Vector3(65.0, 0.0, -30.0))
	var base_r_arm: Vector3 = cfg.get("right_arm_rot", Vector3(-32.0, 25.0, 35.0))
	var base_r_fore: Vector3 = cfg.get("right_forearm_rot", Vector3(-115.0, 0.0, 0.0))
	var base_l_arm: Vector3 = cfg.get("left_arm_rot", Vector3(15.0, 0.0, -15.0))
	var base_l_fore: Vector3 = cfg.get("left_forearm_rot", Vector3(-25.0, 0.0, 0.0))
	
	if tau < 0.22:
		# Windup torque: twist back
		var s = smoothstep(0.0, 1.0, tau / 0.22)
		p["hips_pos"] = Vector3(0.0, ground_hips_y - 0.04, 0.0)
		p["hips_rot"] = Vector3(8.0, lerp(0.0, -45.0, s), 0.0)
		p["torso_rot"] = Vector3(14.0, lerp(0.0, -55.0, s), 0.0)
		p["head_rot"] = Vector3(-8.0, lerp(0.0, 45.0, s), 0.0)
		
		p["right_arm_rot"] = _lerp_angles(base_r_arm, Vector3(35.0, -45.0, 45.0), s)
		p["right_forearm_rot"] = _lerp_angles(base_r_fore, Vector3(-35.0, 0.0, 0.0), s)
		p["warhammer_rot"] = _lerp_angles(base_hammer, Vector3(110.0, 0.0, 0.0), s)
		
		p["left_arm_rot"] = _lerp_angles(base_l_arm, Vector3(-25.0, 20.0, -25.0), s)
		p["left_forearm_rot"] = _lerp_angles(base_l_fore, Vector3(-65.0, 0.0, 0.0), s)
		
		p["left_thigh_rot"] = Vector3(-14.0, 0.0, -6.0)
		p["left_shin_rot"] = Vector3(22.0, 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(12.0, 0.0, 6.0)
		p["right_shin_rot"] = Vector3(24.0, 0.0, 0.0)
		
	elif tau < 0.72:
		# 360 DEGREE SPIN! (0.22s - 0.90s)
		var s = (tau - 0.22) / 0.50
		var spin_angle = -45.0 + s * 360.0
		
		p["hips_pos"] = Vector3(0.0, ground_hips_y - 0.02, 0.0)
		p["hips_rot"] = Vector3(12.0, spin_angle, 0.0)
		p["torso_rot"] = Vector3(16.0, spin_angle * 0.15, 0.0)
		p["head_rot"] = Vector3(-10.0, 0.0, 0.0)
		
		# Hammer outstretched horizontally at waist height
		p["right_arm_rot"] = Vector3(-10.0, 0.0, 75.0)
		p["right_forearm_rot"] = Vector3(-15.0, 0.0, 0.0)
		p["warhammer_rot"] = Vector3(90.0, 0.0, 0.0)
		
		# Left arm out for balance
		p["left_arm_rot"] = Vector3(-10.0, 0.0, -75.0)
		p["left_forearm_rot"] = Vector3(-15.0, 0.0, 0.0)
		
		p["left_thigh_rot"] = Vector3(sin(s * TAU * 2.0) * 16.0, 0.0, -6.0)
		p["left_shin_rot"] = Vector3(20.0, 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(-sin(s * TAU * 2.0) * 16.0, 0.0, 6.0)
		p["right_shin_rot"] = Vector3(20.0, 0.0, 0.0)
		
	else:
		# BRAKE & PLANT RECOVERY
		var s = smoothstep(0.0, 1.0, (tau - 0.72) / 0.28)
		p["hips_pos"] = Vector3(0.0, ground_hips_y, 0.0)
		p["hips_rot"] = Vector3(lerp(12.0, 4.0, s), 0.0, 0.0)
		p["torso_rot"] = Vector3(lerp(16.0, 8.0, s), 0.0, 0.0)
		p["head_rot"] = Vector3(-4.0, 0.0, 0.0)
		
		p["right_arm_rot"] = _lerp_angles(Vector3(-10.0, 0.0, 75.0), base_r_arm, s)
		p["right_forearm_rot"] = _lerp_angles(Vector3(-15.0, 0.0, 0.0), base_r_fore, s)
		p["warhammer_rot"] = _lerp_angles(Vector3(90.0, 0.0, 0.0), base_hammer, s)
		
		p["left_arm_rot"] = _lerp_angles(Vector3(-10.0, 0.0, -75.0), base_l_arm, s)
		p["left_forearm_rot"] = _lerp_angles(Vector3(-15.0, 0.0, 0.0), base_l_fore, s)
		
		p["left_thigh_rot"] = Vector3(-4.0, 0.0, -5.0)
		p["left_shin_rot"] = Vector3(8.0, 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(4.0, 0.0, 5.0)
		p["right_shin_rot"] = Vector3(6.0, 0.0, 0.0)
	return p

# --- 6. STAGGER / POISE BREAK (Drop to One Knee, Hammer Bracing) ---
func _compute_stagger(t_s: float) -> Dictionary:
	var p: Dictionary = {}
	var tau = clampf(t_s / STAGGER_DURATION, 0.0, 1.0)
	var cfg = _get_active_stance_cfg()
	var base_hammer: Vector3 = cfg.get("warhammer_rot", Vector3(65.0, 0.0, -30.0))
	var base_r_arm: Vector3 = cfg.get("right_arm_rot", Vector3(-32.0, 25.0, 35.0))
	var base_r_fore: Vector3 = cfg.get("right_forearm_rot", Vector3(-115.0, 0.0, 0.0))
	var base_l_arm: Vector3 = cfg.get("left_arm_rot", Vector3(15.0, 0.0, -15.0))
	var base_l_fore: Vector3 = cfg.get("left_forearm_rot", Vector3(-25.0, 0.0, 0.0))
	
	if tau < 0.35:
		# Drop hard onto right knee
		var s = smoothstep(0.0, 1.0, tau / 0.35)
		p["hips_pos"] = Vector3(0.0, lerp(ground_hips_y, ground_hips_y - 0.22, s), lerp(0.0, -0.15, s))
		p["hips_rot"] = Vector3(lerp(4.0, 16.0, s), 0.0, 0.0)
		p["torso_rot"] = Vector3(lerp(8.0, 32.0, s), 0.0, 0.0)
		p["head_rot"] = Vector3(lerp(-4.0, -22.0, s), 0.0, 0.0)
		
		# Hammer planted to brace
		p["right_arm_rot"] = _lerp_angles(base_r_arm, Vector3(-35.0, 0.0, 18.0), s)
		p["right_forearm_rot"] = _lerp_angles(base_r_fore, Vector3(-65.0, 0.0, 0.0), s)
		p["warhammer_rot"] = _lerp_angles(base_hammer, Vector3(75.0, 0.0, 0.0), s)
		
		p["left_arm_rot"] = _lerp_angles(base_l_arm, Vector3(25.0, 0.0, -25.0), s)
		p["left_forearm_rot"] = _lerp_angles(base_l_fore, Vector3(-20.0, 0.0, 0.0), s)
		
		# Right knee to ground
		p["left_thigh_rot"] = Vector3(lerp(-4.0, -38.0, s), 0.0, -8.0)
		p["left_shin_rot"] = Vector3(lerp(8.0, 55.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(4.0, 48.0, s), 0.0, 8.0)
		p["right_shin_rot"] = Vector3(lerp(6.0, 85.0, s), 0.0, 0.0)
		
	elif tau < 0.75:
		# Panting & groggy on knee
		var pant = sin(t_s * 12.0) * 0.02
		p["hips_pos"] = Vector3(0.0, ground_hips_y - 0.22 + pant, -0.15)
		p["hips_rot"] = Vector3(16.0, 0.0, 0.0)
		p["torso_rot"] = Vector3(32.0 + pant * 100.0, 0.0, 0.0)
		p["head_rot"] = Vector3(-22.0, 0.0, 0.0)
		
		p["right_arm_rot"] = Vector3(-35.0, 0.0, 18.0)
		p["right_forearm_rot"] = Vector3(-65.0, 0.0, 0.0)
		p["warhammer_rot"] = Vector3(75.0, 0.0, 0.0)
		
		p["left_arm_rot"] = Vector3(25.0, 0.0, -25.0)
		p["left_forearm_rot"] = Vector3(-20.0, 0.0, 0.0)
		
		p["left_thigh_rot"] = Vector3(-38.0, 0.0, -8.0)
		p["left_shin_rot"] = Vector3(55.0, 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(48.0, 0.0, 8.0)
		p["right_shin_rot"] = Vector3(85.0, 0.0, 0.0)
		
	else:
		# Stand back up angrily
		var s = smoothstep(0.0, 1.0, (tau - 0.75) / 0.25)
		p["hips_pos"] = Vector3(0.0, lerp(ground_hips_y - 0.22, ground_hips_y, s), lerp(-0.15, 0.0, s))
		p["hips_rot"] = Vector3(lerp(16.0, 4.0, s), 0.0, 0.0)
		p["torso_rot"] = Vector3(lerp(32.0, 8.0, s), 0.0, 0.0)
		p["head_rot"] = Vector3(lerp(-22.0, -4.0, s), 0.0, 0.0)
		
		p["right_arm_rot"] = _lerp_angles(Vector3(-35.0, 0.0, 18.0), base_r_arm, s)
		p["right_forearm_rot"] = _lerp_angles(Vector3(-65.0, 0.0, 0.0), base_r_fore, s)
		p["warhammer_rot"] = _lerp_angles(Vector3(75.0, 0.0, 0.0), base_hammer, s)
		
		p["left_arm_rot"] = _lerp_angles(Vector3(25.0, 0.0, -25.0), base_l_arm, s)
		p["left_forearm_rot"] = _lerp_angles(Vector3(-20.0, 0.0, 0.0), base_l_fore, s)
		
		p["left_thigh_rot"] = Vector3(lerp(-38.0, -4.0, s), 0.0, -5.0)
		p["left_shin_rot"] = Vector3(lerp(55.0, 8.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(48.0, 4.0, s), 0.0, 5.0)
		p["right_shin_rot"] = Vector3(lerp(85.0, 6.0, s), 0.0, 0.0)
	return p

# --- 7. STUNNED ---
func _compute_stunned(time_val: float) -> Dictionary:
	var p: Dictionary = {}
	var t = time_val * 2.2
	var cfg = _get_active_stance_cfg()
	var base_hammer: Vector3 = cfg.get("warhammer_rot", Vector3(65.0, 0.0, -30.0))
	var base_r_arm: Vector3 = cfg.get("right_arm_rot", Vector3(-32.0, 25.0, 35.0))
	var base_r_fore: Vector3 = cfg.get("right_forearm_rot", Vector3(-115.0, 0.0, 0.0))
	var base_l_arm: Vector3 = cfg.get("left_arm_rot", Vector3(15.0, 0.0, -15.0))
	var base_l_fore: Vector3 = cfg.get("left_forearm_rot", Vector3(-25.0, 0.0, 0.0))
	
	p["hips_pos"] = Vector3(sin(t) * 0.035, ground_hips_y - 0.04, cos(t) * 0.028)
	p["hips_rot"] = Vector3(cos(t) * 3.0, sin(t) * 8.0, -sin(t) * 4.0)
	p["torso_rot"] = Vector3(14.0 + sin(t) * 8.0, cos(t) * 14.0, sin(t) * 7.0)
	p["head_rot"] = Vector3(-10.0 + cos(t * 1.4) * 12.0, -sin(t) * 18.0, cos(t * 0.8) * 15.0)
	
	# Massive hammer dragging
	p["right_arm_rot"] = base_r_arm + Vector3(sin(t) * 8.0, 0.0, 0.0)
	p["right_forearm_rot"] = base_r_fore
	p["warhammer_rot"] = base_hammer + Vector3(15.0 + cos(t) * 4.0, 0.0, 0.0)
	
	p["left_arm_rot"] = base_l_arm + Vector3(-sin(t) * 8.0, 0.0, 0.0)
	p["left_forearm_rot"] = base_l_fore
	
	p["left_thigh_rot"] = Vector3(-16.0 + sin(t) * 5.0, 0.0, -4.0)
	p["left_shin_rot"] = Vector3(25.0 + cos(t) * 6.0, 0.0, 0.0)
	p["right_thigh_rot"] = Vector3(12.0 - sin(t) * 5.0, 0.0, 4.0)
	p["right_shin_rot"] = Vector3(20.0 - cos(t) * 6.0, 0.0, 0.0)
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
	if p.has("hips_pos"): hips.position = p["hips_pos"]
	if p.has("hips_rot"): hips.rotation_degrees = p["hips_rot"]
	if p.has("torso_rot"): torso.rotation_degrees = p["torso_rot"]
	if p.has("head_rot"): head.rotation_degrees = p["head_rot"]
	
	if p.has("left_arm_rot"): left_arm.rotation_degrees = p["left_arm_rot"]
	if p.has("left_forearm_rot"): left_forearm.rotation_degrees = p["left_forearm_rot"]
	if p.has("right_arm_rot"): right_arm.rotation_degrees = p["right_arm_rot"]
	if p.has("right_forearm_rot"): right_forearm.rotation_degrees = p["right_forearm_rot"]
	if p.has("warhammer_rot"): warhammer.rotation_degrees = p["warhammer_rot"]
	
	if p.has("left_thigh_rot"): left_thigh.rotation_degrees = p["left_thigh_rot"]
	if p.has("left_shin_rot"): left_shin.rotation_degrees = p["left_shin_rot"]
	if p.has("right_thigh_rot"): right_thigh.rotation_degrees = p["right_thigh_rot"]
	if p.has("right_shin_rot"): right_shin.rotation_degrees = p["right_shin_rot"]
