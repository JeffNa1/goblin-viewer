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
var current_anim: String = "idle" # "idle", "walk", "cleave", "roar", "earthshaker", "whirlwind", "stagger", "stunned"
var base_anim: String = "idle"
var anim_time: float = 0.0
var anim_speed: float = 1.0

# Action Timers
var action_time: float = 0.0
const CLEAVE_DURATION: float = 1.50
const ROAR_DURATION: float = 1.80
const EARTHSHAKER_DURATION: float = 2.00
const WHIRLWIND_DURATION: float = 1.90
const STAGGER_DURATION: float = 1.60

# Blending
var is_blending: bool = false
var blend_timer: float = 0.0
const BLEND_DURATION: float = 0.22
var source_pose: Dictionary = {}
var current_pose: Dictionary = {}

var ground_hips_y: float = 0.598
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
			"right_arm_rot": Vector3(-32.0, 25.0, 35.0),
			"right_forearm_rot": Vector3(-115.0, 0.0, 0.0),
			"warhammer_rot": Vector3(65.0, 0.0, -30.0),
			"left_arm_rot": Vector3(10.0, 0.0, -18.0),
			"left_forearm_rot": Vector3(-25.0, 0.0, 0.0),
			"torso_rot": Vector3(10.0, 0.0, 0.0),
			"head_rot": Vector3(-6.0, 0.0, 0.0)
		},
		"cleave": {
			"right_arm_rot": Vector3(-65.0, 0.0, -35.0),
			"right_forearm_rot": Vector3(-12.0, 0.0, 0.0),
			"warhammer_rot": Vector3(95.0, 0.0, -85.0),
			"left_arm_rot": Vector3(28.0, 0.0, -25.0),
			"left_forearm_rot": Vector3(-70.0, 0.0, 0.0),
			"torso_rot": Vector3(14.0, -75.0, -5.0),
			"head_rot": Vector3(4.0, 32.0, 0.0)
		},
		"roar": {
			"right_arm_rot": Vector3(-145.0, 10.0, 20.0),
			"right_forearm_rot": Vector3(-10.0, 0.0, 0.0),
			"warhammer_rot": Vector3(180.0, 0.0, 0.0),
			"left_arm_rot": Vector3(-110.0, -25.0, -45.0),
			"left_forearm_rot": Vector3(-35.0, 0.0, 0.0),
			"torso_rot": Vector3(-28.0, 0.0, 0.0),
			"head_rot": Vector3(-42.0, 0.0, 0.0)
		},
		"earthshaker": {
			"right_arm_rot": Vector3(-32.0, 0.0, 10.0),
			"right_forearm_rot": Vector3(-75.0, 0.0, 0.0),
			"warhammer_rot": Vector3(180.0, 0.0, 0.0),
			"left_arm_rot": Vector3(-22.0, 0.0, -20.0),
			"left_forearm_rot": Vector3(-60.0, 0.0, 0.0),
			"torso_rot": Vector3(50.0, 0.0, 0.0),
			"head_rot": Vector3(-18.0, 0.0, 0.0)
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
			"warhammer_rot": Vector3(180.0, 0.0, 0.0),
			"left_arm_rot": Vector3(28.0, 0.0, -25.0),
			"left_forearm_rot": Vector3(-20.0, 0.0, 0.0),
			"torso_rot": Vector3(35.0, 0.0, 0.0),
			"head_rot": Vector3(-18.0, 0.0, 0.0)
		},
		"stunned": {
			"right_arm_rot": Vector3(10.0, 5.0, 32.0),
			"right_forearm_rot": Vector3(-12.0, 0.0, 0.0),
			"warhammer_rot": Vector3(175.0, 0.0, -10.0),
			"left_arm_rot": Vector3(12.0, 0.0, -22.0),
			"left_forearm_rot": Vector3(-15.0, 0.0, 0.0),
			"torso_rot": Vector3(12.0, 0.0, 0.0),
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
			"warhammer_rot": Vector3(180.0, 0.0, -10.0),
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
		{"id": "cleave", "name": "Thiết Quẹt", "shortcut": "[ 3 ]"},
		{"id": "earthshaker", "name": "Địa Chấn", "shortcut": "[ 4 ]"},
		{"id": "whirlwind", "name": "Bão Chùy 360°", "shortcut": "[ 5 ]"},
		{"id": "roar", "name": "Gầm Thét", "shortcut": "[ 6 ]"},
		{"id": "stagger", "name": "Quỳ Gối", "shortcut": "[ 7 ]"},
		{"id": "stunned", "name": "Choáng", "shortcut": "[ 8 ]"},
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

func _get_base_stance_cfg() -> Dictionary:
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
	if current_anim == anim_name and current_anim not in ["cleave", "roar", "earthshaker", "stagger"]:
		return
	_start_blend()
	current_anim = anim_name
	action_time = 0.0
	
	if current_anim in ["idle", "shoulder", "ground", "guard", "walk", "whirlwind", "stunned"]:
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
	
	if current_anim == "cleave":
		action_time += dt
		if action_time >= CLEAVE_DURATION:
			current_anim = base_anim
			action_time = 0.0
			_start_blend()
			emit_signal("anim_changed", current_anim)
	elif current_anim == "roar":
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
	elif current_anim == "stagger":
		action_time += dt
		if action_time >= STAGGER_DURATION:
			current_anim = base_anim
			action_time = 0.0
			_start_blend()
			emit_signal("anim_changed", current_anim)
			
	if stun_stars:
		stun_stars.set_active(current_anim == "stunned")
		
	var cur_t = action_time if current_anim in ["cleave", "roar", "earthshaker", "stagger"] else anim_time
	var target_pose = _compute_pose(current_anim, cur_t)
	
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
		"cleave": return _compute_cleave(time_val)
		"roar": return _compute_roar(time_val)
		"earthshaker": return _compute_earthshaker(time_val)
		"whirlwind": return _compute_whirlwind(time_val)
		"stagger": return _compute_stagger(time_val)
		"stunned": return _compute_stunned(time_val)
		_: return _compute_shoulder(time_val)

# --- 1. SHOULDER (Vác Đại Búa Trên Vai) ---
func _compute_shoulder(time_val: float) -> Dictionary:
	var p: Dictionary = {}
	var t = time_val * 1.6
	var heave = sin(t)
	var sway = sin(t * 0.5)
	var cfg = stance_configs.get("shoulder", default_stance_configs.get("shoulder", {}))
	
	# Solid grounded pelvis: no vertical breathing bob on hips so feet stay 100% on ground floor
	p["hips_pos"] = Vector3(sway * 0.008, ground_hips_y, 0.0)
	p["hips_rot"] = Vector3(4.0, sway * 2.5, 0.0)
	
	# Thoracic spine breathing & predatory neck movement
	var base_torso = cfg.get("torso_rot", Vector3(6.0, 0.0, 0.0))
	var base_head = cfg.get("head_rot", Vector3(-4.0, 0.0, 0.0))
	p["torso_rot"] = base_torso + Vector3(heave * 2.5, -sway * 2.0, 0.0)
	p["head_rot"] = base_head + Vector3(-heave * 1.5, sway * 5.0, 0.0)
	
	# Arms: Right arm holding great mace on shoulder, left arm resting with tense claw twitching
	var base_r_arm = cfg.get("right_arm_rot", Vector3(-32.0, 25.0, 35.0))
	var base_r_fore = cfg.get("right_forearm_rot", Vector3(-115.0, 0.0, 0.0))
	var base_hammer = cfg.get("warhammer_rot", Vector3(65.0, 0.0, -30.0))
	var base_l_arm = cfg.get("left_arm_rot", Vector3(15.0, 0.0, -15.0))
	var base_l_fore = cfg.get("left_forearm_rot", Vector3(-25.0, 0.0, 0.0))
	
	p["right_arm_rot"] = base_r_arm + Vector3(heave * 1.8, 0.0, 0.0)
	p["right_forearm_rot"] = base_r_fore
	p["warhammer_rot"] = base_hammer + Vector3(heave * 1.2, 0.0, 0.0)
	p["left_arm_rot"] = base_l_arm + Vector3(-heave * 2.0, 0.0, 0.0)
	p["left_forearm_rot"] = base_l_fore + Vector3(-heave * 3.0, 0.0, 0.0)
	
	# Symmetrical, perfectly grounded legs: Y = 0.0mm
	p["left_thigh_rot"] = Vector3(0.0, 0.0, -6.0)
	p["left_shin_rot"] = Vector3(7.0, 0.0, 0.0)
	p["right_thigh_rot"] = Vector3(0.0, 0.0, 6.0)
	p["right_shin_rot"] = Vector3(7.0, 0.0, 0.0)
	return p

# --- 2. GROUND (Chống Đại Búa Xuống Mặt Đất) ---
func _compute_ground(time_val: float) -> Dictionary:
	var p: Dictionary = {}
	var t = time_val * 1.6
	var heave = sin(t)
	var sway = sin(t * 0.4)
	var cfg = stance_configs.get("ground", default_stance_configs.get("ground", {}))
	
	# Leaning onto planted mace: weight slightly to right (+0.02m)
	p["hips_pos"] = Vector3(0.02, ground_hips_y + 0.001, 0.0)
	p["hips_rot"] = Vector3(3.0, 4.0 + sway * 1.5, -2.0)
	
	var base_torso = cfg.get("torso_rot", Vector3(8.0, 0.0, 0.0))
	var base_head = cfg.get("head_rot", Vector3(-2.0, 0.0, 0.0))
	p["torso_rot"] = base_torso + Vector3(heave * 2.0, -2.0, 2.0)
	p["head_rot"] = base_head + Vector3(0.0, 6.0 + sway * 4.0, 0.0)
	
	var base_r_arm = cfg.get("right_arm_rot", Vector3(-15.0, 10.0, 24.0))
	var base_r_fore = cfg.get("right_forearm_rot", Vector3(-42.0, 0.0, 0.0))
	var base_hammer = cfg.get("warhammer_rot", Vector3(180.0, 0.0, -10.0))
	var base_l_arm = cfg.get("left_arm_rot", Vector3(0.0, 0.0, -18.0))
	var base_l_fore = cfg.get("left_forearm_rot", Vector3(-18.0, 0.0, 0.0))
	
	p["right_arm_rot"] = base_r_arm + Vector3(heave * 1.5, 0.0, 0.0)
	p["right_forearm_rot"] = base_r_fore
	p["warhammer_rot"] = base_hammer
	p["left_arm_rot"] = base_l_arm + Vector3(-heave * 1.5, 0.0, 0.0)
	p["left_forearm_rot"] = base_l_fore
	
	# Right leg takes 70% weight, left leg casual kickstand
	p["left_thigh_rot"] = Vector3(-4.0, 0.0, -7.5)
	p["left_shin_rot"] = Vector3(9.5, 0.0, 0.0)
	p["right_thigh_rot"] = Vector3(1.0, 0.0, 5.0)
	p["right_shin_rot"] = Vector3(6.0, 0.0, 0.0)
	return p

# --- 3. GUARD (Thủ Trọng Lực Giữ Búa Trước Thân) ---
func _compute_guard(time_val: float) -> Dictionary:
	var p: Dictionary = {}
	var t = time_val * 2.0
	var heave = sin(t)
	var cfg = stance_configs.get("guard", default_stance_configs.get("guard", {}))
	
	# Low center of gravity battle crouch
	p["hips_pos"] = Vector3(0.0, ground_hips_y + 0.008, 0.0)
	p["hips_rot"] = Vector3(8.0, 0.0, 0.0)
	
	var base_torso = cfg.get("torso_rot", Vector3(12.0, 0.0, 0.0))
	var base_head = cfg.get("head_rot", Vector3(-6.0, 0.0, 0.0))
	p["torso_rot"] = base_torso + Vector3(heave * 2.0, 0.0, 0.0)
	p["head_rot"] = base_head
	
	var base_r_arm = cfg.get("right_arm_rot", Vector3(-38.0, -10.0, 18.0))
	var base_r_fore = cfg.get("right_forearm_rot", Vector3(-75.0, 0.0, 0.0))
	var base_hammer = cfg.get("warhammer_rot", Vector3(120.0, 25.0, -45.0))
	var base_l_arm = cfg.get("left_arm_rot", Vector3(-42.0, 18.0, -15.0))
	var base_l_fore = cfg.get("left_forearm_rot", Vector3(-80.0, 0.0, 0.0))
	
	p["right_arm_rot"] = base_r_arm + Vector3(heave * 1.5, 0.0, 0.0)
	p["right_forearm_rot"] = base_r_fore
	p["warhammer_rot"] = base_hammer
	p["left_arm_rot"] = base_l_arm + Vector3(heave * 1.5, 0.0, 0.0)
	p["left_forearm_rot"] = base_l_fore
	
	# Braced wide stance
	p["left_thigh_rot"] = Vector3(-10.0, 0.0, -7.5)
	p["left_shin_rot"] = Vector3(14.5, 0.0, 0.0)
	p["right_thigh_rot"] = Vector3(8.0, 0.0, 7.5)
	p["right_shin_rot"] = Vector3(11.5, 0.0, 0.0)
	return p

# --- 4. WALK (Earth-Shaking Heavy Lumbering Stride with Colossal Weight & Dynamic Inertia) ---
func _compute_walk(time_val: float) -> Dictionary:
	var p: Dictionary = {}
	var t = time_val * 2.4 # Deliberate colossal pace (~1.3s full stride)
	var s_leg = sin(t)
	var c_leg = cos(t)
	
	# Pelvic dynamics: weight transfer lateral sway and impact bob
	var bob = -cos(2.0 * t) * 0.018
	var sway = s_leg * 0.038
	p["hips_pos"] = Vector3(sway, ground_hips_y + bob - 0.005, 0.0)
	
	# Pelvis Rotation: Pitch (10° forward lean + stomp bounce), Yaw (7° stride rotation), Roll (4° list tilt)
	p["hips_rot"] = Vector3(
		10.0 + cos(2.0 * t) * 1.5,
		s_leg * 7.0,
		-c_leg * 4.0
	)
	
	# Torso Counter-Torsion & Balance
	p["torso_rot"] = Vector3(
		12.0 - cos(2.0 * t) * 2.0,
		-s_leg * 6.0,
		c_leg * 3.0
	)
	
	# Cervical stabilization: Head tracks forward horizon with subtle aggressive bounce
	p["head_rot"] = Vector3(
		-6.0 + cos(2.0 * t) * 1.5,
		-s_leg * 3.0,
		-c_leg * 2.0
	)
	
	# Biomechanical Legs (elastic shock absorption on stance plant, high ground-clearing swing lift):
	var thigh_l = -c_leg * 20.0
	var swing_l = pow(maxf(0.0, cos(t - 1.35 * PI)), 1.8) * 34.0
	var stance_l = pow(maxf(0.0, cos(t - 0.3 * PI)), 2.0) * 8.0
	p["left_thigh_rot"] = Vector3(thigh_l, 0.0, -6.0)
	p["left_shin_rot"] = Vector3(6.5 + stance_l + swing_l, 0.0, 0.0)
	
	var t_r = t + PI
	var thigh_r = -cos(t_r) * 20.0
	var swing_r = pow(maxf(0.0, cos(t_r - 1.35 * PI)), 1.8) * 34.0
	var stance_r = pow(maxf(0.0, cos(t_r - 0.3 * PI)), 2.0) * 8.0
	p["right_thigh_rot"] = Vector3(thigh_r, 0.0, 6.0)
	p["right_shin_rot"] = Vector3(6.5 + stance_r + swing_r, 0.0, 0.0)
	
	# Upper body & Weapon Inertia (Carrying Great Mace hoisted proudly on right shoulder):
	var cfg = stance_configs.get("walk", default_stance_configs.get("walk", {}))
	var base_hammer = cfg.get("warhammer_rot", Vector3(65.0, 0.0, -30.0))
	var base_r_arm = cfg.get("right_arm_rot", Vector3(-32.0, 25.0, 35.0))
	var base_r_fore = cfg.get("right_forearm_rot", Vector3(-115.0, 0.0, 0.0))
	var base_l_arm = cfg.get("left_arm_rot", Vector3(10.0, 0.0, -18.0))
	var base_l_fore = cfg.get("left_forearm_rot", Vector3(-25.0, 0.0, 0.0))
	
	# Great mace shoulder heave lag and bicep flex
	var hammer_heave = cos(2.0 * t) * 3.5
	var arm_r_swing = cos(t) * 3.5
	var elbow_r_cushion = -cos(2.0 * t) * 4.0
	var hammer_inertia = Vector3(cos(2.0 * t) * 4.0, -s_leg * 2.5, c_leg * 2.0)
	p["right_arm_rot"] = base_r_arm + Vector3(arm_r_swing + hammer_heave, -s_leg * 2.0, c_leg * 2.0)
	p["right_forearm_rot"] = base_r_fore + Vector3(elbow_r_cushion, 0.0, 0.0)
	p["warhammer_rot"] = base_hammer + hammer_inertia
	
	# Left arm natural predatory counter-swing with rhythmic forearm flexing
	var arm_l_swing = -s_leg * 26.0
	var elbow_l_flex = -s_leg * 18.0
	p["left_arm_rot"] = base_l_arm + Vector3(arm_l_swing, -s_leg * 6.0, -c_leg * 4.0)
	p["left_forearm_rot"] = base_l_fore + Vector3(elbow_l_flex, 0.0, 0.0)
	return p

# --- 5. CLEAVE (Thiết Quẹt - Massive Horizontal Sweeping Arc) ---
func _compute_cleave(t_c: float) -> Dictionary:
	var p: Dictionary = {}
	var tau = clampf(t_c / CLEAVE_DURATION, 0.0, 1.0)
	var base_cfg = _get_base_stance_cfg()
	var base_hammer = base_cfg.get("warhammer_rot", Vector3(65.0, 0.0, -30.0))
	var base_r_arm = base_cfg.get("right_arm_rot", Vector3(-32.0, 25.0, 35.0))
	var base_r_fore = base_cfg.get("right_forearm_rot", Vector3(-115.0, 0.0, 0.0))
	var base_l_arm = base_cfg.get("left_arm_rot", Vector3(15.0, 0.0, -15.0))
	var base_l_fore = base_cfg.get("left_forearm_rot", Vector3(-25.0, 0.0, 0.0))
	
	if tau < 0.32:
		# PHASE 1: Windup & Deep Beastly Coil to Right
		var s = smoothstep(0.0, 1.0, tau / 0.32)
		p["hips_pos"] = Vector3(0.0, ground_hips_y + 0.004 * s, 0.04 * s)
		p["hips_rot"] = Vector3(lerp(4.0, 2.0, s), lerp(0.0, 36.0, s), 0.0)
		p["torso_rot"] = Vector3(lerp(6.0, 12.0, s), lerp(0.0, 58.0, s), lerp(0.0, 4.0, s))
		p["head_rot"] = Vector3(lerp(-4.0, 0.0, s), lerp(0.0, -38.0, s), 0.0)
		
		# Coiling right arm & drawing great mace back behind right flank
		p["right_arm_rot"] = _lerp_angles(base_r_arm, Vector3(18.0, 15.0, 72.0), s)
		p["right_forearm_rot"] = _lerp_angles(base_r_fore, Vector3(-38.0, 0.0, 15.0), s)
		p["warhammer_rot"] = _lerp_angles(base_hammer, Vector3(75.0, 25.0, 30.0), s)
		
		# Left arm reaches across to aim & balance
		p["left_arm_rot"] = _lerp_angles(base_l_arm, Vector3(-35.0, -10.0, -18.0), s)
		p["left_forearm_rot"] = _lerp_angles(base_l_fore, Vector3(-65.0, 0.0, 0.0), s)
		
		# Legs coil into loaded crouch stance
		p["left_thigh_rot"] = Vector3(lerp(0.0, -12.0, s), 0.0, -6.5)
		p["left_shin_rot"] = Vector3(lerp(7.0, 18.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(0.0, 16.0, s), 0.0, 6.5)
		p["right_shin_rot"] = Vector3(lerp(7.0, 20.0, s), 0.0, 0.0)
		
	elif tau < 0.58:
		# PHASE 2: Devastating Wide Horizontal Cleave Sweep (140°+ Arc)
		var prog = (tau - 0.32) / 0.26
		var s = 1.0 - pow(1.0 - prog, 2.8)
		
		p["hips_pos"] = Vector3(0.0, ground_hips_y + lerp(0.004, 0.006, s), lerp(0.04, 0.12, s))
		p["hips_rot"] = Vector3(lerp(2.0, 4.0, s), lerp(36.0, -42.0, s), 0.0)
		p["torso_rot"] = Vector3(lerp(12.0, 16.0, s), lerp(58.0, -75.0, s), lerp(4.0, -6.0, s))
		p["head_rot"] = Vector3(lerp(0.0, 4.0, s), lerp(-38.0, 32.0, s), 0.0)
		
		# Arm extends outward and sweeps across with immense kinetic reach
		p["right_arm_rot"] = Vector3(lerp(18.0, -65.0, s), lerp(15.0, -8.0, s), lerp(72.0, -35.0, s))
		p["right_forearm_rot"] = Vector3(lerp(-38.0, -12.0, s), 0.0, lerp(15.0, 0.0, s))
		p["warhammer_rot"] = Vector3(lerp(75.0, 95.0, s), lerp(25.0, 0.0, s), lerp(30.0, -85.0, s))
		
		# Left arm swings back to counterbalance titanic inertia
		p["left_arm_rot"] = Vector3(lerp(-35.0, 28.0, s), 0.0, lerp(-18.0, -28.0, s))
		p["left_forearm_rot"] = Vector3(lerp(-65.0, -75.0, s), 0.0, 0.0)
		
		# Front leg braces, rear leg drives
		p["left_thigh_rot"] = Vector3(lerp(-12.0, 10.0, s), 0.0, -6.5)
		p["left_shin_rot"] = Vector3(lerp(18.0, 14.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(16.0, -16.0, s), 0.0, 6.5)
		p["right_shin_rot"] = Vector3(lerp(20.0, 32.0, s), 0.0, 0.0)
		
	elif tau < 0.74:
		# PHASE 3: Heavy Inertial Drag & Kinetic Overshoot
		var prog = (tau - 0.58) / 0.16
		var s = sin(prog * 0.5 * PI)
		
		p["hips_pos"] = Vector3(0.0, ground_hips_y + 0.006, lerp(0.12, 0.14, s))
		p["hips_rot"] = Vector3(4.0, lerp(-42.0, -48.0, s), 0.0)
		p["torso_rot"] = Vector3(lerp(16.0, 14.0, s), lerp(-75.0, -83.0, s), lerp(-6.0, -8.0, s))
		p["head_rot"] = Vector3(4.0, lerp(32.0, 36.0, s), 0.0)
		
		p["right_arm_rot"] = Vector3(lerp(-65.0, -68.0, s), -8.0, lerp(-35.0, -42.0, s))
		p["right_forearm_rot"] = Vector3(lerp(-12.0, -16.0, s), 0.0, 0.0)
		p["warhammer_rot"] = Vector3(lerp(95.0, 98.0, s), 0.0, lerp(-85.0, -92.0, s))
		
		p["left_arm_rot"] = Vector3(lerp(28.0, 32.0, s), 0.0, -28.0)
		p["left_forearm_rot"] = Vector3(-75.0, 0.0, 0.0)
		
		p["left_thigh_rot"] = Vector3(10.0, 0.0, -6.5)
		p["left_shin_rot"] = Vector3(14.0, 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(-16.0, 0.0, 6.5)
		p["right_shin_rot"] = Vector3(32.0, 0.0, 0.0)
		
	else:
		# PHASE 4: Muscular Heave & Fluid Recovery to Base Stance
		var prog = (tau - 0.74) / 0.26
		var s = smoothstep(0.0, 1.0, prog)
		
		p["hips_pos"] = Vector3(0.0, ground_hips_y, lerp(0.14, 0.0, s))
		p["hips_rot"] = Vector3(4.0, lerp(-48.0, 0.0, s), 0.0)
		p["torso_rot"] = Vector3(lerp(14.0, 6.0, s), lerp(-83.0, 0.0, s), lerp(-8.0, 0.0, s))
		p["head_rot"] = Vector3(lerp(4.0, -4.0, s), lerp(36.0, 0.0, s), 0.0)
		
		p["right_arm_rot"] = _lerp_angles(Vector3(-68.0, -8.0, -42.0), base_r_arm, s)
		p["right_forearm_rot"] = _lerp_angles(Vector3(-16.0, 0.0, 0.0), base_r_fore, s)
		p["warhammer_rot"] = _lerp_angles(Vector3(98.0, 0.0, -92.0), base_hammer, s)
		p["left_arm_rot"] = _lerp_angles(Vector3(32.0, 0.0, -28.0), base_l_arm, s)
		p["left_forearm_rot"] = _lerp_angles(Vector3(-75.0, 0.0, 0.0), base_l_fore, s)
		
		p["left_thigh_rot"] = Vector3(lerp(10.0, 0.0, s), 0.0, -6.0)
		p["left_shin_rot"] = Vector3(lerp(14.0, 7.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(-16.0, 0.0, s), 0.0, 6.0)
		p["right_shin_rot"] = Vector3(lerp(32.0, 7.0, s), 0.0, 0.0)
	return p

# --- 6. WAR ROAR (Pound Chest, Skyward Roar with Hammer Aloft) ---
func _compute_roar(t_r: float) -> Dictionary:
	var p: Dictionary = {}
	var tau = clampf(t_r / ROAR_DURATION, 0.0, 1.0)
	var base_cfg = _get_base_stance_cfg()
	var base_hammer = base_cfg.get("warhammer_rot", Vector3(65.0, 0.0, -30.0))
	var base_r_arm = base_cfg.get("right_arm_rot", Vector3(-32.0, 25.0, 35.0))
	var base_r_fore = base_cfg.get("right_forearm_rot", Vector3(-115.0, 0.0, 0.0))
	var base_l_arm = base_cfg.get("left_arm_rot", Vector3(15.0, 0.0, -15.0))
	var base_l_fore = base_cfg.get("left_forearm_rot", Vector3(-25.0, 0.0, 0.0))
	
	if tau < 0.22:
		# Windup & deep inhale
		var s = smoothstep(0.0, 1.0, tau / 0.22)
		p["hips_pos"] = Vector3(0.0, ground_hips_y + 0.006 * s, 0.0)
		p["hips_rot"] = Vector3(lerp(4.0, 12.0, s), 0.0, 0.0)
		p["torso_rot"] = Vector3(lerp(6.0, 18.0, s), 0.0, 0.0)
		p["head_rot"] = Vector3(lerp(-4.0, -14.0, s), 0.0, 0.0)
		p["left_arm_rot"] = _lerp_angles(base_l_arm, Vector3(20.0, 35.0, 10.0), s)
		p["left_forearm_rot"] = _lerp_angles(base_l_fore, Vector3(-70.0, 0.0, 0.0), s)
		p["right_arm_rot"] = _lerp_angles(base_r_arm, Vector3(-45.0, 10.0, 35.0), s)
		p["right_forearm_rot"] = _lerp_angles(base_r_fore, Vector3(-75.0, 0.0, 0.0), s)
		p["warhammer_rot"] = _lerp_angles(base_hammer, Vector3(85.0, 0.0, -10.0), s)
		p["left_thigh_rot"] = Vector3(lerp(0.0, -8.0, s), 0.0, -6.5)
		p["left_shin_rot"] = Vector3(lerp(7.0, 14.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(0.0, 6.0, s), 0.0, 6.5)
		p["right_shin_rot"] = Vector3(lerp(7.0, 12.0, s), 0.0, 0.0)
		
	elif tau < 0.38:
		# Brutal chest pound impact! Fist strikes pectoral surface cleanly with ZERO chest clipping
		var s = (tau - 0.22) / 0.16
		var impact = sin(s * PI)
		p["hips_pos"] = Vector3(0.0, ground_hips_y + 0.006, 0.0)
		p["hips_rot"] = Vector3(12.0 - impact * 3.0, 0.0, 0.0)
		p["torso_rot"] = Vector3(18.0 - impact * 6.0, 0.0, 0.0)
		p["head_rot"] = Vector3(-14.0 + impact * 5.0, 0.0, 0.0)
		
		# Left arm: Shoulder -35° / Forearm -78° places fist flush on outer pectoral plate without penetrating body
		p["left_arm_rot"] = Vector3(-35.0, 18.0, 10.0)
		p["left_forearm_rot"] = Vector3(-78.0, 0.0, 0.0)
		
		# Right arm: Holds great mace firmly away from flank
		p["right_arm_rot"] = Vector3(-35.0, 15.0, 38.0)
		p["right_forearm_rot"] = Vector3(-70.0, 0.0, 0.0)
		p["warhammer_rot"] = Vector3(85.0, 0.0, -10.0)
		
		p["left_thigh_rot"] = Vector3(-8.0, 0.0, -6.5)
		p["left_shin_rot"] = Vector3(14.0, 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(6.0, 0.0, 6.5)
		p["right_shin_rot"] = Vector3(12.0, 0.0, 0.0)
		
	elif tau < 0.80:
		# TITANIC SKYWARD BELLOW with hammer aloft & body tremor
		var s = smoothstep(0.0, 1.0, (tau - 0.38) / 0.15)
		var shake = sin(t_r * 65.0) * 1.6
		p["hips_pos"] = Vector3(0.0, ground_hips_y, 0.0)
		p["hips_rot"] = Vector3(lerp(12.0, -4.0, s), 0.0, 0.0)
		p["torso_rot"] = Vector3(lerp(18.0, -28.0, s) + shake, 0.0, 0.0)
		p["head_rot"] = Vector3(lerp(-14.0, -42.0, s) + shake * 0.8, 0.0, 0.0)
		
		# Warhammer thrust straight into the heavens
		p["right_arm_rot"] = Vector3(lerp(-35.0, -145.0, s) + shake, 10.0, 22.0)
		p["right_forearm_rot"] = Vector3(lerp(-70.0, -10.0, s), 0.0, 0.0)
		p["warhammer_rot"] = Vector3(lerp(85.0, 180.0, s), 0.0, 0.0)
		
		# Left arm wide beastly splay
		p["left_arm_rot"] = Vector3(lerp(-35.0, -115.0, s) + shake, -20.0, -50.0)
		p["left_forearm_rot"] = Vector3(lerp(-78.0, -35.0, s), 0.0, 0.0)
		
		p["left_thigh_rot"] = Vector3(lerp(-8.0, 0.0, s), 0.0, -6.0)
		p["left_shin_rot"] = Vector3(lerp(14.0, 7.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(6.0, 0.0, s), 0.0, 6.0)
		p["right_shin_rot"] = Vector3(lerp(12.0, 7.0, s), 0.0, 0.0)
		
	else:
		# Smooth recovery to base stance (Zero Pop)
		var s = smoothstep(0.0, 1.0, (tau - 0.80) / 0.20)
		p["hips_pos"] = Vector3(0.0, ground_hips_y, 0.0)
		p["hips_rot"] = Vector3(lerp(-4.0, 4.0, s), 0.0, 0.0)
		p["torso_rot"] = Vector3(lerp(-28.0, 6.0, s), 0.0, 0.0)
		p["head_rot"] = Vector3(lerp(-42.0, -4.0, s), 0.0, 0.0)
		p["right_arm_rot"] = _lerp_angles(Vector3(-145.0, 10.0, 22.0), base_r_arm, s)
		p["right_forearm_rot"] = _lerp_angles(Vector3(-10.0, 0.0, 0.0), base_r_fore, s)
		p["warhammer_rot"] = _lerp_angles(Vector3(180.0, 0.0, 0.0), base_hammer, s)
		p["left_arm_rot"] = _lerp_angles(Vector3(-115.0, -20.0, -50.0), base_l_arm, s)
		p["left_forearm_rot"] = _lerp_angles(Vector3(-35.0, 0.0, 0.0), base_l_fore, s)
		p["left_thigh_rot"] = Vector3(0.0, 0.0, -6.0)
		p["left_shin_rot"] = Vector3(7.0, 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(0.0, 0.0, 6.0)
		p["right_shin_rot"] = Vector3(7.0, 0.0, 0.0)
	return p

# --- 7. EARTHSHAKER SLAM (High Leap, Titanic 2-Handed Ground Smash) ---
func _compute_earthshaker(t_e: float) -> Dictionary:
	var p: Dictionary = {}
	var tau = clampf(t_e / EARTHSHAKER_DURATION, 0.0, 1.0)
	var base_cfg = _get_base_stance_cfg()
	var base_hammer = base_cfg.get("warhammer_rot", Vector3(65.0, 0.0, -30.0))
	var base_r_arm = base_cfg.get("right_arm_rot", Vector3(-32.0, 25.0, 35.0))
	var base_r_fore = base_cfg.get("right_forearm_rot", Vector3(-115.0, 0.0, 0.0))
	var base_l_arm = base_cfg.get("left_arm_rot", Vector3(15.0, 0.0, -15.0))
	var base_l_fore = base_cfg.get("left_forearm_rot", Vector3(-25.0, 0.0, 0.0))
	
	if tau < 0.17:
		# Deep crouch compression
		var s = smoothstep(0.0, 1.0, tau / 0.17)
		p["hips_pos"] = Vector3(0.0, ground_hips_y + s * 0.010, 0.0)
		p["hips_rot"] = Vector3(lerp(4.0, 14.0, s), 0.0, 0.0)
		p["torso_rot"] = Vector3(lerp(6.0, 24.0, s), 0.0, 0.0)
		p["head_rot"] = Vector3(lerp(-4.0, -12.0, s), 0.0, 0.0)
		p["right_arm_rot"] = _lerp_angles(base_r_arm, Vector3(-65.0, 10.0, 15.0), s)
		p["right_forearm_rot"] = _lerp_angles(base_r_fore, Vector3(-50.0, 0.0, 0.0), s)
		p["warhammer_rot"] = _lerp_angles(base_hammer, Vector3(90.0, 0.0, 0.0), s)
		p["left_arm_rot"] = _lerp_angles(base_l_arm, Vector3(-55.0, -10.0, -15.0), s)
		p["left_forearm_rot"] = _lerp_angles(base_l_fore, Vector3(-50.0, 0.0, 0.0), s)
		p["left_thigh_rot"] = Vector3(lerp(0.0, -12.0, s), 0.0, -7.5)
		p["left_shin_rot"] = Vector3(lerp(7.0, 18.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(0.0, 10.0, s), 0.0, 7.5)
		p["right_shin_rot"] = Vector3(lerp(7.0, 16.0, s), 0.0, 0.0)
		
	elif tau < 0.42:
		# TITANIC AIRBORNE LEAP
		var s = (tau - 0.17) / 0.25
		var y_arc = sin(s * PI) * 0.35
		var z_adv = s * 0.25
		p["hips_pos"] = Vector3(0.0, ground_hips_y + y_arc, z_adv)
		p["hips_rot"] = Vector3(lerp(14.0, -18.0, s), 0.0, 0.0)
		p["torso_rot"] = Vector3(lerp(24.0, -36.0, s), 0.0, 0.0)
		p["head_rot"] = Vector3(lerp(-12.0, 16.0, s), 0.0, 0.0)
		
		# Both hands grip hammer high overhead
		p["right_arm_rot"] = Vector3(lerp(-65.0, -155.0, s), 5.0, 15.0)
		p["right_forearm_rot"] = Vector3(lerp(-50.0, -25.0, s), 0.0, 0.0)
		p["warhammer_rot"] = Vector3(lerp(90.0, 175.0, s), 0.0, 0.0)
		p["left_arm_rot"] = Vector3(lerp(-55.0, -145.0, s), -5.0, -15.0)
		p["left_forearm_rot"] = Vector3(lerp(-50.0, -35.0, s), 0.0, 0.0)
		
		p["left_thigh_rot"] = Vector3(lerp(-12.0, -26.0, s), 0.0, -6.5)
		p["left_shin_rot"] = Vector3(lerp(18.0, 40.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(10.0, -12.0, s), 0.0, 6.5)
		p["right_shin_rot"] = Vector3(lerp(16.0, 36.0, s), 0.0, 0.0)
		
	elif tau < 0.50:
		# CATACLYSMIC GRAVITY SMASH
		var s = smoothstep(0.0, 1.0, (tau - 0.42) / 0.08)
		p["hips_pos"] = Vector3(0.0, lerp(ground_hips_y + 0.12, ground_hips_y + 0.015, s), 0.25)
		p["hips_rot"] = Vector3(lerp(-18.0, 24.0, s), 0.0, 0.0)
		p["torso_rot"] = Vector3(lerp(-36.0, 50.0, s), 0.0, 0.0)
		p["head_rot"] = Vector3(lerp(16.0, -18.0, s), 0.0, 0.0)
		
		# Hammer slammed into earth
		p["right_arm_rot"] = Vector3(lerp(-155.0, -32.0, s), 0.0, 10.0)
		p["right_forearm_rot"] = Vector3(lerp(-25.0, -75.0, s), 0.0, 0.0)
		p["warhammer_rot"] = Vector3(lerp(175.0, 180.0, s), 0.0, 0.0)
		p["left_arm_rot"] = Vector3(lerp(-145.0, -22.0, s), 0.0, -20.0)
		p["left_forearm_rot"] = Vector3(-60.0, 0.0, 0.0)
		
		p["left_thigh_rot"] = Vector3(lerp(-26.0, -18.0, s), 0.0, -8.5)
		p["left_shin_rot"] = Vector3(lerp(40.0, 25.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(-12.0, 14.0, s), 0.0, 8.5)
		p["right_shin_rot"] = Vector3(lerp(36.0, 20.0, s), 0.0, 0.0)
		
	elif tau < 0.70:
		# CRATER FREEZE & HIT-STOP SHOCKWAVE TREMOR (Smooth exponential decay to avoid twitches)
		var decay = 1.0 - smoothstep(0.48, 0.70, tau)
		var shake = sin(t_e * 60.0) * (0.8 * decay)
		p["hips_pos"] = Vector3(0.0, ground_hips_y + 0.015, 0.25)
		p["hips_rot"] = Vector3(24.0, 0.0, 0.0)
		p["torso_rot"] = Vector3(50.0 + shake, 0.0, 0.0)
		p["head_rot"] = Vector3(-18.0 + shake * 0.5, 0.0, 0.0)
		
		p["right_arm_rot"] = Vector3(-32.0 + shake * 0.7, 0.0, 10.0)
		p["right_forearm_rot"] = Vector3(-75.0, 0.0, 0.0)
		p["warhammer_rot"] = Vector3(180.0, 0.0, 0.0)
		p["left_arm_rot"] = Vector3(-22.0 + shake * 0.7, 0.0, -20.0)
		p["left_forearm_rot"] = Vector3(-60.0, 0.0, 0.0)
		
		p["left_thigh_rot"] = Vector3(-18.0, 0.0, -8.5)
		p["left_shin_rot"] = Vector3(25.0, 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(14.0, 0.0, 8.5)
		p["right_shin_rot"] = Vector3(20.0, 0.0, 0.0)
		
	else:
		# PULL HAMMER OUT OF GROUND & RECOVER TO BASE STANCE (Zero hitch, smooth return)
		var s = smoothstep(0.0, 1.0, (tau - 0.70) / 0.30)
		p["hips_pos"] = Vector3(0.0, lerp(ground_hips_y + 0.015, ground_hips_y, s), lerp(0.25, 0.0, s))
		p["hips_rot"] = Vector3(lerp(24.0, 4.0, s), 0.0, 0.0)
		p["torso_rot"] = Vector3(lerp(50.0, 6.0, s), 0.0, 0.0)
		p["head_rot"] = Vector3(lerp(-18.0, -4.0, s), 0.0, 0.0)
		p["right_arm_rot"] = _lerp_angles(Vector3(-32.0, 0.0, 10.0), base_r_arm, s)
		p["right_forearm_rot"] = _lerp_angles(Vector3(-75.0, 0.0, 0.0), base_r_fore, s)
		p["warhammer_rot"] = _lerp_angles(Vector3(180.0, 0.0, 0.0), base_hammer, s)
		p["left_arm_rot"] = _lerp_angles(Vector3(-22.0, 0.0, -20.0), base_l_arm, s)
		p["left_forearm_rot"] = _lerp_angles(Vector3(-60.0, 0.0, 0.0), base_l_fore, s)
		p["left_thigh_rot"] = Vector3(lerp(-18.0, 0.0, s), 0.0, -6.0)
		p["left_shin_rot"] = Vector3(lerp(25.0, 7.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(14.0, 0.0, s), 0.0, 6.0)
		p["right_shin_rot"] = Vector3(lerp(20.0, 7.0, s), 0.0, 0.0)
	return p

# --- 8. WHIRLWIND 360° (Continuous Centrifugal Spin Hammer Tornado) ---
func _compute_whirlwind(time_val: float) -> Dictionary:
	var p: Dictionary = {}
	# Continuous 520 deg/sec rotational velocity (0.69s per 360° turn)
	var spin_angle = wrapf(time_val * 520.0, -180.0, 180.0)
	var step_phase = time_val * 16.0
	var foot_bob = abs(sin(step_phase)) * 0.003
	
	p["hips_pos"] = Vector3(0.0, ground_hips_y + 0.004 + foot_bob, 0.0)
	p["hips_rot"] = Vector3(8.0, spin_angle, 0.0)
	p["torso_rot"] = Vector3(14.0, 0.0, 0.0)
	p["head_rot"] = Vector3(-6.0, 0.0, 0.0)
	
	# Centrifugal extension: arms pulled out wide by immense rotational momentum
	p["right_arm_rot"] = Vector3(-8.0, 0.0, 82.0)
	p["right_forearm_rot"] = Vector3(-10.0, 0.0, 0.0)
	p["warhammer_rot"] = Vector3(90.0, 0.0, 0.0)
	p["left_arm_rot"] = Vector3(-8.0, 0.0, -82.0)
	p["left_forearm_rot"] = Vector3(-10.0, 0.0, 0.0)
	
	# Rapid rhythmic stepping feet grounded on floor (zero float)
	var step_leg = sin(step_phase) * 12.0
	p["left_thigh_rot"] = Vector3(step_leg, 0.0, -6.5)
	p["left_shin_rot"] = Vector3(12.0, 0.0, 0.0)
	p["right_thigh_rot"] = Vector3(-step_leg, 0.0, 6.5)
	p["right_shin_rot"] = Vector3(12.0, 0.0, 0.0)
	return p

# --- 9. STAGGER / POISE BREAK (Heavy Recoil & Ground Brace) ---
func _compute_stagger(t_s: float) -> Dictionary:
	var p: Dictionary = {}
	var tau = clampf(t_s / STAGGER_DURATION, 0.0, 1.0)
	var base_cfg = _get_base_stance_cfg()
	var base_hammer = base_cfg.get("warhammer_rot", Vector3(65.0, 0.0, -30.0))
	var base_r_arm = base_cfg.get("right_arm_rot", Vector3(-32.0, 25.0, 35.0))
	var base_r_fore = base_cfg.get("right_forearm_rot", Vector3(-115.0, 0.0, 0.0))
	var base_l_arm = base_cfg.get("left_arm_rot", Vector3(15.0, 0.0, -15.0))
	var base_l_fore = base_cfg.get("left_forearm_rot", Vector3(-25.0, 0.0, 0.0))
	
	if tau < 0.20:
		# Crushing impact recoil back
		var s = smoothstep(0.0, 1.0, tau / 0.20)
		p["hips_pos"] = Vector3(0.0, ground_hips_y, -s * 0.08)
		p["hips_rot"] = Vector3(lerp(4.0, -14.0, s), 0.0, 0.0)
		p["torso_rot"] = Vector3(lerp(6.0, -26.0, s), 0.0, 0.0)
		p["head_rot"] = Vector3(lerp(-4.0, -28.0, s), 0.0, 0.0)
		p["right_arm_rot"] = _lerp_angles(base_r_arm, Vector3(-20.0, 10.0, 25.0), s)
		p["right_forearm_rot"] = _lerp_angles(base_r_fore, Vector3(-45.0, 0.0, 0.0), s)
		p["warhammer_rot"] = _lerp_angles(base_hammer, Vector3(45.0, 0.0, 0.0), s)
		p["left_arm_rot"] = _lerp_angles(base_l_arm, Vector3(35.0, 0.0, -35.0), s)
		p["left_forearm_rot"] = _lerp_angles(base_l_fore, Vector3(-15.0, 0.0, 0.0), s)
		p["left_thigh_rot"] = Vector3(lerp(0.0, 8.0, s), 0.0, -7.0)
		p["left_shin_rot"] = Vector3(lerp(7.0, 10.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(0.0, 12.0, s), 0.0, 7.0)
		p["right_shin_rot"] = Vector3(lerp(7.0, 10.0, s), 0.0, 0.0)
		
	elif tau < 0.45:
		# Deep exhausted crouch & ground brace
		var s = smoothstep(0.0, 1.0, (tau - 0.20) / 0.25)
		p["hips_pos"] = Vector3(0.0, ground_hips_y + 0.008, lerp(-0.08, -0.10, s))
		p["hips_rot"] = Vector3(lerp(-14.0, 14.0, s), 0.0, 0.0)
		p["torso_rot"] = Vector3(lerp(-26.0, 35.0, s), 0.0, 0.0)
		p["head_rot"] = Vector3(lerp(-28.0, -18.0, s), 0.0, 0.0)
		
		# Hammer planted like crutch, left hand braces on dirt
		p["right_arm_rot"] = Vector3(-35.0, 0.0, 18.0)
		p["right_forearm_rot"] = Vector3(-65.0, 0.0, 0.0)
		p["warhammer_rot"] = Vector3(180.0, 0.0, 0.0)
		p["left_arm_rot"] = Vector3(28.0, 0.0, -25.0)
		p["left_forearm_rot"] = Vector3(-20.0, 0.0, 0.0)
		
		p["left_thigh_rot"] = Vector3(lerp(8.0, -10.0, s), 0.0, -8.0)
		p["left_shin_rot"] = Vector3(lerp(10.0, 18.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(12.0, 14.0, s), 0.0, 8.0)
		p["right_shin_rot"] = Vector3(lerp(10.0, 15.0, s), 0.0, 0.0)
		
	elif tau < 0.75:
		# Panting heavily & glaring
		var pant = sin(t_s * 14.0) * 0.015
		p["hips_pos"] = Vector3(0.0, ground_hips_y + 0.008 + pant, -0.10)
		p["hips_rot"] = Vector3(14.0, 0.0, 0.0)
		p["torso_rot"] = Vector3(35.0 + pant * 80.0, 0.0, 0.0)
		p["head_rot"] = Vector3(-18.0, 0.0, 0.0)
		p["right_arm_rot"] = Vector3(-35.0, 0.0, 18.0)
		p["right_forearm_rot"] = Vector3(-65.0, 0.0, 0.0)
		p["warhammer_rot"] = Vector3(180.0, 0.0, 0.0)
		p["left_arm_rot"] = Vector3(28.0, 0.0, -25.0)
		p["left_forearm_rot"] = Vector3(-20.0, 0.0, 0.0)
		p["left_thigh_rot"] = Vector3(-10.0, 0.0, -8.0)
		p["left_shin_rot"] = Vector3(18.0, 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(14.0, 0.0, 8.0)
		p["right_shin_rot"] = Vector3(15.0, 0.0, 0.0)
		
	else:
		# Furious push-off and recovery to base stance
		var s = smoothstep(0.0, 1.0, (tau - 0.75) / 0.25)
		p["hips_pos"] = Vector3(0.0, ground_hips_y, lerp(-0.10, 0.0, s))
		p["hips_rot"] = Vector3(lerp(14.0, 4.0, s), 0.0, 0.0)
		p["torso_rot"] = Vector3(lerp(35.0, 6.0, s), 0.0, 0.0)
		p["head_rot"] = Vector3(lerp(-18.0, -4.0, s), 0.0, 0.0)
		p["right_arm_rot"] = _lerp_angles(Vector3(-35.0, 0.0, 18.0), base_r_arm, s)
		p["right_forearm_rot"] = _lerp_angles(Vector3(-65.0, 0.0, 0.0), base_r_fore, s)
		p["warhammer_rot"] = _lerp_angles(Vector3(180.0, 0.0, 0.0), base_hammer, s)
		p["left_arm_rot"] = _lerp_angles(Vector3(28.0, 0.0, -25.0), base_l_arm, s)
		p["left_forearm_rot"] = _lerp_angles(Vector3(-20.0, 0.0, 0.0), base_l_fore, s)
		p["left_thigh_rot"] = Vector3(lerp(-10.0, 0.0, s), 0.0, -6.0)
		p["left_shin_rot"] = Vector3(lerp(18.0, 7.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(14.0, 0.0, s), 0.0, 6.0)
		p["right_shin_rot"] = Vector3(lerp(15.0, 7.0, s), 0.0, 0.0)
	return p

# --- 10. STUNNED (Woozy Dazed Sway, Mace Hanging Low Away From Face) ---
func _compute_stunned(time_val: float) -> Dictionary:
	var p: Dictionary = {}
	var t = time_val * 1.8
	
	# Woozy drunken figure-8 sway
	var sway_x = sin(t) * 0.025
	var sway_z = cos(t * 0.5) * 0.020
	p["hips_pos"] = Vector3(sway_x, ground_hips_y + 0.005, sway_z)
	p["hips_rot"] = Vector3(cos(t) * 3.0, sin(t * 0.7) * 7.0, -sin(t) * 3.5)
	p["torso_rot"] = Vector3(12.0 + sin(t) * 6.0, cos(t * 0.7) * 10.0, sin(t) * 5.0)
	p["head_rot"] = Vector3(-8.0 + cos(t * 1.2) * 14.0, -sin(t) * 16.0, cos(t * 0.8) * 12.0)
	
	# Limp dragging hammer: right arm hangs limp, stone head inverted hanging low next to knee (>0.9m from face)
	p["right_arm_rot"] = Vector3(10.0 + sin(t) * 4.0, 5.0, 32.0)
	p["right_forearm_rot"] = Vector3(-12.0, 0.0, 0.0)
	p["warhammer_rot"] = Vector3(175.0 + cos(t) * 4.0, 0.0, -10.0)
	p["left_arm_rot"] = Vector3(12.0 - sin(t) * 5.0, 0.0, -22.0)
	p["left_forearm_rot"] = Vector3(-15.0, 0.0, 0.0)
	
	# Wobbling knees
	p["left_thigh_rot"] = Vector3(-4.0 + sin(t) * 3.0, 0.0, -6.0)
	p["left_shin_rot"] = Vector3(11.0 + cos(t) * 3.0, 0.0, 0.0)
	p["right_thigh_rot"] = Vector3(3.0 - sin(t) * 3.0, 0.0, 6.0)
	p["right_shin_rot"] = Vector3(9.0 - cos(t) * 3.0, 0.0, 0.0)
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
