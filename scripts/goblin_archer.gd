class_name GoblinArcher
extends Node3D

# Skeleton Hierarchy Nodes
@onready var hips: Node3D = $VisualRoot/Hips
@onready var torso: Node3D = $VisualRoot/Hips/Torso
@onready var head: Node3D = $VisualRoot/Hips/Torso/Head
@onready var left_arm: Node3D = $VisualRoot/Hips/Torso/LeftArm
@onready var left_forearm: Node3D = $VisualRoot/Hips/Torso/LeftArm/LeftForearm
@onready var bow: Node3D = $VisualRoot/Hips/Torso/LeftArm/LeftForearm/Bow
@onready var bow_mesh: MeshInstance3D = $VisualRoot/Hips/Torso/LeftArm/LeftForearm/Bow/BowMesh
@onready var arrow: Node3D = $VisualRoot/Hips/Torso/LeftArm/LeftForearm/Bow/Arrow
@onready var arrow_mesh: MeshInstance3D = $VisualRoot/Hips/Torso/LeftArm/LeftForearm/Bow/Arrow/ArrowMesh
@onready var right_arm: Node3D = $VisualRoot/Hips/Torso/RightArm
@onready var right_forearm: Node3D = $VisualRoot/Hips/Torso/RightArm/RightForearm
@onready var left_thigh: Node3D = $VisualRoot/Hips/LeftThigh
@onready var left_shin: Node3D = $VisualRoot/Hips/LeftThigh/LeftShin
@onready var right_thigh: Node3D = $VisualRoot/Hips/RightThigh
@onready var right_shin: Node3D = $VisualRoot/Hips/RightThigh/RightShin

# Mesh Instances
@onready var torso_mesh: MeshInstance3D = $VisualRoot/Hips/Torso/TorsoMesh
@onready var head_mesh: MeshInstance3D = $VisualRoot/Hips/Torso/Head/HeadMesh
@onready var left_arm_mesh: MeshInstance3D = $VisualRoot/Hips/Torso/LeftArm/LeftArmMesh
@onready var left_forearm_mesh: MeshInstance3D = $VisualRoot/Hips/Torso/LeftArm/LeftForearm/LeftForearmMesh
@onready var right_arm_mesh: MeshInstance3D = $VisualRoot/Hips/Torso/RightArm/RightArmMesh
@onready var right_forearm_mesh: MeshInstance3D = $VisualRoot/Hips/Torso/RightArm/RightForearm/RightForearmMesh
@onready var left_thigh_mesh: MeshInstance3D = $VisualRoot/Hips/LeftThigh/LeftThighMesh
@onready var left_shin_mesh: MeshInstance3D = $VisualRoot/Hips/LeftThigh/LeftShin/LeftShinMesh
@onready var right_thigh_mesh: MeshInstance3D = $VisualRoot/Hips/RightThigh/RightThighMesh
@onready var right_shin_mesh: MeshInstance3D = $VisualRoot/Hips/RightThigh/RightShin/RightShinMesh
@onready var quiver: Node3D = $VisualRoot/Hips/Torso/Quiver
@onready var quiver_mesh: MeshInstance3D = $VisualRoot/Hips/Torso/Quiver/QuiverMesh

# State
var current_anim: String = "idle"
var base_anim: String = "idle"
var anim_time: float = 0.0
var anim_speed: float = 1.0

# Action Timers & Durations
const SHOOT_DURATION: float = 1.05
const BACKSTEP_DURATION: float = 0.72
const HURT_DURATION: float = 0.55
var action_time: float = 0.0

# Smooth Cross-Fade Blending & Transitions
var is_blending: bool = false
var blend_timer: float = 0.0
const BLEND_DURATION: float = 0.35
const AIM_TRANSITION_DURATION: float = 0.45
var current_blend_duration: float = 0.35
var blend_from_anim: String = ""
var blend_to_anim: String = ""
var source_pose: Dictionary = {}
var current_pose: Dictionary = {}

var ground_hips_y: float = 0.618
var current_stance: String = "aim"
var default_stance_configs: Dictionary = {}
var stance_configs: Dictionary = {}

# Bowstring & Arrow FX
var bow_rest_mesh: ArrayMesh = null
var bow_drawn_mesh: ArrayMesh = null
var flying_arrow: MeshInstance3D = null
var arrow_velocity: Vector3 = Vector3.ZERO
var arrow_timer: float = 0.0

const StunStarsScript = preload("res://scripts/stun_stars.gd")
var stun_stars: Node3D = null

# Outfits: 1 = Thô Sơ (Primitive Hunter), 2 = Ranger (Xạ Thủ Kiểm Lâm)
var current_outfit: int = 1
var outfit_meshes: Dictionary = {}

signal anim_changed(anim_name: String)
signal outfit_changed(outfit_id: int)

func _ready() -> void:
	if quiver:
		quiver.position = Vector3(0.07, 0.26, -0.21)
		quiver.rotation_degrees = Vector3(-6.0, 12.0, -25.0)
	generate_voxel_meshes()
	_init_stun_stars()
	_init_default_stances()
	load_stance_config()
	current_pose = _compute_pose(current_anim, 0.0)
	_apply_pose(current_pose)

