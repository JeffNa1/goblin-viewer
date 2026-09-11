class_name GoblinShaman
extends Node3D

@onready var hips: Node3D = $VisualRoot/Hips
@onready var torso: Node3D = $VisualRoot/Hips/Torso
@onready var head: Node3D = $VisualRoot/Hips/Torso/Head
@onready var left_arm: Node3D = $VisualRoot/Hips/Torso/LeftArm
@onready var left_forearm: Node3D = $VisualRoot/Hips/Torso/LeftArm/LeftForearm
@onready var right_arm: Node3D = $VisualRoot/Hips/Torso/RightArm
@onready var right_forearm: Node3D = $VisualRoot/Hips/Torso/RightArm/RightForearm
@onready var staff: Node3D = $VisualRoot/Hips/Torso/RightArm/RightForearm/Staff
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
@onready var staff_mesh: MeshInstance3D = $VisualRoot/Hips/Torso/RightArm/RightForearm/Staff/StaffMesh
@onready var left_thigh_mesh: MeshInstance3D = $VisualRoot/Hips/LeftThigh/LeftThighMesh
@onready var left_shin_mesh: MeshInstance3D = $VisualRoot/Hips/LeftThigh/LeftShin/LeftShinMesh
@onready var right_thigh_mesh: MeshInstance3D = $VisualRoot/Hips/RightThigh/RightThighMesh
@onready var right_shin_mesh: MeshInstance3D = $VisualRoot/Hips/RightThigh/RightShin/RightShinMesh

@onready var totem_spawn: Node3D = $TotemSpawn
@onready var totem_mesh: MeshInstance3D = $TotemSpawn/TotemMesh

# State
var current_anim: String = "idle" # "idle", "walk", "run", "chant", "summon", "hex", "hurt", "stunned"
var base_anim: String = "idle"
var anim_time: float = 0.0
var anim_speed: float = 1.0

# Action Timers
var action_time: float = 0.0
const SUMMON_DURATION: float = 1.45
const HEX_DURATION: float = 0.95
const HURT_DURATION: float = 0.50

# Blending
var is_blending: bool = false
var blend_timer: float = 0.0
const BLEND_DURATION: float = 0.22
var source_pose: Dictionary = {}
var current_pose: Dictionary = {}

var ground_hips_y: float = 0.618
var current_stance: String = "idle"
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

func _init_default_stances() -> void:
	default_stance_configs = {
		"idle": {
			"right_arm_rot": Vector3(-12.0, 6.0, 18.0),
			"right_forearm_rot": Vector3(-35.0, 0.0, 0.0),
			"staff_rot": Vector3(12.0, 0.0, -8.0),
			"left_arm_rot": Vector3(-25.0, 15.0, -26.0),
			"left_forearm_rot": Vector3(-65.0, 0.0, 0.0),
			"torso_rot": Vector3(6.0, 0.0, 0.0),
			"head_rot": Vector3(-4.0, 0.0, 0.0)
		},
		"chant": {
			"right_arm_rot": Vector3(-120.0, 15.0, 35.0),
			"right_forearm_rot": Vector3(-20.0, 0.0, 0.0),
			"staff_rot": Vector3(-15.0, 0.0, 0.0),
			"left_arm_rot": Vector3(-115.0, -15.0, -35.0),
			"left_forearm_rot": Vector3(-35.0, 0.0, 0.0),
			"torso_rot": Vector3(-14.0, 0.0, 0.0),
			"head_rot": Vector3(-24.0, 0.0, 0.0)
		},
		"ward": {
			"right_arm_rot": Vector3(-42.0, 20.0, 15.0),
			"right_forearm_rot": Vector3(-75.0, 0.0, 0.0),
			"staff_rot": Vector3(75.0, 25.0, -15.0),
			"left_arm_rot": Vector3(-48.0, -25.0, -20.0),
			"left_forearm_rot": Vector3(-85.0, 0.0, 0.0),
			"torso_rot": Vector3(10.0, -10.0, 0.0),
			"head_rot": Vector3(-6.0, 10.0, 0.0)
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
				if d.has("shaman") and d["shaman"] is Dictionary:
					d = d["shaman"]
				if d.has("ground_hips_y"):
					ground_hips_y = float(d["ground_hips_y"])
				for s_key in ["idle", "chant", "ward"]:
					if d.has(s_key) and d[s_key] is Dictionary:
						var s_dict = d[s_key]
						for prop in ["right_arm_rot", "right_forearm_rot", "staff_rot", "left_arm_rot", "left_forearm_rot", "torso_rot", "head_rot"]:
							if s_dict.has(prop) and s_dict[prop] is Array and s_dict[prop].size() == 3:
								stance_configs[s_key][prop] = Vector3(float(s_dict[prop][0]), float(s_dict[prop][1]), float(s_dict[prop][2]))

func get_stance_definitions() -> Array:
	return [
		{"id": "idle", "name": "Chống Gậy", "shortcut": "[ Q ]"},
		{"id": "chant", "name": "Tụ Chú", "shortcut": "[ W ]"},
		{"id": "ward", "name": "Pháp Ấn", "shortcut": "[ E ]"}
	]

func get_weapon_info() -> Dictionary:
	return {
		"title": "🦯 QUYỀN TRƯỢNG (HƯỚNG TRƯỢNG)",
		"prop": "staff_rot"
	}

func serialize_stances() -> Dictionary:
	return {
		"ground_hips_y": ground_hips_y,
		"idle": _serialize_stance(stance_configs.get("idle", {})),
		"chant": _serialize_stance(stance_configs.get("chant", {})),
		"ward": _serialize_stance(stance_configs.get("ward", {}))
	}

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
	all_cfg["shaman"] = serialize_stances()
	
	var f = FileAccess.open(path, FileAccess.WRITE)
	if f:
		f.store_string(JSON.stringify(all_cfg, "	"))
		f.close()
	var f2 = FileAccess.open("user://stance_config.json", FileAccess.WRITE)
	if f2:
		f2.store_string(JSON.stringify(all_cfg, "	"))
		f2.close()
	return true

func _serialize_stance(s: Dictionary) -> Dictionary:
	var out = {}
	for k in ["right_arm_rot", "right_forearm_rot", "staff_rot", "left_arm_rot", "left_forearm_rot", "torso_rot", "head_rot"]:
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

func generate_voxel_meshes() -> void:
	head_mesh.mesh = VoxelBuilder.build_shaman_head_mesh()
	torso_mesh.mesh = VoxelBuilder.build_shaman_torso_mesh()
	staff_mesh.mesh = VoxelBuilder.build_shaman_staff_mesh()
	totem_mesh.mesh = VoxelBuilder.build_totem_mesh()
	left_arm_mesh.mesh = VoxelBuilder.build_upper_arm_mesh()
	left_forearm_mesh.mesh = VoxelBuilder.build_forearm_mesh(false)
	right_arm_mesh.mesh = VoxelBuilder.build_upper_arm_mesh()
	right_forearm_mesh.mesh = VoxelBuilder.build_forearm_mesh(true)
	left_thigh_mesh.mesh = VoxelBuilder.build_thigh_mesh()
	left_shin_mesh.mesh = VoxelBuilder.build_shin_mesh()
	right_thigh_mesh.mesh = VoxelBuilder.build_thigh_mesh()
	right_shin_mesh.mesh = VoxelBuilder.build_shin_mesh()

func _init_stun_stars() -> void:
	stun_stars = StunStarsScript.new()
	stun_stars.name = "StunStarsFX"
	head.add_child(stun_stars)

func play_anim(anim_name: String) -> void:
	if current_anim == anim_name and current_anim not in ["summon", "hex", "hurt"]:
		return
	_start_blend()
	current_anim = anim_name
	action_time = 0.0
	
	if current_anim in ["idle", "walk", "run", "chant", "stunned"]:
		base_anim = current_anim
		
	if stun_stars:
		stun_stars.set_active(current_anim == "stunned")
		
	if current_anim != "summon":
		totem_mesh.visible = false
		
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
	
	if current_anim == "summon":
		action_time += dt
		_update_totem_spawn(action_time)
		if action_time >= SUMMON_DURATION:
			current_anim = base_anim
			action_time = 0.0
			_start_blend()
			emit_signal("anim_changed", current_anim)
	elif current_anim == "hex":
		action_time += dt
		if action_time >= HEX_DURATION:
			current_anim = base_anim
			action_time = 0.0
			_start_blend()
			emit_signal("anim_changed", current_anim)
	elif current_anim == "hurt":
		action_time += dt
		if action_time >= HURT_DURATION:
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

func _update_totem_spawn(t_s: float) -> void:
	var tau = t_s / SUMMON_DURATION
	# Totem erupts from ground at tau = 0.20
	if tau >= 0.20 and tau < 0.96:
		totem_mesh.visible = true
		var rise_s = clampf((tau - 0.20) / 0.25, 0.0, 1.0)
		var smooth_rise = smoothstep(0.0, 1.0, rise_s)
		# Erupts from Y = -1.2m below ground to Y = 0.0m
		totem_spawn.position.y = lerp(-1.2, 0.0, smooth_rise)
		if rise_s < 1.0:
			totem_spawn.position.x = 0.55 + sin(t_s * 60.0) * 0.025
		else:
			totem_spawn.position.x = 0.55
	elif tau >= 0.96:
		totem_mesh.visible = false

func _compute_pose(anim: String, time_val: float) -> Dictionary:
	match anim:
		"idle": return _compute_idle(time_val)
		"ward": return _compute_ward(time_val)
		"walk": return _compute_walk(time_val)
		"run": return _compute_run(time_val)
		"chant": return _compute_chant(time_val)
		"summon": return _compute_summon(action_time)
		"hex": return _compute_hex(action_time)
		"hurt": return _compute_hurt(action_time)
		"stunned": return _compute_stunned(time_val)
		_: return _compute_idle(time_val)

# --- 1. IDLE (Occult Sway, Muttering Chants, Staff Rest) ---
func _compute_idle(time_val: float) -> Dictionary:
	var p: Dictionary = {}
	var t = time_val * 2.0
	var bob = sin(t) * 0.012
	var cfg = stance_configs.get("idle", default_stance_configs.get("idle", {}))
	
	p["hips_pos"] = Vector3(0.0, ground_hips_y + bob, 0.0)
	p["hips_rot"] = Vector3(4.0, sin(t * 0.6) * 6.0, 0.0)
	p["torso_rot"] = cfg.get("torso_rot", Vector3(6.0, 0.0, 0.0)) + Vector3(sin(t) * 3.0, 0, sin(t * 0.7) * 2.0)
	p["head_rot"] = cfg.get("head_rot", Vector3(-4.0, 0.0, 0.0)) + Vector3(sin(t * 1.3) * 6.0, sin(t * 0.5) * 12.0, cos(t * 0.8) * 5.0)
	
	# Staff held in right hand, planted near ground
	p["right_arm_rot"] = cfg.get("right_arm_rot", Vector3(-12.0, 6.0, 18.0)) + Vector3(bob * 100.0, 0, 0)
	p["right_forearm_rot"] = cfg.get("right_forearm_rot", Vector3(-35.0, 0.0, 0.0))
	p["staff_rot"] = cfg.get("staff_rot", Vector3(12.0, 0.0, -8.0))
	
	# Left hand gesturing occult mudras
	p["left_arm_rot"] = cfg.get("left_arm_rot", Vector3(-25.0, 15.0, -26.0)) + Vector3(sin(t) * 8.0, 0, 0)
	p["left_forearm_rot"] = cfg.get("left_forearm_rot", Vector3(-65.0, 0.0, 0.0)) + Vector3(cos(t) * 12.0, 0, 0)
	
	p["left_thigh_rot"] = Vector3(-4.0, 0.0, -3.0)
	p["left_shin_rot"] = Vector3(6.0, 0.0, 0.0)
	p["right_thigh_rot"] = Vector3(4.0, 0.0, 3.0)
	p["right_shin_rot"] = Vector3(4.0, 0.0, 0.0)
	return p

# --- WARD (Thế Ấn Hộ Mệnh) ---
func _compute_ward(time_val: float) -> Dictionary:
	var p: Dictionary = {}
	var t = time_val * 2.5
	var bob = sin(t) * 0.008
	var cfg = stance_configs.get("ward", default_stance_configs.get("ward", {}))
	
	p["hips_pos"] = Vector3(0.0, ground_hips_y + bob, 0.0)
	p["hips_rot"] = Vector3(2.0, 10.0, 0.0)
	p["torso_rot"] = cfg.get("torso_rot", Vector3(10.0, -10.0, 0.0))
	p["head_rot"] = cfg.get("head_rot", Vector3(-6.0, 10.0, 0.0))
	
	p["right_arm_rot"] = cfg.get("right_arm_rot", Vector3(-42.0, 20.0, 15.0))
	p["right_forearm_rot"] = cfg.get("right_forearm_rot", Vector3(-75.0, 0.0, 0.0))
	p["staff_rot"] = cfg.get("staff_rot", Vector3(75.0, 25.0, -15.0))
	
	p["left_arm_rot"] = cfg.get("left_arm_rot", Vector3(-48.0, -25.0, -20.0))
	p["left_forearm_rot"] = cfg.get("left_forearm_rot", Vector3(-85.0, 0.0, 0.0))
	
	p["left_thigh_rot"] = Vector3(-8.0, 0.0, -4.0)
	p["left_shin_rot"] = Vector3(14.0, 0.0, 0.0)
	p["right_thigh_rot"] = Vector3(8.0, 0.0, 4.0)
	p["right_shin_rot"] = Vector3(10.0, 0.0, 0.0)
	return p

# --- 2. WALK (Deliberate Hunched Ritual Stride) ---
func _compute_walk(time_val: float) -> Dictionary:
	var p: Dictionary = {}
	var t = time_val * 3.8
	var s_leg = sin(t)
	
	p["hips_pos"] = Vector3(0.0, ground_hips_y + abs(sin(t * 2.0)) * 0.025, 0.0)
	p["hips_rot"] = Vector3(8.0, s_leg * 8.0, 0.0)
	p["torso_rot"] = Vector3(10.0, -s_leg * 6.0, 0.0)
	p["head_rot"] = Vector3(-8.0, -s_leg * 4.0, 0.0)
	
	p["left_thigh_rot"] = Vector3(-s_leg * 28.0, 0.0, 0.0)
	p["left_shin_rot"] = Vector3(maxf(0.0, s_leg * 34.0), 0.0, 0.0)
	p["right_thigh_rot"] = Vector3(s_leg * 28.0, 0.0, 0.0)
	p["right_shin_rot"] = Vector3(maxf(0.0, -s_leg * 34.0), 0.0, 0.0)
	
	var st_key = current_stance if (stance_configs.has(current_stance) and current_stance != "chant") else "idle"
	var cfg = stance_configs.get(st_key, default_stance_configs.get("idle", {}))
	var base_staff: Vector3 = cfg.get("staff_rot", Vector3(12.0, 0.0, -8.0))
	var base_r_arm: Vector3 = cfg.get("right_arm_rot", Vector3(-12.0, 6.0, 18.0))
	var base_r_fore: Vector3 = cfg.get("right_forearm_rot", Vector3(-35.0, 0.0, 0.0))
	var base_l_arm: Vector3 = cfg.get("left_arm_rot", Vector3(-25.0, 15.0, -26.0))
	var base_l_fore: Vector3 = cfg.get("left_forearm_rot", Vector3(-65.0, 0.0, 0.0))
	
	# Staff walking rhythm following base pose
	p["staff_rot"] = base_staff + Vector3(cos(t) * 4.0, 0.0, 0.0)
	p["right_arm_rot"] = base_r_arm + Vector3(cos(t) * 14.0, 0.0, 0.0)
	p["right_forearm_rot"] = base_r_fore
	
	p["left_arm_rot"] = base_l_arm + Vector3(-s_leg * 18.0, 0.0, 0.0)
	p["left_forearm_rot"] = base_l_fore
	return p

# --- 3. RUN (Frantic Skulking Robe Sprint) ---
func _compute_run(time_val: float) -> Dictionary:
	var p: Dictionary = {}
	var t = time_val * 6.8
	var s_leg = sin(t)
	
	p["hips_pos"] = Vector3(0.0, ground_hips_y - 0.02 + abs(sin(t * 2.0)) * 0.035, 0.0)
	p["hips_rot"] = Vector3(16.0, s_leg * 14.0, 0.0)
	p["torso_rot"] = Vector3(12.0, -s_leg * 10.0, 0.0)
	p["head_rot"] = Vector3(-14.0, 0.0, 0.0)
	
	p["left_thigh_rot"] = Vector3(-s_leg * 44.0, 0.0, 0.0)
	p["left_shin_rot"] = Vector3(maxf(0.0, s_leg * 52.0), 0.0, 0.0)
	p["right_thigh_rot"] = Vector3(s_leg * 44.0, 0.0, 0.0)
	p["right_shin_rot"] = Vector3(maxf(0.0, -s_leg * 52.0), 0.0, 0.0)
	
	var st_key = current_stance if (stance_configs.has(current_stance) and current_stance != "chant") else "idle"
	var cfg = stance_configs.get(st_key, default_stance_configs.get("idle", {}))
	var base_staff: Vector3 = cfg.get("staff_rot", Vector3(12.0, 0.0, -8.0))
	var base_r_arm: Vector3 = cfg.get("right_arm_rot", Vector3(-12.0, 6.0, 18.0))
	var base_r_fore: Vector3 = cfg.get("right_forearm_rot", Vector3(-35.0, 0.0, 0.0))
	var base_l_arm: Vector3 = cfg.get("left_arm_rot", Vector3(-25.0, 15.0, -26.0))
	var base_l_fore: Vector3 = cfg.get("left_forearm_rot", Vector3(-65.0, 0.0, 0.0))
	
	p["staff_rot"] = base_staff + Vector3(sin(t) * 8.0, 0.0, 0.0)
	p["right_arm_rot"] = base_r_arm + Vector3(cos(t) * 22.0, 0.0, 0.0)
	p["right_forearm_rot"] = base_r_fore
	
	p["left_arm_rot"] = base_l_arm + Vector3(-s_leg * 32.0, 0.0, 0.0)
	p["left_forearm_rot"] = base_l_fore
	return p

# --- 4. CHANT (Mystic Incantation, Levitation, Soul Surge) ---
func _compute_chant(time_val: float) -> Dictionary:
	var p: Dictionary = {}
	var t = time_val * 3.2
	var surge = sin(t)
	var float_y = sin(t * 0.8) * 0.045
	var cfg = stance_configs.get("chant", default_stance_configs.get("chant", {}))
	
	# Shaman levitates slightly off ground
	p["hips_pos"] = Vector3(0.0, ground_hips_y + 0.04 + float_y, 0.0)
	p["hips_rot"] = Vector3(-6.0 + surge * 3.0, sin(t * 0.4) * 8.0, 0.0)
	p["torso_rot"] = cfg.get("torso_rot", Vector3(-14.0, 0.0, 0.0)) + Vector3(surge * 5.0, 0, 0)
	p["head_rot"] = cfg.get("head_rot", Vector3(-24.0, 0.0, 0.0)) + Vector3(surge * 8.0, 0, 0)
	
	# Both arms raised high invoking dark deities
	p["right_arm_rot"] = cfg.get("right_arm_rot", Vector3(-120.0, 15.0, 35.0)) + Vector3(surge * 10.0, 0, 0)
	p["right_forearm_rot"] = cfg.get("right_forearm_rot", Vector3(-20.0, 0.0, 0.0))
	p["staff_rot"] = cfg.get("staff_rot", Vector3(-15.0, 0.0, 0.0)) + Vector3(surge * 8.0, 0, 0)
	
	p["left_arm_rot"] = cfg.get("left_arm_rot", Vector3(-115.0, -15.0, -35.0)) + Vector3(surge * 10.0, 0, 0)
	p["left_forearm_rot"] = cfg.get("left_forearm_rot", Vector3(-35.0, 0.0, 0.0)) + Vector3(cos(t) * 8.0, 0, 0)
	
	# Feet dangling loosely in levitation
	p["left_thigh_rot"] = Vector3(10.0 + surge * 4.0, 0.0, -6.0)
	p["left_shin_rot"] = Vector3(25.0, 0.0, 0.0)
	p["right_thigh_rot"] = Vector3(14.0 - surge * 4.0, 0.0, 6.0)
	p["right_shin_rot"] = Vector3(28.0, 0.0, 0.0)
	return p

# --- 5. SUMMON RITUAL (Staff Slam, Earth Tremor, Totem Eruption) ---
func _compute_summon(t_s: float) -> Dictionary:
	var p: Dictionary = {}
	var tau = clampf(t_s / SUMMON_DURATION, 0.0, 1.0)
	var cfg = stance_configs.get(current_stance, default_stance_configs.get(current_stance, {}))
	var base_staff: Vector3 = cfg.get("staff_rot", Vector3(12.0, 0.0, -8.0))
	var base_r_arm: Vector3 = cfg.get("right_arm_rot", Vector3(-12.0, 6.0, 18.0))
	var base_r_fore: Vector3 = cfg.get("right_forearm_rot", Vector3(-35.0, 0.0, 0.0))
	var base_l_arm: Vector3 = cfg.get("left_arm_rot", Vector3(-25.0, 15.0, -26.0))
	var base_l_fore: Vector3 = cfg.get("left_forearm_rot", Vector3(-65.0, 0.0, 0.0))
	
	if tau < 0.28:
		# WINDUP (0.0s - 0.40s): Raise staff high with both hands, crouching
		var s = smoothstep(0.0, 1.0, tau / 0.28)
		p["hips_pos"] = Vector3(0.0, lerp(ground_hips_y, ground_hips_y + 0.04, s), lerp(0.0, -0.05, s))
		p["hips_rot"] = Vector3(lerp(0.0, -8.0, s), 0.0, 0.0)
		p["torso_rot"] = Vector3(lerp(0.0, -18.0, s), 0.0, 0.0)
		p["head_rot"] = Vector3(lerp(0.0, -16.0, s), 0.0, 0.0)
		
		p["right_arm_rot"] = _lerp_angles(base_r_arm, Vector3(-125.0, 15.0, 28.0), s)
		p["right_forearm_rot"] = _lerp_angles(base_r_fore, Vector3(-25.0, 0.0, 0.0), s)
		p["staff_rot"] = _lerp_angles(base_staff, Vector3(-25.0, 0.0, 0.0), s)
		
		p["left_arm_rot"] = _lerp_angles(base_l_arm, Vector3(-110.0, -15.0, -30.0), s)
		p["left_forearm_rot"] = _lerp_angles(base_l_fore, Vector3(-45.0, 0.0, 0.0), s)
		
		p["left_thigh_rot"] = Vector3(-6.0, 0.0, -4.0)
		p["left_shin_rot"] = Vector3(12.0, 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(4.0, 0.0, 4.0)
		p["right_shin_rot"] = Vector3(10.0, 0.0, 0.0)
		
	elif tau < 0.44:
		# SLAM TO GROUND (0.28s - 0.64s): Staff slams vertically into earth!
		var s = smoothstep(0.0, 1.0, (tau - 0.28) / 0.16)
		p["hips_pos"] = Vector3(0.0, lerp(ground_hips_y + 0.04, ground_hips_y - 0.06, s), lerp(-0.05, 0.12, s))
		p["hips_rot"] = Vector3(lerp(-8.0, 16.0, s), 0.0, 0.0)
		p["torso_rot"] = Vector3(lerp(-18.0, 28.0, s), 0.0, 0.0)
		p["head_rot"] = Vector3(lerp(-16.0, -8.0, s), 0.0, 0.0)
		
		# Staff planted into ground vertically
		p["right_arm_rot"] = Vector3(lerp(-125.0, -25.0, s), 0.0, 12.0)
		p["right_forearm_rot"] = Vector3(lerp(-25.0, -65.0, s), 0.0, 0.0)
		p["staff_rot"] = Vector3(lerp(-25.0, 65.0, s), 0.0, 0.0)
		
		p["left_arm_rot"] = Vector3(lerp(-110.0, -20.0, s), 0.0, -35.0)
		p["left_forearm_rot"] = Vector3(-55.0, 0.0, 0.0)
		
		# Deep stance absorb
		p["left_thigh_rot"] = Vector3(lerp(-6.0, -24.0, s), 0.0, -8.0)
		p["left_shin_rot"] = Vector3(lerp(12.0, 36.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(4.0, 16.0, s), 0.0, 8.0)
		p["right_shin_rot"] = Vector3(lerp(10.0, 32.0, s), 0.0, 0.0)
		
	elif tau < 0.85:
		# TOTEM CHANNELING & COMMAND (0.44s - 1.23s): Outstretch left hand channeling magic
		var _s = smoothstep(0.0, 1.0, (tau - 0.44) / 0.41)
		var shake = sin(t_s * 45.0) * 0.8
		p["hips_pos"] = Vector3(0.0, ground_hips_y - 0.03, 0.08)
		p["hips_rot"] = Vector3(8.0, 0.0, 0.0)
		p["torso_rot"] = Vector3(14.0 + shake, 0.0, 0.0)
		p["head_rot"] = Vector3(-4.0, 0.0, 0.0)
		
		# Staff holding ground
		p["right_arm_rot"] = Vector3(-25.0, 0.0, 12.0)
		p["right_forearm_rot"] = Vector3(-65.0, 0.0, 0.0)
		p["staff_rot"] = Vector3(65.0, 0.0, 0.0)
		
		# Left arm commanding Totem
		p["left_arm_rot"] = Vector3(-85.0 + shake, 0.0, -15.0)
		p["left_forearm_rot"] = Vector3(-15.0, 0.0, 0.0)
		
		p["left_thigh_rot"] = Vector3(-16.0, 0.0, -6.0)
		p["left_shin_rot"] = Vector3(26.0, 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(10.0, 0.0, 6.0)
		p["right_shin_rot"] = Vector3(22.0, 0.0, 0.0)
		
	else:
		# RECOVERY (0.85s - 1.45s): Rise back to stance
		var s = smoothstep(0.0, 1.0, (tau - 0.85) / 0.15)
		p["hips_pos"] = Vector3(0.0, lerp(ground_hips_y - 0.03, ground_hips_y, s), lerp(0.08, 0.0, s))
		p["hips_rot"] = Vector3(lerp(8.0, 0.0, s), 0.0, 0.0)
		p["torso_rot"] = Vector3(lerp(14.0, 6.0, s), 0.0, 0.0)
		p["head_rot"] = Vector3(lerp(-4.0, 0.0, s), 0.0, 0.0)
		
		p["right_arm_rot"] = _lerp_angles(Vector3(-25.0, 0.0, 12.0), base_r_arm, s)
		p["right_forearm_rot"] = _lerp_angles(Vector3(-65.0, 0.0, 0.0), base_r_fore, s)
		p["staff_rot"] = _lerp_angles(Vector3(65.0, 0.0, 0.0), base_staff, s)
		
		p["left_arm_rot"] = _lerp_angles(Vector3(-85.0, 0.0, -15.0), base_l_arm, s)
		p["left_forearm_rot"] = _lerp_angles(Vector3(-15.0, 0.0, 0.0), base_l_fore, s)
		
		p["left_thigh_rot"] = Vector3(lerp(-16.0, -4.0, s), 0.0, -3.0)
		p["left_shin_rot"] = Vector3(lerp(26.0, 6.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(10.0, 4.0, s), 0.0, 3.0)
		p["right_shin_rot"] = Vector3(lerp(22.0, 4.0, s), 0.0, 0.0)
		
	return p

# --- 6. HEX BOLT (Spear Thrust Cast) ---
func _compute_hex(t_h: float) -> Dictionary:
	var p: Dictionary = {}
	var tau = clampf(t_h / HEX_DURATION, 0.0, 1.0)
	var cfg = stance_configs.get(current_stance, default_stance_configs.get(current_stance, {}))
	var base_staff: Vector3 = cfg.get("staff_rot", Vector3(12.0, 0.0, -8.0))
	var base_r_arm: Vector3 = cfg.get("right_arm_rot", Vector3(-12.0, 6.0, 18.0))
	var base_r_fore: Vector3 = cfg.get("right_forearm_rot", Vector3(-35.0, 0.0, 0.0))
	var base_l_arm: Vector3 = cfg.get("left_arm_rot", Vector3(-25.0, 15.0, -26.0))
	var base_l_fore: Vector3 = cfg.get("left_forearm_rot", Vector3(-65.0, 0.0, 0.0))
	
	if tau < 0.35:
		# Pull staff back like spear
		var s = smoothstep(0.0, 1.0, tau / 0.35)
		p["hips_pos"] = Vector3(0.0, ground_hips_y, lerp(0.0, -0.06, s))
		p["hips_rot"] = Vector3(0.0, lerp(0.0, 25.0, s), 0.0)
		p["torso_rot"] = Vector3(lerp(6.0, 2.0, s), lerp(0.0, 20.0, s), 0.0)
		p["head_rot"] = Vector3(0.0, lerp(0.0, -30.0, s), 0.0)
		
		p["right_arm_rot"] = _lerp_angles(base_r_arm, Vector3(-30.0, 35.0, 55.0), s)
		p["right_forearm_rot"] = _lerp_angles(base_r_fore, Vector3(-110.0, 0.0, 0.0), s)
		p["staff_rot"] = _lerp_angles(base_staff, Vector3(75.0, 0.0, 0.0), s)
		
		p["left_arm_rot"] = Vector3(-65.0, -20.0, -15.0)
		p["left_forearm_rot"] = Vector3(-20.0, 0.0, 0.0)
		
		p["left_thigh_rot"] = Vector3(-12.0, 0.0, -4.0)
		p["left_shin_rot"] = Vector3(18.0, 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(8.0, 0.0, 4.0)
		p["right_shin_rot"] = Vector3(12.0, 0.0, 0.0)
	elif tau < 0.55:
		# Violent forward thrust
		var s = smoothstep(0.0, 1.0, (tau - 0.35) / 0.20)
		p["hips_pos"] = Vector3(0.0, ground_hips_y, lerp(-0.06, 0.12, s))
		p["hips_rot"] = Vector3(0.0, lerp(25.0, -15.0, s), 0.0)
		p["torso_rot"] = Vector3(12.0, lerp(20.0, -22.0, s), 0.0)
		p["head_rot"] = Vector3(-6.0, lerp(-30.0, 15.0, s), 0.0)
		
		# Staff thrust forward
		p["right_arm_rot"] = Vector3(lerp(-30.0, -88.0, s), lerp(35.0, -15.0, s), lerp(55.0, 10.0, s))
		p["right_forearm_rot"] = Vector3(lerp(-110.0, -8.0, s), 0.0, 0.0)
		p["staff_rot"] = Vector3(lerp(75.0, 85.0, s), 0.0, 0.0)
		
		p["left_arm_rot"] = Vector3(25.0, 0.0, -25.0)
		p["left_forearm_rot"] = Vector3(-35.0, 0.0, 0.0)
		
		p["left_thigh_rot"] = Vector3(lerp(-12.0, -25.0, s), 0.0, -4.0)
		p["left_shin_rot"] = Vector3(lerp(18.0, 32.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(8.0, 14.0, s), 0.0, 4.0)
		p["right_shin_rot"] = Vector3(lerp(12.0, 20.0, s), 0.0, 0.0)
	else:
		# Follow through and recover
		var s = smoothstep(0.0, 1.0, (tau - 0.55) / 0.45)
		p["hips_pos"] = Vector3(0.0, ground_hips_y, lerp(0.12, 0.0, s))
		p["hips_rot"] = Vector3(0.0, lerp(-15.0, 0.0, s), 0.0)
		p["torso_rot"] = Vector3(lerp(12.0, 6.0, s), lerp(-22.0, 0.0, s), 0.0)
		p["head_rot"] = Vector3(lerp(-6.0, 0.0, s), lerp(15.0, 0.0, s), 0.0)
		
		p["right_arm_rot"] = _lerp_angles(Vector3(-88.0, -15.0, 10.0), base_r_arm, s)
		p["right_forearm_rot"] = _lerp_angles(Vector3(-8.0, 0.0, 0.0), base_r_fore, s)
		p["staff_rot"] = _lerp_angles(Vector3(85.0, 0.0, 0.0), base_staff, s)
		
		p["left_arm_rot"] = _lerp_angles(Vector3(25.0, 0.0, -25.0), base_l_arm, s)
		p["left_forearm_rot"] = _lerp_angles(Vector3(-35.0, 0.0, 0.0), base_l_fore, s)
		
		p["left_thigh_rot"] = Vector3(lerp(-25.0, -4.0, s), 0.0, -3.0)
		p["left_shin_rot"] = Vector3(lerp(32.0, 6.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(14.0, 4.0, s), 0.0, 3.0)
		p["right_shin_rot"] = Vector3(lerp(20.0, 4.0, s), 0.0, 0.0)
	return p

# --- 7. HURT ---
func _compute_hurt(t_h: float) -> Dictionary:
	var p: Dictionary = {}
	var tau = clampf(t_h / HURT_DURATION, 0.0, 1.0)
	var s = sin(tau * PI)
	var cfg = stance_configs.get(current_stance, default_stance_configs.get(current_stance, {}))
	var base_staff: Vector3 = cfg.get("staff_rot", Vector3(12.0, 0.0, -8.0))
	var base_r_arm: Vector3 = cfg.get("right_arm_rot", Vector3(-12.0, 6.0, 18.0))
	
	p["hips_pos"] = Vector3(0.0, ground_hips_y - s * 0.04, -s * 0.14)
	p["hips_rot"] = Vector3(-s * 12.0, s * 6.0, 0.0)
	p["torso_rot"] = Vector3(-s * 25.0, -s * 14.0, 0.0)
	p["head_rot"] = Vector3(s * 20.0, -s * 16.0, 0.0)
	
	p["right_arm_rot"] = base_r_arm + Vector3(-s * 40.0, 0.0, s * 25.0)
	p["right_forearm_rot"] = Vector3(-55.0 - s * 20.0, 0.0, 0.0)
	p["staff_rot"] = base_staff + Vector3(s * 10.0, 0.0, 0.0)
	
	p["left_arm_rot"] = Vector3(s * 20.0, 0.0, -35.0)
	p["left_forearm_rot"] = Vector3(-45.0, 0.0, 0.0)
	
	p["left_thigh_rot"] = Vector3(-s * 16.0, 0.0, -6.0)
	p["left_shin_rot"] = Vector3(s * 28.0, 0.0, 0.0)
	p["right_thigh_rot"] = Vector3(s * 12.0, 0.0, 6.0)
	p["right_shin_rot"] = Vector3(s * 22.0, 0.0, 0.0)
	return p

# --- 8. STUNNED ---
func _compute_stunned(time_val: float) -> Dictionary:
	var p: Dictionary = {}
	var t = time_val * 2.8
	var cfg = stance_configs.get(current_stance, default_stance_configs.get(current_stance, {}))
	var base_staff: Vector3 = cfg.get("staff_rot", Vector3(12.0, 0.0, -8.0))
	var base_r_arm: Vector3 = cfg.get("right_arm_rot", Vector3(-12.0, 6.0, 18.0))
	var base_r_fore: Vector3 = cfg.get("right_forearm_rot", Vector3(-35.0, 0.0, 0.0))
	
	p["hips_pos"] = Vector3(sin(t) * 0.03, ground_hips_y - 0.035, cos(t) * 0.024)
	p["hips_rot"] = Vector3(cos(t) * 3.0, sin(t) * 8.0, -sin(t) * 4.0)
	p["torso_rot"] = Vector3(12.0 + sin(t) * 8.0, cos(t) * 14.0, sin(t) * 7.0)
	p["head_rot"] = Vector3(-8.0 + cos(t * 1.4) * 12.0, -sin(t) * 18.0, cos(t * 0.8) * 15.0)
	
	# Staff dangling limply
	p["right_arm_rot"] = base_r_arm + Vector3(sin(t) * 8.0, 0.0, 0.0)
	p["right_forearm_rot"] = base_r_fore
	p["staff_rot"] = base_staff + Vector3(25.0 + cos(t) * 6.0, 0.0, 0.0)
	
	p["left_arm_rot"] = Vector3(12.0 - sin(t) * 8.0, 0.0, -18.0)
	p["left_forearm_rot"] = Vector3(-15.0, 0.0, 0.0)
	
	p["left_thigh_rot"] = Vector3(-14.0 + sin(t) * 5.0, 0.0, -4.0)
	p["left_shin_rot"] = Vector3(22.0 + cos(t) * 6.0, 0.0, 0.0)
	p["right_thigh_rot"] = Vector3(10.0 - sin(t) * 5.0, 0.0, 4.0)
	p["right_shin_rot"] = Vector3(16.0 - cos(t) * 6.0, 0.0, 0.0)
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
	if p.has("staff_rot"): staff.rotation_degrees = p["staff_rot"]
	
	if p.has("left_thigh_rot"): left_thigh.rotation_degrees = p["left_thigh_rot"]
	if p.has("left_shin_rot"): left_shin.rotation_degrees = p["left_shin_rot"]
	if p.has("right_thigh_rot"): right_thigh.rotation_degrees = p["right_thigh_rot"]
	if p.has("right_shin_rot"): right_shin.rotation_degrees = p["right_shin_rot"]