func _init_default_stances() -> void:
	default_stance_configs = {
		"idle": {
			"right_arm_rot": Vector3(4.0, 0.0, 9.0),
			"right_forearm_rot": Vector3(-14.0, 0.0, 0.0),
			"bow_rot": Vector3(77.0, 0.0, 12.0),
			"left_arm_rot": Vector3(6.0, 0.0, -13.0),
			"left_forearm_rot": Vector3(-12.0, 0.0, 0.0),
			"torso_rot": Vector3(4.0, 0.0, 0.0),
			"head_rot": Vector3(0.0, 0.0, 0.0)
		},
		"ready": {
			"right_arm_rot": Vector3(-45.0, -44.0, 20.0),
			"right_forearm_rot": Vector3(-95.0, 0.0, 0.0),
			"bow_rot": Vector3(89.0, 80.0, 36.0),
			"left_arm_rot": Vector3(-51.0, 5.0, -20.0),
			"left_forearm_rot": Vector3(-45.0, 0.0, 0.0),
			"torso_rot": Vector3(6.0, 12.0, -4.0),
			"head_rot": Vector3(0.0, -20.0, 0.0)
		},
		"walk": {
			"right_arm_rot": Vector3(4.0, 0.0, 9.0),
			"right_forearm_rot": Vector3(-14.0, 0.0, 0.0),
			"bow_rot": Vector3(77.0, 0.0, 12.0),
			"left_arm_rot": Vector3(6.0, 0.0, -13.0),
			"left_forearm_rot": Vector3(-12.0, 0.0, 0.0),
			"torso_rot": Vector3(7.0, 0.0, 0.0),
			"head_rot": Vector3(-2.0, 0.0, 0.0)
		},
		"run": {
			"right_arm_rot": Vector3(4.0, 0.0, 9.0),
			"right_forearm_rot": Vector3(-14.0, 0.0, 0.0),
			"bow_rot": Vector3(77.0, 0.0, 12.0),
			"left_arm_rot": Vector3(-14.0, -10.0, -12.0),
			"left_forearm_rot": Vector3(-35.0, 0.0, 0.0),
			"torso_rot": Vector3(20.0, 0.0, 0.0),
			"head_rot": Vector3(-12.0, 0.0, 0.0)
		},
		"aim": {
			"right_arm_rot": Vector3(-13.3, -120.9, 120.2),
			"right_forearm_rot": Vector3(-76.5, 0.0, 0.0),
			"bow_rot": Vector3(125.5, 44.1, 73.1),
			"left_arm_rot": Vector3(-109.9, -51.1, 8.0),
			"left_forearm_rot": Vector3(-1.0, 0.0, 0.0),
			"torso_rot": Vector3(10.0, 15.0, -8.0),
			"head_rot": Vector3(-6.0, -65.0, 8.0)
		},
		"shoot": {
			"right_arm_rot": Vector3(-10.0, -128.0, 115.0),
			"right_forearm_rot": Vector3(-60.0, 0.0, 0.0),
			"bow_rot": Vector3(128.5, 44.1, 73.1),
			"left_arm_rot": Vector3(-113.9, -51.1, 8.0),
			"left_forearm_rot": Vector3(-4.0, 0.0, 0.0),
			"torso_rot": Vector3(13.0, 15.0, -8.0),
			"head_rot": Vector3(-6.0, -65.0, 8.0)
		},
		"hurt": {
			"right_arm_rot": Vector3(15.0, 0.0, 20.0),
			"right_forearm_rot": Vector3(-35.0, 0.0, 0.0),
			"bow_rot": Vector3(15.0, 0.0, 10.0),
			"left_arm_rot": Vector3(25.0, 0.0, -20.0),
			"left_forearm_rot": Vector3(-40.0, 0.0, 0.0),
			"torso_rot": Vector3(-18.0, 0.0, 0.0),
			"head_rot": Vector3(16.0, 0.0, 0.0)
		},
		"stunned": {
			"right_arm_rot": Vector3(12.0, 0.0, 15.0),
			"right_forearm_rot": Vector3(-20.0, 0.0, 0.0),
			"bow_rot": Vector3(10.0, 0.0, 20.0),
			"left_arm_rot": Vector3(14.0, 0.0, -16.0),
			"left_forearm_rot": Vector3(-18.0, 0.0, 0.0),
			"torso_rot": Vector3(10.0, 0.0, 4.0),
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
				if d.has("archer") and d["archer"] is Dictionary:
					d = d["archer"]
				if d.has("ground_hips_y"):
					ground_hips_y = float(d["ground_hips_y"])
				for s_key in d:
					if s_key == "ground_hips_y":
						continue
					if d[s_key] is Dictionary:
						var s_dict = d[s_key]
						if not stance_configs.has(s_key):
							stance_configs[s_key] = {}
						for prop in ["right_arm_rot", "right_forearm_rot", "bow_rot", "left_arm_rot", "left_forearm_rot", "torso_rot", "head_rot"]:
							if s_dict.has(prop) and s_dict[prop] is Array and s_dict[prop].size() == 3:
								stance_configs[s_key][prop] = Vector3(float(s_dict[prop][0]), float(s_dict[prop][1]), float(s_dict[prop][2]))

func get_stance_definitions() -> Array:
	return [
		{"id": "idle", "name": "Idle", "shortcut": "[ 1 ]"},
		{"id": "ready", "name": "Ready", "shortcut": "[ 2 ]"},
		{"id": "walk", "name": "Walk", "shortcut": "[ 3 ]"},
		{"id": "run", "name": "Run", "shortcut": "[ 4 ]"},
		{"id": "aim", "name": "Aim", "shortcut": "[ 5 ]"},
		{"id": "shoot", "name": "Bắn", "shortcut": "[ 6 ]"},
		{"id": "hurt", "name": "Trúng Đòn", "shortcut": "[ 7 ]"},
		{"id": "stunned", "name": "Choáng", "shortcut": "[ 8 ]"}
	]

func get_weapon_info() -> Dictionary:
	return {
		"title": "🏹 CÁNH CUNG (GÓC NGỬA & HƯỚNG)",
		"prop": "bow_rot"
	}

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
	all_cfg["archer"] = serialize_stances()
	
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
	for k in ["right_arm_rot", "right_forearm_rot", "bow_rot", "left_arm_rot", "left_forearm_rot", "torso_rot", "head_rot"]:
		var v: Vector3 = s.get(k, Vector3.ZERO)
		out[k] = [snappedf(v.x, 0.1), snappedf(v.y, 0.1), snappedf(v.z, 0.1)]
	return out

func copy_weapon_from_idle(target_anim: String) -> void:
	var idle_cfg = stance_configs.get("idle", default_stance_configs.get("idle", {}))
	if not stance_configs.has(target_anim):
		stance_configs[target_anim] = default_stance_configs.get(target_anim, {}).duplicate()
	if idle_cfg.has("bow_rot"):
		stance_configs[target_anim]["bow_rot"] = idle_cfg["bow_rot"]
	current_pose = _compute_pose(current_anim, anim_time)
	_apply_pose(current_pose)

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

func set_live_ground_hips_y(val: float) -> void:
	ground_hips_y = val
	current_pose = _compute_pose(current_anim, anim_time)
	_apply_pose(current_pose)

func generate_voxel_meshes() -> void:
	# Pre-build meshes for Outfit 1 (Thô Sơ / Primitive Hunter)
	outfit_meshes[1] = {
		"torso": VoxelBuilder.build_archer_torso_mesh(1),
		"head": VoxelBuilder.build_archer_head_mesh(1),
		"upper_arm": VoxelBuilder.build_archer_upper_arm_mesh(1),
		"left_forearm": VoxelBuilder.build_archer_forearm_mesh(false, 1),
		"right_forearm": VoxelBuilder.build_archer_forearm_mesh(true, 1),
		"thigh": VoxelBuilder.build_archer_thigh_mesh(1),
		"shin": VoxelBuilder.build_archer_shin_mesh(1)
	}
	
	# Pre-build meshes for Outfit 2 (Ranger / Xạ Thủ Kiểm Lâm)
	outfit_meshes[2] = {
		"torso": VoxelBuilder.build_archer_torso_mesh(2),
		"head": VoxelBuilder.build_archer_head_mesh(2),
		"upper_arm": VoxelBuilder.build_archer_upper_arm_mesh(2),
		"left_forearm": VoxelBuilder.build_archer_forearm_mesh(false, 2),
		"right_forearm": VoxelBuilder.build_archer_forearm_mesh(true, 2),
		"thigh": VoxelBuilder.build_archer_thigh_mesh(2),
		"shin": VoxelBuilder.build_archer_shin_mesh(2)
	}
	
	quiver_mesh.mesh = VoxelBuilder.build_quiver_mesh()
	
	bow_rest_mesh = VoxelBuilder.build_bow_mesh(false)
	bow_drawn_mesh = VoxelBuilder.build_bow_mesh(true)
	bow_mesh.mesh = bow_rest_mesh
	
	arrow_mesh.mesh = VoxelBuilder.build_arrow_mesh()
	arrow.visible = false
	
	if not flying_arrow:
		flying_arrow = MeshInstance3D.new()
		flying_arrow.mesh = VoxelBuilder.build_arrow_mesh()
		flying_arrow.visible = false
		get_parent().call_deferred("add_child", flying_arrow)
		
	apply_outfit(current_outfit)

func set_outfit(outfit_id: int) -> void:
	current_outfit = clamp(outfit_id, 1, 2)
	apply_outfit(current_outfit)
	outfit_changed.emit(current_outfit)

func apply_outfit(outfit_id: int) -> void:
	if not outfit_meshes.has(outfit_id):
		return
	var m: Dictionary = outfit_meshes[outfit_id]
	torso_mesh.mesh = m["torso"]
	head_mesh.mesh = m["head"]
	left_arm_mesh.mesh = m["upper_arm"]
	left_forearm_mesh.mesh = m["left_forearm"]
	right_arm_mesh.mesh = m["upper_arm"]
	right_forearm_mesh.mesh = m["right_forearm"]
	left_thigh_mesh.mesh = m["thigh"]
	left_shin_mesh.mesh = m["shin"]
	right_thigh_mesh.mesh = m["thigh"]
	right_shin_mesh.mesh = m["shin"]

func _init_stun_stars() -> void:
	stun_stars = StunStarsScript.new()
	stun_stars.name = "StunStarsFX"
	head.add_child(stun_stars)

func play_anim(anim_name: String) -> void:
	if current_anim == anim_name and not is_blending and anim_name in ["idle", "walk", "run", "aim", "stunned"]:
		return
		
	if anim_name in ["shoot", "backstep", "hurt"]:
		if not (current_anim in ["shoot", "backstep", "hurt"]):
			base_anim = current_anim
		action_time = 0.0
	else:
		base_anim = anim_name
		
	blend_from_anim = current_anim
	blend_to_anim = anim_name
	current_anim = anim_name
	anim_time = 0.0
	_start_blend()
	emit_signal("anim_changed", current_anim)

func set_speed(val: float) -> void:
	anim_speed = clampf(val, 0.2, 3.0)

func _start_blend() -> void:
	source_pose = current_pose.duplicate(true)
	blend_timer = 0.0
	is_blending = true
	if blend_from_anim == "aim" or blend_to_anim == "aim":
		current_blend_duration = AIM_TRANSITION_DURATION
	else:
		current_blend_duration = BLEND_DURATION

func _process(delta: float) -> void:
	var dt = delta * anim_speed
	anim_time += dt
	
	if current_anim == "shoot":
		action_time += dt
		_update_shooting_fx(action_time, dt)
		if action_time >= SHOOT_DURATION:
			blend_from_anim = current_anim
			blend_to_anim = "aim"
			current_anim = "aim"
			action_time = 0.0
			_start_blend()
			emit_signal("anim_changed", current_anim)
	elif current_anim == "backstep":
		action_time += dt
		if action_time >= BACKSTEP_DURATION:
			blend_from_anim = current_anim
			blend_to_anim = base_anim
			current_anim = base_anim
			action_time = 0.0
			_start_blend()
			emit_signal("anim_changed", current_anim)
	elif current_anim == "hurt":
		action_time += dt
		if action_time >= HURT_DURATION:
			blend_from_anim = current_anim
			blend_to_anim = base_anim
			current_anim = base_anim
			action_time = 0.0
			_start_blend()
			emit_signal("anim_changed", current_anim)
			
	if stun_stars:
		stun_stars.set_active(current_anim == "stunned")
		
	var target_pose = _compute_pose(current_anim, anim_time)
	
	if is_blending:
		blend_timer += dt
		var factor = clampf(blend_timer / current_blend_duration, 0.0, 1.0)
		var smooth_f = smoothstep(0.0, 1.0, factor)
		current_pose = _blend_poses(source_pose, target_pose, smooth_f)
		if factor >= 1.0:
			is_blending = false
	else:
		current_pose = target_pose
		
	_apply_pose(current_pose)
	
	if flying_arrow and flying_arrow.visible:
		flying_arrow.position += arrow_velocity * delta
		arrow_timer -= delta
		if arrow_timer <= 0.0:
			flying_arrow.visible = false

func _update_shooting_fx(t_shot: float, _dt: float) -> void:
	var tau = t_shot / SHOOT_DURATION
	if tau >= 0.08 and tau < 0.65:
		if not flying_arrow.visible and arrow_timer <= 0.0:
			arrow.visible = false
			flying_arrow.visible = true
			flying_arrow.global_position = bow.to_global(Vector3(0.03, 0.0, 0.20))
			flying_arrow.global_transform.basis = bow.global_transform.basis
			arrow_velocity = bow.global_transform.basis.z * 28.0
			arrow_timer = 0.85
	elif tau >= 0.80:
		arrow.visible = true

func _compute_pose(anim: String, time_val: float) -> Dictionary:
	match anim:
		"idle": return _compute_idle(time_val)
		"ready": return _compute_ready(time_val)
		"walk": return _compute_walk(time_val)
		"run": return _compute_run(time_val)
		"aim": return _compute_aim(time_val)
		"shoot": return _compute_shoot(action_time)
		"backstep": return _compute_backstep(action_time)
		"hurt": return _compute_hurt(action_time)
		"stunned": return _compute_stunned(time_val)
		_: return _compute_idle(time_val)

# ==============================================================================
# 1. IDLE: Cầm Thân Gỗ Cung Buông Thẳng Bên Hông Trái, Thả Lỏng Tự Nhiên
# ==============================================================================
func _compute_idle(time_val: float) -> Dictionary:
	var p: Dictionary = {}
	var t = time_val * 2.4
	var breath = sin(t) * 0.008
	var cfg = stance_configs.get("idle", default_stance_configs.get("idle", {}))
	
	p["hips_pos"] = Vector3(0.0, ground_hips_y + breath, 0.0)
	p["hips_rot"] = Vector3(0.0, sin(t * 0.5) * 3.0, 0.0)
	p["torso_rot"] = cfg.get("torso_rot", Vector3(4.0, 0.0, 0.0)) + Vector3(sin(t) * 1.5, 0, 0)
	p["head_rot"] = cfg.get("head_rot", Vector3(-2.0, 0.0, 0.0)) + Vector3(0, sin(t * 0.7) * 12.0, 0)
	
	p["left_arm_rot"] = cfg.get("left_arm_rot", Vector3(6.0, 0.0, -12.0)) + Vector3(-breath * 35.0, 0, 0)
	p["left_forearm_rot"] = cfg.get("left_forearm_rot", Vector3(-12.0, 0.0, 0.0))
	p["bow_rot"] = cfg.get("bow_rot", Vector3(0.0, 0.0, 12.0))
	
	p["right_arm_rot"] = cfg.get("right_arm_rot", Vector3(4.0, 0.0, 10.0)) + Vector3(breath * 35.0, 0, 0)
	p["right_forearm_rot"] = cfg.get("right_forearm_rot", Vector3(-14.0, 0.0, 0.0))
	
	p["left_thigh_rot"] = Vector3(-2.0, 0.0, -3.0)
	p["left_shin_rot"] = Vector3(4.0, 0.0, 0.0)
	p["right_thigh_rot"] = Vector3(2.0, 0.0, 3.0)
	p["right_shin_rot"] = Vector3(3.0, 0.0, 0.0)
	
	p["is_drawn"] = false
	p["arrow_visible"] = false
	return p

# ==============================================================================
# READY: Thế Cung Thủ Sẵn Sàng / Khảo Sát
# ==============================================================================
func _compute_ready(time_val: float) -> Dictionary:
	var p: Dictionary = {}
	var t = time_val * 2.6
	var breath = sin(t) * 0.006
	var cfg = stance_configs.get("ready", default_stance_configs.get("ready", {}))
	
	p["hips_pos"] = Vector3(0.0, ground_hips_y + breath, 0.0)
	p["hips_rot"] = Vector3(0.0, 15.0, 0.0)
	p["torso_rot"] = cfg.get("torso_rot", Vector3(6.0, 12.0, -4.0)) + Vector3(sin(t) * 1.0, 0, 0)
	p["head_rot"] = cfg.get("head_rot", Vector3(-4.0, -20.0, 0.0))
	
	p["left_thigh_rot"] = Vector3(-8.0, 0.0, -4.0)
	p["left_shin_rot"] = Vector3(12.0, 0.0, 0.0)
	p["right_thigh_rot"] = Vector3(6.0, 0.0, 4.0)
	p["right_shin_rot"] = Vector3(8.0, 0.0, 0.0)
	
	p["left_arm_rot"] = cfg.get("left_arm_rot", Vector3(-35.0, -10.0, -20.0))
	p["left_forearm_rot"] = cfg.get("left_forearm_rot", Vector3(-45.0, 0.0, 0.0))
	p["bow_rot"] = cfg.get("bow_rot", Vector3(45.0, 15.0, 25.0))
	
	p["right_arm_rot"] = cfg.get("right_arm_rot", Vector3(-45.0, -30.0, 20.0))
	p["right_forearm_rot"] = cfg.get("right_forearm_rot", Vector3(-95.0, 0.0, 0.0))
	
	p["is_drawn"] = false
	p["arrow_visible"] = false
	return p

# ==============================================================================
# 2. WALK: Rình Mập Uyển Chuyển Của Xạ Thủ Yêu Tinh (Organic Biomechanical Stride)
# ==============================================================================
func _compute_walk(time_val: float) -> Dictionary:
	var p: Dictionary = {}
	var t = time_val * 4.8
	
	# Hông: Nhấp nhô điều hòa trơn tru bậc cao, trọng tâm hơi hạ khi bước chân
	p["hips_pos"] = Vector3(sin(t) * 0.012, ground_hips_y - cos(2.0 * t) * 0.018, 0.0)
	p["hips_rot"] = Vector3(2.0, sin(t) * 5.0, 0.0)
	
	# Cột sống & Đầu: Thân trên chồm nhẹ về trước rình mò, cân bằng xoay ngược hông
	p["torso_rot"] = Vector3(7.0 + cos(2.0 * t) * 1.5, -sin(t) * 4.0, sin(t) * 1.8)
	p["head_rot"] = Vector3(-2.0, sin(t) * 2.5, -sin(t) * 1.0)
	
	# Chân Trái: Chu kỳ bước đi tự nhiên (Stance Absorption + Swing Phase)
	var thigh_l = -cos(t) * 26.0
	var stance_l = pow(max(0.0, cos(t - 0.25 * PI)), 2.0) * 8.0
	var swing_l = pow(max(0.0, cos(t - 1.35 * PI)), 1.8) * 38.0
	p["left_thigh_rot"] = Vector3(thigh_l, 0.0, -2.0)
	p["left_shin_rot"] = Vector3(5.0 + stance_l + swing_l, 0.0, 0.0)
	
	# Chân Phải: Lệch pha 180° (PI)
	var t_r = t + PI
	var thigh_r = -cos(t_r) * 26.0
	var stance_r = pow(max(0.0, cos(t_r - 0.25 * PI)), 2.0) * 8.0
	var swing_r = pow(max(0.0, cos(t_r - 1.35 * PI)), 1.8) * 38.0
	p["right_thigh_rot"] = Vector3(thigh_r, 0.0, 2.0)
	p["right_shin_rot"] = Vector3(5.0 + stance_r + swing_r, 0.0, 0.0)
	
	# Thế tay mang cung
	var cfg = stance_configs.get("walk", default_stance_configs.get("walk", {}))
	var base_bow: Vector3 = cfg.get("bow_rot", Vector3(0.0, 0.0, 12.0))
	var base_l_arm: Vector3 = cfg.get("left_arm_rot", Vector3(6.0, 0.0, -12.0))
	var base_l_fore: Vector3 = cfg.get("left_forearm_rot", Vector3(-12.0, 0.0, 0.0))
	var base_r_arm: Vector3 = cfg.get("right_arm_rot", Vector3(4.0, 0.0, 10.0))
	var base_r_fore: Vector3 = cfg.get("right_forearm_rot", Vector3(-14.0, 0.0, 0.0))
	
	# Tay trái xách cung: Vung nhẹ tự nhiên theo nhịp chân, góc cung ngửa ra ngoài không chạm đùi
	p["bow_rot"] = base_bow + Vector3(sin(t) * 4.0, 0.0, 0.0)
	p["left_arm_rot"] = base_l_arm + Vector3(-sin(t) * 14.0, 0.0, 0.0)
	p["left_forearm_rot"] = base_l_fore + Vector3(-max(0.0, -sin(t)) * 8.0, 0.0, 0.0)
	
	# Tay phải đánh tự do
	p["right_arm_rot"] = base_r_arm + Vector3(sin(t) * 18.0, 0.0, 0.0)
	p["right_forearm_rot"] = base_r_fore + Vector3(-max(0.0, sin(t)) * 12.0, 0.0, 0.0)
	
	p["is_drawn"] = false
	p["arrow_visible"] = false
	return p

# ==============================================================================
# 3. RUN: Chạy Nước Rút Cơ Động Của Xạ Thủ (Agile Ranger Sprint)
# ==============================================================================
func _compute_run(time_val: float) -> Dictionary:
	var p: Dictionary = {}
	var t = time_val * 8.8
	
	# Hông: Dập nhịp chạy điều hòa trơn tru, dồn lực mạnh
	p["hips_pos"] = Vector3(0.0, ground_hips_y - 0.035 - cos(2.0 * t) * 0.024, 0.0)
	p["hips_rot"] = Vector3(6.0, sin(t) * 8.0, sin(t) * 3.0)
	
	# Cột sống & Đầu: Nghiêng dốc về trước tăng khí động học, đầu ổn định hướng nhìn
	p["torso_rot"] = Vector3(20.0 + cos(2.0 * t) * 2.5, -sin(t) * 7.0, cos(t) * 2.5)
	p["head_rot"] = Vector3(-12.0, sin(t) * 3.5, 0.0)
	
	# Chân Trái: Vung sải chân thể thao với lực gót đẩy sau và nâng cao đùi trước
	var thigh_l = -cos(t) * 38.0
	var stance_l = pow(max(0.0, cos(t - 0.9)), 2.0) * 16.0
	var rear_kick_l = pow(max(0.0, cos(t - PI)), 2.0) * 58.0
	var knee_drive_l = pow(max(0.0, cos(t - 4.52)), 2.0) * 65.0
	p["left_thigh_rot"] = Vector3(thigh_l, 0.0, -3.0)
	p["left_shin_rot"] = Vector3(8.0 + stance_l + max(rear_kick_l, knee_drive_l), 0.0, 0.0)
	
	# Chân Phải: Lệch pha 180°
	var t_r = t + PI
	var thigh_r = -cos(t_r) * 38.0
	var stance_r = pow(max(0.0, cos(t_r - 0.9)), 2.0) * 16.0
	var rear_kick_r = pow(max(0.0, cos(t_r - PI)), 2.0) * 58.0
	var knee_drive_r = pow(max(0.0, cos(t_r - 4.52)), 2.0) * 65.0
	p["right_thigh_rot"] = Vector3(thigh_r, 0.0, 3.0)
	p["right_shin_rot"] = Vector3(8.0 + stance_r + max(rear_kick_r, knee_drive_r), 0.0, 0.0)
	
	var cfg = stance_configs.get("run", default_stance_configs.get("run", {}))
	var base_bow: Vector3 = cfg.get("bow_rot", Vector3(25.0, 5.0, 15.0))
	var base_l_arm: Vector3 = cfg.get("left_arm_rot", Vector3(-14.0, -10.0, -12.0))
	var base_l_fore: Vector3 = cfg.get("left_forearm_rot", Vector3(-35.0, 0.0, 0.0))
	var base_r_arm: Vector3 = cfg.get("right_arm_rot", Vector3(4.0, 0.0, 10.0))
	var base_r_fore: Vector3 = cfg.get("right_forearm_rot", Vector3(-14.0, 0.0, 0.0))
	
	# Ranger Bow Sprint Carriage: Cung cầm ở tay trái đưa chéo về trước, chếch lên trên và ra ngoài
	# Triệt tiêu 100% việc chạm đùi khi đùi nâng cao sải chân
	p["bow_rot"] = base_bow + Vector3(sin(t) * 6.0, 0.0, 0.0)
	p["left_arm_rot"] = base_l_arm + Vector3(sin(t) * 12.0, 0.0, 0.0)
	p["left_forearm_rot"] = base_l_fore + Vector3(-sin(t) * 10.0, 0.0, 0.0)
	
	# Tay phải bơm nhịp điệu mạnh mẽ
	p["right_arm_rot"] = base_r_arm + Vector3(-sin(t) * 32.0, 0.0, 14.0)
	p["right_forearm_rot"] = base_r_fore + Vector3(-40.0 - sin(t) * 22.0, 0.0, 0.0)
	
	p["is_drawn"] = false
	p["arrow_visible"] = false
	return p

# ==============================================================================
# 4. AIM: TƯ THẾ BẮN CUNG KINH ĐIỂN - TRIỆT TIÊU CLIPPING 100%
# ==============================================================================
func _compute_aim(time_val: float) -> Dictionary:
	var p: Dictionary = {}
	var tremor = sin(time_val * 42.0) * 0.20
	
	var cfg = stance_configs.get("aim", default_stance_configs.get("aim", {}))
	var base_bow: Vector3 = cfg.get("bow_rot", Vector3(125.5, 44.1, 73.1))
	var base_l_arm: Vector3 = cfg.get("left_arm_rot", Vector3(-109.9, -51.1, 8.0))
	var base_l_fore: Vector3 = cfg.get("left_forearm_rot", Vector3(-1.0, 0.0, 0.0))
	var base_r_arm: Vector3 = cfg.get("right_arm_rot", Vector3(-13.3, -120.9, 120.2))
	var base_r_fore: Vector3 = cfg.get("right_forearm_rot", Vector3(-76.5, 0.0, 0.0))
	var base_torso: Vector3 = cfg.get("torso_rot", Vector3(10.0, 15.0, -8.0))
	var base_head: Vector3 = cfg.get("head_rot", Vector3(-6.0, -65.0, 8.0))
	
	# Dáng đứng chiến đấu nghiêng người (Combat Archery Stance)
	p["hips_pos"] = Vector3(0.0, ground_hips_y - 0.03, 0.0)
	p["hips_rot"] = Vector3(0.0, 50.0, 0.0)
	p["torso_rot"] = base_torso
	p["head_rot"] = base_head
	
	# Chân trụ tấn vững chãi
	p["left_thigh_rot"] = Vector3(-18.0, 0.0, -6.0)
	p["left_shin_rot"] = Vector3(24.0, 0.0, 0.0)
	p["right_thigh_rot"] = Vector3(14.0, 0.0, 6.0)
	p["right_shin_rot"] = Vector3(16.0, 0.0, 0.0)
	
	# Tay trái đẩy thẳng bệ gỗ cung về phía trước (+Z), cánh cung ngửa ra ngoài (Cant Outward ~18°)
	p["left_arm_rot"] = base_l_arm + Vector3(tremor, 0, 0)
	p["left_forearm_rot"] = base_l_fore
	p["bow_rot"] = base_bow
	
	# Tay phải (Draw Arm): Cùi chỏ nhấc cao ngang vai vểnh ra mạn sườn phải
	p["right_arm_rot"] = base_r_arm + Vector3(tremor, 0, 0)
	p["right_forearm_rot"] = base_r_fore
	
	p["is_drawn"] = true
	p["arrow_visible"] = true
	return p

# ==============================================================================
# 5. SHOOT: BẮN TÊN ĐẦY ĐỦ 3 PHA
# ==============================================================================
func _compute_shoot(t_shot: float) -> Dictionary:
	var p: Dictionary = {}
	var tau = clampf(t_shot / SHOOT_DURATION, 0.0, 1.0)
	
	var aim_bow: Vector3 = Vector3(125.5, 44.1, 73.1)
	var aim_l_arm: Vector3 = Vector3(-109.9, -51.1, 8.0)
	var aim_l_fore: Vector3 = Vector3(-1.0, 0.0, 0.0)
	var aim_r_arm: Vector3 = Vector3(-13.3, -120.9, 120.2)
	var aim_r_fore: Vector3 = Vector3(-76.5, 0.0, 0.0)
	var aim_torso: Vector3 = Vector3(10.0, 15.0, -8.0)
	var aim_head: Vector3 = Vector3(-6.0, -65.0, 8.0)
	
	var cfg_idle = stance_configs.get("idle", default_stance_configs.get("idle", {}))
	var idle_bow: Vector3 = cfg_idle.get("bow_rot", Vector3(0.0, 0.0, 12.0))
	
	if tau < 0.12:
		# Phase 1: Bật nhả dây cung (Snap Release Follow-through)
		var s = tau / 0.12
		p["hips_pos"] = Vector3(0.0, ground_hips_y - 0.03, 0.0)
		p["hips_rot"] = Vector3(0.0, 50.0, 0.0)
		p["torso_rot"] = aim_torso + Vector3(s * 3.0, 0.0, 0.0)
		p["head_rot"] = aim_head
		
		# Cung giật nhẹ về trước
		p["left_arm_rot"] = aim_l_arm + Vector3(-s * 4.0, 0.0, 0.0)
		p["left_forearm_rot"] = aim_l_fore + Vector3(-s * 3.0, 0.0, 0.0)
		p["bow_rot"] = aim_bow + Vector3(s * 3.0, 0.0, 0.0)
		
		# Tay kéo giật bật về sau theo quán tính nhả dây
		p["right_arm_rot"] = aim_r_arm + Vector3(s * 3.0, -s * 7.0, -s * 5.0)
		p["right_forearm_rot"] = aim_r_fore + Vector3(s * 16.0, 0.0, 0.0)
		
		p["left_thigh_rot"] = Vector3(-18.0, 0.0, -6.0)
		p["left_shin_rot"] = Vector3(24.0, 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(14.0, 0.0, 6.0)
		p["right_shin_rot"] = Vector3(16.0, 0.0, 0.0)
		
		p["is_drawn"] = false
		p["arrow_visible"] = false
		
	elif tau < 0.50:
		# Phase 2: Với tay ra sau lưng rút mũi tên mới trong ống tên
		var s = smoothstep(0.0, 1.0, (tau - 0.12) / 0.38)
		p["hips_pos"] = Vector3(0.0, ground_hips_y - 0.03, 0.0)
		p["hips_rot"] = Vector3(0.0, 50.0, 0.0)
		p["torso_rot"] = aim_torso + Vector3((1.0 - s) * 3.0 + 1.0, 0.0, 0.0)
		p["head_rot"] = aim_head
		
		# Cung hạ thấp thư giãn
		p["left_arm_rot"] = _lerp_angles(aim_l_arm, Vector3(-80.0, -45.0, 8.0), s)
		p["left_forearm_rot"] = _lerp_angles(aim_l_fore, Vector3(-18.0, 0.0, 0.0), s)
		p["bow_rot"] = _lerp_angles(aim_bow, idle_bow + Vector3(25.0, 0.0, 0.0), s)
		
		# Tay phải quàng qua vai phải rút tên từ ống tên
		p["right_arm_rot"] = _lerp_angles(aim_r_arm + Vector3(3.0, -7.0, -5.0), Vector3(-110.0, -25.0, 30.0), s)
		p["right_forearm_rot"] = _lerp_angles(aim_r_fore + Vector3(16.0, 0.0, 0.0), Vector3(-125.0, 0.0, 0.0), s)
		
		p["left_thigh_rot"] = Vector3(-18.0, 0.0, -6.0)
		p["left_shin_rot"] = Vector3(24.0, 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(14.0, 0.0, 6.0)
		p["right_shin_rot"] = Vector3(16.0, 0.0, 0.0)
		
		p["is_drawn"] = false
		p["arrow_visible"] = false
		
	else:
		# Phase 3: Đặt tên vào dây và kéo căng hết cỡ về gò má
		var s = smoothstep(0.0, 1.0, (tau - 0.50) / 0.50)
		p["hips_pos"] = Vector3(0.0, ground_hips_y - 0.03, 0.0)
		p["hips_rot"] = Vector3(0.0, 50.0, 0.0)
		p["torso_rot"] = aim_torso
		p["head_rot"] = aim_head
		
		# Cung đẩy căng trở lại vị trí ngắm chính xác
		p["left_arm_rot"] = _lerp_angles(Vector3(-80.0, -45.0, 8.0), aim_l_arm, s)
		p["left_forearm_rot"] = _lerp_angles(Vector3(-18.0, 0.0, 0.0), aim_l_fore, s)
		p["bow_rot"] = _lerp_angles(idle_bow + Vector3(25.0, 0.0, 0.0), aim_bow, s)
		
		# Tay phải đưa mũi tên về dây, nạp tên và kéo căng về gò má
		p["right_arm_rot"] = _lerp_angles(Vector3(-110.0, -25.0, 30.0), aim_r_arm, s)
		p["right_forearm_rot"] = _lerp_angles(Vector3(-125.0, 0.0, 0.0), aim_r_fore, s)
		
		p["left_thigh_rot"] = Vector3(-18.0, 0.0, -6.0)
		p["left_shin_rot"] = Vector3(24.0, 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(14.0, 0.0, 6.0)
		p["right_shin_rot"] = Vector3(16.0, 0.0, 0.0)
		
		p["is_drawn"] = (s >= 0.70)
		p["arrow_visible"] = (s >= 0.35)
		
	return p

# ==============================================================================
# 6. BACKSTEP: CÚ NHẢY LÙI THOÁT THÂN ĐIỆU NGHỆ
# ==============================================================================
func _compute_backstep(t_bs: float) -> Dictionary:
	var p: Dictionary = {}
	var tau = clampf(t_bs / BACKSTEP_DURATION, 0.0, 1.0)
	
	var aim_bow: Vector3 = Vector3(125.5, 44.1, 73.1)
	var aim_l_arm: Vector3 = Vector3(-109.9, -51.1, 8.0)
	var aim_l_fore: Vector3 = Vector3(-1.0, 0.0, 0.0)
	var aim_r_arm: Vector3 = Vector3(-13.3, -120.9, 120.2)
	var aim_r_fore: Vector3 = Vector3(-76.5, 0.0, 0.0)
	var aim_torso: Vector3 = Vector3(10.0, 15.0, -8.0)
	var aim_head: Vector3 = Vector3(-6.0, -65.0, 8.0)
	
	var cfg_idle = stance_configs.get("idle", default_stance_configs.get("idle", {}))
	var idle_bow: Vector3 = cfg_idle.get("bow_rot", Vector3(0.0, 0.0, 12.0))
	
	if tau < 0.38:
		var s = sin((tau / 0.38) * 0.5 * PI)
		p["hips_pos"] = Vector3(0.0, ground_hips_y + s * 0.09, -s * 0.28)
		p["hips_rot"] = Vector3(-s * 10.0, lerp(50.0, 35.0, s), 0.0)
		p["torso_rot"] = aim_torso + Vector3(s * 12.0, -s * 5.0, 0.0)
		p["head_rot"] = aim_head + Vector3(-s * 6.0, s * 20.0, -s * 8.0)
		
		p["left_thigh_rot"] = Vector3(lerp(-18.0, -38.0, s), 0.0, -4.0)
		p["left_shin_rot"] = Vector3(lerp(24.0, 50.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(14.0, 20.0, s), 0.0, 4.0)
		p["right_shin_rot"] = Vector3(lerp(16.0, 35.0, s), 0.0, 0.0)
		
		p["left_arm_rot"] = _lerp_angles(aim_l_arm, Vector3(-45.0, -25.0, 0.0), s)
		p["left_forearm_rot"] = _lerp_angles(aim_l_fore, Vector3(-40.0, 0.0, 0.0), s)
		p["bow_rot"] = _lerp_angles(aim_bow, idle_bow + Vector3(25.0, 0.0, 10.0), s)
		
		p["right_arm_rot"] = _lerp_angles(aim_r_arm, Vector3(-35.0, -20.0, 15.0), s)
		p["right_forearm_rot"] = _lerp_angles(aim_r_fore, Vector3(-45.0, 0.0, 0.0), s)
		
	else:
		var s = smoothstep(0.0, 1.0, (tau - 0.38) / 0.62)
		p["hips_pos"] = Vector3(0.0, lerp(ground_hips_y + 0.09, ground_hips_y, s), lerp(-0.28, 0.0, s))
		p["hips_rot"] = Vector3(lerp(-10.0, 0.0, s), lerp(35.0, 50.0, s), 0.0)
		p["torso_rot"] = _lerp_angles(aim_torso + Vector3(12.0, -5.0, 0.0), aim_torso, s)
		p["head_rot"] = _lerp_angles(aim_head + Vector3(-6.0, 20.0, -8.0), aim_head, s)
		
		p["left_thigh_rot"] = Vector3(lerp(-38.0, -18.0, s), 0.0, -6.0)
		p["left_shin_rot"] = Vector3(lerp(50.0, 24.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(20.0, 14.0, s), 0.0, 6.0)
		p["right_shin_rot"] = Vector3(lerp(35.0, 16.0, s), 0.0, 0.0)
		
		p["left_arm_rot"] = _lerp_angles(Vector3(-45.0, -25.0, 0.0), aim_l_arm, s)
		p["left_forearm_rot"] = _lerp_angles(Vector3(-40.0, 0.0, 0.0), aim_l_fore, s)
		p["bow_rot"] = _lerp_angles(idle_bow + Vector3(25.0, 0.0, 10.0), aim_bow, s)
		
		p["right_arm_rot"] = _lerp_angles(Vector3(-35.0, -20.0, 15.0), aim_r_arm, s)
		p["right_forearm_rot"] = _lerp_angles(Vector3(-45.0, 0.0, 0.0), aim_r_fore, s)
		
	p["is_drawn"] = false
	p["arrow_visible"] = false
	return p

# ==============================================================================
# 7. HURT: TRÚNG ĐÒN DỮ DỘI
# ==============================================================================
func _compute_hurt(t_hurt: float) -> Dictionary:
	var p: Dictionary = {}
	var tau = clampf(t_hurt / HURT_DURATION, 0.0, 1.0)
	var s = sin(tau * PI)
	
	var cfg_idle = stance_configs.get("idle", default_stance_configs.get("idle", {}))
	var base_bow: Vector3 = cfg_idle.get("bow_rot", Vector3(0.0, 0.0, 12.0))
	var base_l_arm: Vector3 = cfg_idle.get("left_arm_rot", Vector3(6.0, 0.0, -12.0))
	
	p["hips_pos"] = Vector3(0.0, ground_hips_y - s * 0.04, -s * 0.14)
	p["hips_rot"] = Vector3(-s * 12.0, s * 10.0, 0.0)
	p["torso_rot"] = Vector3(-s * 25.0, -s * 14.0, 0.0)
	p["head_rot"] = Vector3(s * 20.0, s * 18.0, 0.0)
	
	p["left_arm_rot"] = base_l_arm + Vector3(-s * 35.0, 0.0, -s * 20.0)
	p["left_forearm_rot"] = Vector3(-40.0 - s * 25.0, 0.0, 0.0)
	p["bow_rot"] = base_bow + Vector3(s * 25.0, 0.0, 0.0)
	
	p["right_arm_rot"] = Vector3(s * 20.0, 0.0, 20.0 + s * 25.0)
	p["right_forearm_rot"] = Vector3(-35.0 - s * 20.0, 0.0, 0.0)
	
	p["left_thigh_rot"] = Vector3(-s * 18.0, 0.0, -6.0)
	p["left_shin_rot"] = Vector3(s * 28.0, 0.0, 0.0)
	p["right_thigh_rot"] = Vector3(s * 14.0, 0.0, 6.0)
	p["right_shin_rot"] = Vector3(s * 22.0, 0.0, 0.0)
	
	p["is_drawn"] = false
	p["arrow_visible"] = false
	return p

# ==============================================================================
# 8. STUNNED: CHOÁNG VÁNG ĐẢO ĐIÊN - BÀN CHÂN TIẾP ĐẤT VỮNG CHẮC (ZERO HOVERING)
# ==============================================================================
func _compute_stunned(time_val: float) -> Dictionary:
	var p: Dictionary = {}
	var t = time_val * 2.8
	
	var cfg_idle = stance_configs.get("idle", default_stance_configs.get("idle", {}))
	var base_bow: Vector3 = cfg_idle.get("bow_rot", Vector3(0.0, 0.0, 12.0))
	var base_l_arm: Vector3 = cfg_idle.get("left_arm_rot", Vector3(6.0, 0.0, -12.0))
	
	# Hông: Chuyển động lảo đảo say rượu nhẹ nhàng, độ cao được cân chỉnh chính xác
	# để lòng bàn chân luôn tiếp xúc vững chắc trên mặt sàn Y >= 0 (triệt tiêu 100% lún sàn và lơ lửng)
	p["hips_pos"] = Vector3(sin(t) * 0.024, ground_hips_y - 0.033 + cos(t * 2.0) * 0.006, cos(t) * 0.018)
	p["hips_rot"] = Vector3(cos(t) * 3.0, sin(t) * 8.0, sin(t) * 4.0)
	
	# Thân trên & Đầu: Chao đảo 3D say rượu, đầu gật gù ngơ ngác
	p["torso_rot"] = Vector3(12.0 + sin(t) * 8.0, -cos(t) * 14.0, -sin(t) * 6.0)
	p["head_rot"] = Vector3(-8.0 + cos(t * 1.3) * 12.0, sin(t) * 18.0, -cos(t * 0.7) * 14.0)
	
	# Chân đứng vững chãi dạng thế tấn choáng (Stagger Stance):
	# Hai chân hơi bạnh ra ngoài (+/- 5° Rz), gối hơi chùng tự nhiên, đế chân chạm phẳng mặt đất
	p["left_thigh_rot"] = Vector3(-8.0 + sin(t) * 3.5, 0.0, -5.0)
	p["left_shin_rot"] = Vector3(12.0 + cos(t) * 3.5, 0.0, 0.0)
	p["right_thigh_rot"] = Vector3(4.0 - sin(t) * 3.5, 0.0, 5.0)
	p["right_shin_rot"] = Vector3(8.0 - cos(t) * 3.5, 0.0, 0.0)
	
	# Cánh tay & Cung: Buông thõng lảo đảo theo thân mình
	var sway = sin(t) * 6.0
	p["left_arm_rot"] = base_l_arm + Vector3(10.0 + sway, 0.0, -cos(t) * 4.0)
	p["left_forearm_rot"] = Vector3(-14.0, 0.0, 0.0)
	p["bow_rot"] = base_bow + Vector3(16.0 + cos(t) * 5.0, 0.0, 0.0)
	
	p["right_arm_rot"] = Vector3(12.0 - sway, 0.0, 14.0 + cos(t) * 4.0)
	p["right_forearm_rot"] = Vector3(-12.0, 0.0, 0.0)
	
	p["is_drawn"] = false
	p["arrow_visible"] = false
	return p

# ==============================================================================
# LERP ANGLES & BLENDING
# ==============================================================================
func _lerp_angles(a: Vector3, b: Vector3, weight: float) -> Vector3:
	return Vector3(
		rad_to_deg(lerp_angle(deg_to_rad(a.x), deg_to_rad(b.x), weight)),
		rad_to_deg(lerp_angle(deg_to_rad(a.y), deg_to_rad(b.y), weight)),
		rad_to_deg(lerp_angle(deg_to_rad(a.z), deg_to_rad(b.z), weight))
	)

func _blend_poses(a: Dictionary, b: Dictionary, f: float) -> Dictionary:
	var out: Dictionary = {}
	for k in b:
		if a.has(k):
			if b[k] is Vector3:
				if k.ends_with("_rot"):
					out[k] = _lerp_angles(a[k], b[k], f)
				else:
					out[k] = a[k].lerp(b[k], f)
			elif b[k] is float:
				out[k] = lerpf(a[k], b[k], f)
			elif k == "is_drawn":
				if not a.get("is_drawn", false) and b.get("is_drawn", false):
					out["is_drawn"] = (f >= 0.75)
				elif a.get("is_drawn", false) and not b.get("is_drawn", false):
					out["is_drawn"] = false
				else:
					out["is_drawn"] = b["is_drawn"] if f >= 0.5 else a["is_drawn"]
			elif k == "arrow_visible":
				if not a.get("arrow_visible", false) and b.get("arrow_visible", false):
					out["arrow_visible"] = (f >= 0.35)
				elif a.get("arrow_visible", false) and not b.get("arrow_visible", false):
					out["arrow_visible"] = (f < 0.20)
				else:
					out["arrow_visible"] = b["arrow_visible"] if f >= 0.5 else a["arrow_visible"]
			else:
				out[k] = b[k] if f >= 0.5 else a[k]
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
	if p.has("bow_rot"): bow.rotation_degrees = p["bow_rot"]
	
	if p.has("right_arm_rot"): right_arm.rotation_degrees = p["right_arm_rot"]
	if p.has("right_forearm_rot"): right_forearm.rotation_degrees = p["right_forearm_rot"]
	
	if p.has("left_thigh_rot"): left_thigh.rotation_degrees = p["left_thigh_rot"]
	if p.has("left_shin_rot"): left_shin.rotation_degrees = p["left_shin_rot"]
	if p.has("right_thigh_rot"): right_thigh.rotation_degrees = p["right_thigh_rot"]
	if p.has("right_shin_rot"): right_shin.rotation_degrees = p["right_shin_rot"]
	
	if p.has("is_drawn"):
		if p["is_drawn"]:
			if bow_mesh.mesh != bow_drawn_mesh: bow_mesh.mesh = bow_drawn_mesh
		else:
			if bow_mesh.mesh != bow_rest_mesh: bow_mesh.mesh = bow_rest_mesh
			
	if p.has("arrow_visible"):
		arrow.visible = p["arrow_visible"]
