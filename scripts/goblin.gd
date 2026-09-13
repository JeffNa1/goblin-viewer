class_name Goblin
extends Node3D

@onready var hips: Node3D = $VisualRoot/Hips
@onready var torso: Node3D = $VisualRoot/Hips/Torso
@onready var head: Node3D = $VisualRoot/Hips/Torso/Head
@onready var left_arm: Node3D = $VisualRoot/Hips/Torso/LeftArm
@onready var left_forearm: Node3D = $VisualRoot/Hips/Torso/LeftArm/LeftForearm
@onready var right_arm: Node3D = $VisualRoot/Hips/Torso/RightArm
@onready var right_forearm: Node3D = $VisualRoot/Hips/Torso/RightArm/RightForearm
@onready var club: Node3D = $VisualRoot/Hips/Torso/RightArm/RightForearm/Club
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
@onready var club_mesh: MeshInstance3D = $VisualRoot/Hips/Torso/RightArm/RightForearm/Club/ClubMesh
@onready var left_thigh_mesh: MeshInstance3D = $VisualRoot/Hips/LeftThigh/LeftThighMesh
@onready var left_shin_mesh: MeshInstance3D = $VisualRoot/Hips/LeftThigh/LeftShin/LeftShinMesh
@onready var right_thigh_mesh: MeshInstance3D = $VisualRoot/Hips/RightThigh/RightThighMesh
@onready var right_shin_mesh: MeshInstance3D = $VisualRoot/Hips/RightThigh/RightShin/RightShinMesh

# State
var current_anim: String = "idle" # "idle", "walk", "run", "smash", "cleave"
var base_anim: String = "idle"
var current_stance: String = "low" # "low", "guard", "shoulder"
var anim_time: float = 0.0
var anim_speed: float = 1.0

# Attack
var attack_time: float = 0.0
const ATTACK_DURATION: float = 1.3
const COMBO_DURATION: float = 3.0
const PARRY_DURATION: float = 1.15
var parry_time: float = 0.0
var combo_impact_step: int = 0

# Continuous Cross-fade Blending
var is_blending: bool = false
var blend_timer: float = 0.0
const BLEND_DURATION: float = 0.25

var source_pose: Dictionary = {}
var current_pose: Dictionary = {}

# Stance Config & Ground Height (Loaded from stance_config.json)
var ground_hips_y: float = 0.618
var default_stance_configs: Dictionary = {}
var stance_configs: Dictionary = {}

# Weapon Trail & Impact FX
const WeaponTrailScript = preload("res://scripts/weapon_trail.gd")
const StunStarsScript = preload("res://scripts/stun_stars.gd")
var stun_stars: Node3D = null
var weapon_trail: Node3D = null
var smash_impact_triggered: bool = false

# Outfit System
var current_outfit: int = 1
var outfit_meshes: Dictionary = {}
signal outfit_changed(outfit_id: int)

signal anim_changed(anim_name: String)

func _ready() -> void:
	generate_voxel_meshes()
	_init_default_stances()
	load_stance_config()
	current_pose = _compute_pose("idle", 0.0, current_stance)
	_apply_pose(current_pose)
	_init_weapon_trail()
	_init_stun_stars()

func _init_default_stances() -> void:
	default_stance_configs = {
		"idle": {
			"right_arm_rot": Vector3(12.0, -8.0, 26.0),
			"right_forearm_rot": Vector3(-22.0, -8.0, 0.0),
			"club_rot": Vector3(118.0, -15.0, -12.0),
			"left_arm_rot": Vector3(0.0, 0.0, -12.0),
			"left_forearm_rot": Vector3(-16.0, 0.0, 0.0),
			"torso_rot": Vector3(7.0, 0.0, 0.0),
			"head_rot": Vector3(-2.0, 0.0, 0.0)
		},
		"walk": {
			"right_arm_rot": Vector3(12.0, -8.0, 26.0),
			"right_forearm_rot": Vector3(-22.0, -8.0, 0.0),
			"club_rot": Vector3(118.0, -15.0, -12.0),
			"left_arm_rot": Vector3(0.0, 0.0, -12.0),
			"left_forearm_rot": Vector3(-16.0, 0.0, 0.0),
			"torso_rot": Vector3(8.0, 0.0, 0.0),
			"head_rot": Vector3(-3.0, 0.0, 0.0)
		},
		"run": {
			"right_arm_rot": Vector3(-20.0, 10.0, 30.0),
			"right_forearm_rot": Vector3(-45.0, 0.0, 0.0),
			"club_rot": Vector3(118.0, -15.0, -12.0),
			"left_arm_rot": Vector3(0.0, 0.0, -12.0),
			"left_forearm_rot": Vector3(-20.0, 0.0, 0.0),
			"torso_rot": Vector3(24.0, 0.0, 0.0),
			"head_rot": Vector3(-14.0, 0.0, 0.0)
		},
		"smash": {
			"right_arm_rot": Vector3(-85.0, 25.0, 56.0),
			"right_forearm_rot": Vector3(-115.0, 15.0, 0.0),
			"club_rot": Vector3(20.0, 25.0, -25.0),
			"left_arm_rot": Vector3(-45.0, 0.0, -36.0),
			"left_forearm_rot": Vector3(-55.0, 0.0, 0.0),
			"torso_rot": Vector3(-28.0, 0.0, 0.0),
			"head_rot": Vector3(4.0, 0.0, 0.0)
		},
		"cleave": {
			"right_arm_rot": Vector3(18.0, 10.0, 75.0),
			"right_forearm_rot": Vector3(-35.0, 0.0, 20.0),
			"club_rot": Vector3(85.0, 30.0, 20.0),
			"left_arm_rot": Vector3(-40.0, 0.0, 15.0),
			"left_forearm_rot": Vector3(-55.0, 0.0, 0.0),
			"torso_rot": Vector3(8.0, 52.0, 4.0),
			"head_rot": Vector3(-4.0, -32.0, 0.0)
		},
		"parry_smash": {
			"right_arm_rot": Vector3(-85.0, 25.0, 56.0),
			"right_forearm_rot": Vector3(-115.0, 15.0, 0.0),
			"club_rot": Vector3(20.0, 25.0, -25.0),
			"left_arm_rot": Vector3(-45.0, 0.0, -36.0),
			"left_forearm_rot": Vector3(-55.0, 0.0, 0.0),
			"torso_rot": Vector3(-28.0, 0.0, 0.0),
			"head_rot": Vector3(4.0, 0.0, 0.0)
		},
		"parry_cleave": {
			"right_arm_rot": Vector3(-70.0, 0.0, -18.0),
			"right_forearm_rot": Vector3(-15.0, 0.0, 0.0),
			"club_rot": Vector3(90.0, 0.0, -75.0),
			"left_arm_rot": Vector3(32.0, 0.0, -20.0),
			"left_forearm_rot": Vector3(-80.0, 0.0, 0.0),
			"torso_rot": Vector3(14.0, -68.0, -6.0),
			"head_rot": Vector3(6.0, 28.0, 0.0)
		},
		"stunned": {
			"right_arm_rot": Vector3(0.0, 5.0, 42.0),
			"right_forearm_rot": Vector3(-45.0, 0.0, 0.0),
			"club_rot": Vector3(75.0, 0.0, -20.0),
			"left_arm_rot": Vector3(12.0, 0.0, -24.0),
			"left_forearm_rot": Vector3(-35.0, 0.0, 0.0),
			"torso_rot": Vector3(14.0, 0.0, 5.0),
			"head_rot": Vector3(8.0, 0.0, 0.0)
		},
		"low": {
			"right_arm_rot": Vector3(12.0, -8.0, 26.0),
			"right_forearm_rot": Vector3(-22.0, -8.0, 0.0),
			"club_rot": Vector3(118.0, -15.0, -12.0),
			"left_arm_rot": Vector3(0.0, 0.0, -12.0),
			"left_forearm_rot": Vector3(-16.0, 0.0, 0.0)
		},
		"guard": {
			"right_arm_rot": Vector3(-28.0, -12.0, 20.0),
			"right_forearm_rot": Vector3(-76.0, 15.0, -5.0),
			"club_rot": Vector3(165.0, 35.0, -35.0),
			"left_arm_rot": Vector3(-32.0, 24.0, -18.0),
			"left_forearm_rot": Vector3(-78.0, -15.0, 10.0)
		},
		"shoulder": {
			"right_arm_rot": Vector3(-20.0, 15.0, 42.0),
			"right_forearm_rot": Vector3(-110.0, 10.0, 0.0),
			"club_rot": Vector3(50.0, 25.0, -20.0),
			"left_arm_rot": Vector3(0.0, 0.0, -12.0),
			"left_forearm_rot": Vector3(-16.0, 0.0, 0.0)
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
				if d.has("warrior") and d["warrior"] is Dictionary:
					d = d["warrior"]
				if d.has("ground_hips_y"):
					ground_hips_y = float(d["ground_hips_y"])
				for s_key in d:
					if s_key == "ground_hips_y":
						continue
					if d[s_key] is Dictionary:
						var s_dict = d[s_key]
						if not stance_configs.has(s_key):
							stance_configs[s_key] = {}
						for prop in ["right_arm_rot", "right_forearm_rot", "club_rot", "left_arm_rot", "left_forearm_rot", "torso_rot", "head_rot"]:
							if s_dict.has(prop) and s_dict[prop] is Array and s_dict[prop].size() == 3:
								stance_configs[s_key][prop] = Vector3(float(s_dict[prop][0]), float(s_dict[prop][1]), float(s_dict[prop][2]))

func get_stance_definitions() -> Array:
	return [
		{"id": "idle", "name": "Idle", "shortcut": "[ 1 ]"},
		{"id": "walk", "name": "Walk", "shortcut": "[ 2 ]"},
		{"id": "run", "name": "Run", "shortcut": "[ 3 ]"},
		{"id": "smash", "name": "Smash", "shortcut": "[ 4 ]"},
		{"id": "cleave", "name": "Cleave", "shortcut": "[ 5 ]"},
		{"id": "parry_smash", "name": "Đỡ Smash", "shortcut": "[ 6 ]"},
		{"id": "parry_cleave", "name": "Đỡ Chém", "shortcut": "[ 7 ]"},
		{"id": "stunned", "name": "Choáng", "shortcut": "[ 8 ]"}
	]

func get_weapon_info() -> Dictionary:
	var title = "🏏 CHÙY GAI (VỊ TRÍ & GÓC)"
	if current_outfit == 2:
		title = "🔨 THIẾT CHÙY CHIẾN TRẬN (VỊ TRÍ & GÓC)"
	elif current_outfit == 3:
		title = "👑 HOÀNG KIM THẦN CHÙY (VỊ TRÍ & GÓC)"
	return {
		"title": title,
		"prop": "club_rot"
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
	all_cfg["warrior"] = serialize_stances()
	
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
	for k in ["right_arm_rot", "right_forearm_rot", "club_rot", "left_arm_rot", "left_forearm_rot", "torso_rot", "head_rot"]:
		var v: Vector3 = s.get(k, Vector3.ZERO)
		out[k] = [snappedf(v.x, 0.1), snappedf(v.y, 0.1), snappedf(v.z, 0.1)]
	return out

func copy_weapon_from_idle(target_anim: String) -> void:
	var idle_cfg = stance_configs.get("idle", default_stance_configs.get("idle", {}))
	if not stance_configs.has(target_anim):
		stance_configs[target_anim] = default_stance_configs.get(target_anim, {}).duplicate()
	if idle_cfg.has("club_rot"):
		stance_configs[target_anim]["club_rot"] = idle_cfg["club_rot"]
	current_pose = _compute_pose(current_anim, anim_time, current_stance)
	_apply_pose(current_pose)

func reset_stance_to_default(s_name: String) -> void:
	if default_stance_configs.has(s_name):
		stance_configs[s_name] = default_stance_configs[s_name].duplicate()
		if current_stance == s_name:
			current_pose = _compute_pose(current_anim, anim_time, current_stance)
			_apply_pose(current_pose)

func update_live_stance(s_name: String, prop: String, val: Variant) -> void:
	if not stance_configs.has(s_name):
		stance_configs[s_name] = {}
	stance_configs[s_name][prop] = val
	current_pose = _compute_pose(current_anim, anim_time, current_stance)
	_apply_pose(current_pose)

func update_live_stance_arm(s_name: String, prop: String, val: Vector3) -> void:
	update_live_stance(s_name, prop, val)

func set_live_ground_hips_y(val: float) -> void:
	ground_hips_y = val
	if current_anim in ["idle", "walk", "run"]:
		current_pose = _compute_pose(current_anim, anim_time, current_stance)
		_apply_pose(current_pose)

func generate_voxel_meshes() -> void:
	# Pre-build meshes for Outfit 1 (Thô Sơ / Primitive Feral Warrior)
	outfit_meshes[1] = {
		"head": VoxelBuilder.build_head_mesh(1),
		"torso": VoxelBuilder.build_torso_mesh(1),
		"upper_arm": VoxelBuilder.build_upper_arm_mesh(1),
		"left_forearm": VoxelBuilder.build_forearm_mesh(false, 1),
		"right_forearm": VoxelBuilder.build_forearm_mesh(true, 1),
		"club": VoxelBuilder.build_club_mesh(1),
		"thigh": VoxelBuilder.build_thigh_mesh(1),
		"shin": VoxelBuilder.build_shin_mesh(1)
	}
	
	# Pre-build meshes for Outfit 2 (Chiến Binh Thép / Ironclad Battle Warrior)
	outfit_meshes[2] = {
		"head": VoxelBuilder.build_head_mesh(2),
		"torso": VoxelBuilder.build_torso_mesh(2),
		"upper_arm": VoxelBuilder.build_upper_arm_mesh(2),
		"left_forearm": VoxelBuilder.build_forearm_mesh(false, 2),
		"right_forearm": VoxelBuilder.build_forearm_mesh(true, 2),
		"club": VoxelBuilder.build_club_mesh(2),
		"thigh": VoxelBuilder.build_thigh_mesh(2),
		"shin": VoxelBuilder.build_shin_mesh(2)
	}
	
	# Pre-build meshes for Outfit 3 (Chiến Tướng Hoàng Kim / Imperial Golden Sovereign)
	outfit_meshes[3] = {
		"head": VoxelBuilder.build_head_mesh(3),
		"torso": VoxelBuilder.build_torso_mesh(3),
		"upper_arm": VoxelBuilder.build_upper_arm_mesh(3),
		"left_forearm": VoxelBuilder.build_forearm_mesh(false, 3),
		"right_forearm": VoxelBuilder.build_forearm_mesh(true, 3),
		"club": VoxelBuilder.build_club_mesh(3),
		"thigh": VoxelBuilder.build_thigh_mesh(3),
		"shin": VoxelBuilder.build_shin_mesh(3)
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
	left_arm_mesh.mesh = m["upper_arm"]
	left_forearm_mesh.mesh = m["left_forearm"]
	right_arm_mesh.mesh = m["upper_arm"]
	right_forearm_mesh.mesh = m["right_forearm"]
	club_mesh.mesh = m["club"]
	left_thigh_mesh.mesh = m["thigh"]
	left_shin_mesh.mesh = m["shin"]
	right_thigh_mesh.mesh = m["thigh"]
	right_shin_mesh.mesh = m["shin"]

func _process(delta: float) -> void:
	var dt = delta * anim_speed
	anim_time += dt
	
	if current_anim in ["smash", "cleave"]:
		attack_time += dt
		_update_attack_trails(attack_time)
		var cur_attack_dur: float = COMBO_DURATION if (current_anim == "smash" and current_outfit in [2, 3]) else ATTACK_DURATION
		if attack_time >= cur_attack_dur:
			if weapon_trail:
				weapon_trail.stop_trail()
			current_anim = base_anim
			anim_time = 0.0
			attack_time = 0.0
			_start_blend()
			emit_signal("anim_changed", current_anim)
	elif current_anim in ["parry_smash", "parry_cleave"]:
		parry_time += dt
		if weapon_trail and weapon_trail.is_emitting:
			weapon_trail.stop_trail()
		if parry_time >= PARRY_DURATION:
			current_anim = base_anim
			anim_time = 0.0
			parry_time = 0.0
			_start_blend()
			emit_signal("anim_changed", current_anim)
	else:
		if weapon_trail and weapon_trail.is_emitting:
			weapon_trail.stop_trail()
	
	if stun_stars:
		stun_stars.set_active(current_anim == "stunned")
	
	var target_pose = _compute_pose(current_anim, anim_time, current_stance)
	
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

func _init_weapon_trail() -> void:
	weapon_trail = WeaponTrailScript.new()
	weapon_trail.name = "WeaponTrail"
	# Attach to VisualRoot so it transforms in world space independently of club rotation
	$VisualRoot.add_child(weapon_trail)
	weapon_trail.set_target(club)

func _update_attack_trails(t_atk: float) -> void:
	if not weapon_trail:
		return
		
	if current_anim == "smash":
		if current_outfit == 3:
			_update_imperial_combo_trails(t_atk)
			return
		elif current_outfit == 2:
			_update_combo_trails(t_atk)
			return
			
		var tau = clampf(t_atk / ATTACK_DURATION, 0.0, 1.0)
		# Violent slam phase: tau in [0.32, 0.50]
		if tau >= 0.32 and tau < 0.50:
			if not weapon_trail.is_emitting:
				weapon_trail.start_trail(
					Color(1.0, 0.95, 0.50, 0.98), # Brilliant Solar Gold tip
					Color(1.0, 0.35, 0.05, 0.88), # Heavy Molten Crimson base
					0.18 # Snappy, high-velocity vertical arc
				)
		elif tau >= 0.50 and tau < 0.56:
			if weapon_trail.is_emitting:
				weapon_trail.stop_trail()
			if not smash_impact_triggered:
				smash_impact_triggered = true
				# Club tip contacts ground at X ~ 0.08, Y ~ 0.038, Z ~ 0.38
				var impact_pos = club.to_global(Vector3(0.0, 0.88, 0.0))
				impact_pos.y = 0.038
				weapon_trail.trigger_ground_impact(impact_pos)
		else:
			if weapon_trail.is_emitting:
				weapon_trail.stop_trail()
				
	elif current_anim == "cleave":
		var tau = clampf(t_atk / ATTACK_DURATION, 0.0, 1.0)
		# Full 180° horizontal cleave: tau in [0.35, 0.60]
		if tau >= 0.35 and tau < 0.60:
			if not weapon_trail.is_emitting:
				weapon_trail.start_trail(
					Color(1.0, 1.0, 0.82, 0.98), # Radiant Celestial White-Gold tip
					Color(1.0, 0.62, 0.15, 0.82), # Warm Amber Wind Blade base
					0.28 # Long sprawling 180° crescent ribbon
				)
		else:
			if weapon_trail.is_emitting:
				weapon_trail.stop_trail()

func _update_combo_trails(t_atk: float) -> void:
	if not weapon_trail:
		return
		
	# Hit 1: Overhead Slam (0.32s -> 0.50s)
	if t_atk >= 0.32 and t_atk < 0.50:
		if not weapon_trail.is_emitting:
			weapon_trail.start_trail(
				Color(1.0, 0.95, 0.50, 0.98), # Brilliant Solar Gold tip
				Color(1.0, 0.35, 0.05, 0.88), # Heavy Molten Crimson base
				0.18
			)
	elif t_atk >= 0.50 and t_atk < 0.60:
		if weapon_trail.is_emitting:
			weapon_trail.stop_trail()
		if combo_impact_step == 0:
			combo_impact_step = 1
			var impact_pos = club.to_global(Vector3(0.0, 0.88, 0.0))
			impact_pos.y = 0.038
			weapon_trail.trigger_ground_impact(impact_pos)
	# Hit 2: 180° Horizontal Cleave (0.95s -> 1.35s)
	elif t_atk >= 0.95 and t_atk < 1.35:
		if not weapon_trail.is_emitting:
			weapon_trail.start_trail(
				Color(1.0, 1.0, 0.85, 0.98), # Radiant White-Gold tip
				Color(1.0, 0.60, 0.15, 0.85), # Warm Amber Wind Blade base
				0.26
			)
	# Hit 3: Explosive Reverse Cleave (Left -> Right, 1.75s -> 2.20s)
	elif t_atk >= 1.75 and t_atk < 2.20:
		if not weapon_trail.is_emitting:
			weapon_trail.start_trail(
				Color(0.70, 0.95, 1.0, 1.0), # Crystal Ice-Cyan tip
				Color(1.0, 0.45, 0.10, 0.88), # Radiant Molten Solar base
				0.28
			)
		if t_atk >= 2.00 and combo_impact_step == 1:
			combo_impact_step = 2
			var impact_pos = club.to_global(Vector3(0.0, 0.88, 0.0))
			impact_pos.y = 0.038
			weapon_trail.trigger_ground_impact(impact_pos)
	else:
		if weapon_trail.is_emitting:
			weapon_trail.stop_trail()

func _update_imperial_combo_trails(t_atk: float) -> void:
	if not weapon_trail:
		return
		
	# Hit 1: Imperial Overhead Slam (0.32s -> 0.50s) - Blinding Pure Sun Gold Arc
	if t_atk >= 0.32 and t_atk < 0.50:
		if not weapon_trail.is_emitting:
			weapon_trail.start_trail(
				Color(1.0, 0.98, 0.65, 1.0), # Diamond-bright Sun Gold tip
				Color(1.0, 0.60, 0.05, 0.95), # Radiant Molten Amber base
				0.20
			)
	elif t_atk >= 0.50 and t_atk < 0.60:
		if weapon_trail.is_emitting:
			weapon_trail.stop_trail()
		if combo_impact_step == 0:
			combo_impact_step = 1
			var impact_pos = club.to_global(Vector3(0.0, 0.88, 0.0))
			impact_pos.y = 0.038
			weapon_trail.trigger_ground_impact(impact_pos)
	# Hit 2: 180° Horizontal Cleave (0.95s -> 1.35s) - Imperial Ruby-Gold Crescent Ribbon
	elif t_atk >= 0.95 and t_atk < 1.35:
		if not weapon_trail.is_emitting:
			weapon_trail.start_trail(
				Color(1.0, 0.40, 0.65, 1.0), # Radiant Imperial Ruby tip
				Color(0.95, 0.10, 0.30, 0.90), # Deep Royal Velvet Crimson base
				0.28
			)
	# Hit 3: Explosive Reverse Cleave (Left -> Right, 1.75s -> 2.20s) - Divine Solar Starburst
	elif t_atk >= 1.75 and t_atk < 2.20:
		if not weapon_trail.is_emitting:
			weapon_trail.start_trail(
				Color(1.0, 1.0, 0.95, 1.0), # Celestial Diamond Light tip
				Color(1.0, 0.82, 0.15, 0.98), # Pure Sunburst Divine Gold base
				0.30
			)
		if t_atk >= 2.00 and combo_impact_step == 1:
			combo_impact_step = 2
			var impact_pos = club.to_global(Vector3(0.0, 0.88, 0.0))
			impact_pos.y = 0.038
			weapon_trail.trigger_ground_impact(impact_pos)
	else:
		if weapon_trail.is_emitting:
			weapon_trail.stop_trail()

func _start_blend() -> void:
	source_pose = current_pose.duplicate()
	blend_timer = 0.0
	is_blending = true

func play_anim(anim_name: String) -> void:
	if current_anim == anim_name and not is_blending:
		return
		
	if anim_name in ["smash", "cleave"]:
		if not (current_anim in ["smash", "cleave", "parry_smash", "parry_cleave"]):
			base_anim = current_anim
		attack_time = 0.0
		smash_impact_triggered = false
		combo_impact_step = 0
	elif anim_name in ["parry_smash", "parry_cleave"]:
		if not (current_anim in ["smash", "cleave", "parry_smash", "parry_cleave"]):
			base_anim = current_anim
		parry_time = 0.0
		if weapon_trail:
			weapon_trail.stop_trail()
	else:
		base_anim = anim_name
		
	current_anim = anim_name
	anim_time = 0.0
	_start_blend()
	emit_signal("anim_changed", current_anim)

func set_stance(stance_name: String) -> void:
	if current_stance == stance_name:
		return
	current_stance = stance_name
	_start_blend()

func set_speed(speed: float) -> void:
	anim_speed = speed

# --- POSE INTERPOLATION ---
func _lerp_angles(a: Vector3, b: Vector3, weight: float) -> Vector3:
	return Vector3(
		rad_to_deg(lerp_angle(deg_to_rad(a.x), deg_to_rad(b.x), weight)),
		rad_to_deg(lerp_angle(deg_to_rad(a.y), deg_to_rad(b.y), weight)),
		rad_to_deg(lerp_angle(deg_to_rad(a.z), deg_to_rad(b.z), weight))
	)

func _blend_poses(p_from: Dictionary, p_to: Dictionary, weight: float) -> Dictionary:
	var res: Dictionary = {}
	res["hips_pos"] = p_from.get("hips_pos", Vector3(0, ground_hips_y, 0)).lerp(p_to["hips_pos"], weight)
	res["hips_rot"] = _lerp_angles(p_from.get("hips_rot", Vector3.ZERO), p_to["hips_rot"], weight)
	
	var rot_keys = [
		"torso_rot", "head_rot",
		"left_arm_rot", "left_forearm_rot",
		"right_arm_rot", "right_forearm_rot", "club_rot",
		"left_thigh_rot", "left_shin_rot",
		"right_thigh_rot", "right_shin_rot"
	]
	
	for k in rot_keys:
		var v_from = p_from.get(k, Vector3.ZERO)
		var v_to = p_to.get(k, Vector3.ZERO)
		res[k] = _lerp_angles(v_from, v_to, weight)
		
	return res

func _apply_pose(p: Dictionary) -> void:
	hips.position = p.get("hips_pos", Vector3(0, ground_hips_y, 0))
	hips.rotation_degrees = p.get("hips_rot", Vector3.ZERO)
	torso.rotation_degrees = p.get("torso_rot", Vector3.ZERO)
	head.rotation_degrees = p.get("head_rot", Vector3.ZERO)
	left_arm.rotation_degrees = p.get("left_arm_rot", Vector3.ZERO)
	left_forearm.rotation_degrees = p.get("left_forearm_rot", Vector3.ZERO)
	right_arm.rotation_degrees = p.get("right_arm_rot", Vector3.ZERO)
	right_forearm.rotation_degrees = p.get("right_forearm_rot", Vector3.ZERO)
	club.rotation_degrees = p.get("club_rot", Vector3.ZERO)
	left_thigh.rotation_degrees = p.get("left_thigh_rot", Vector3.ZERO)
	left_shin.rotation_degrees = p.get("left_shin_rot", Vector3.ZERO)
	right_thigh.rotation_degrees = p.get("right_thigh_rot", Vector3.ZERO)
	right_shin.rotation_degrees = p.get("right_shin_rot", Vector3.ZERO)

# --- POSE CALCULATION ---
func _compute_pose(anim: String, time_val: float, stance: String) -> Dictionary:
	var p: Dictionary = {}
	p["hips_rot"] = Vector3.ZERO
	
	if anim == "idle":
		var t = time_val * 3.14
		var cfg = stance_configs.get(stance, default_stance_configs.get(stance, {}))
		var base_torso: Vector3 = cfg.get("torso_rot", Vector3(7.0, 0.0, 0.0))
		var base_head: Vector3 = cfg.get("head_rot", Vector3(-2.0, 0.0, 0.0))
		
		p["hips_pos"] = Vector3(0.0, ground_hips_y + sin(t) * 0.008, 0.0)
		p["torso_rot"] = base_torso + Vector3(sin(t) * 1.5, 0.0, 0.0)
		p["head_rot"] = base_head + Vector3(sin(t * 0.8) * 2.5, sin(t * 0.5) * 7.0, cos(t * 0.5) * 2.5)
		
		p["left_thigh_rot"] = Vector3(-2.0, 0.0, 0.0)
		p["left_shin_rot"] = Vector3(4.0, 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(1.0, 0.0, 0.0)
		p["right_shin_rot"] = Vector3(3.0, 0.0, 0.0)
		
		var w = _compute_stance_arms(t, stance, "idle")
		p["left_arm_rot"] = w["left_arm_rot"]
		p["left_forearm_rot"] = w["left_forearm_rot"]
		p["right_arm_rot"] = w["right_arm_rot"]
		p["right_forearm_rot"] = w["right_forearm_rot"]
		p["club_rot"] = w["club_rot"]
		
		if stance == "guard":
			p["hips_pos"] = Vector3(0.0, ground_hips_y - 0.02 + sin(t) * 0.006, 0.0)
			p["left_thigh_rot"] = Vector3(-12.0, 0.0, -8.0)
			p["left_shin_rot"] = Vector3(22.0, 0.0, 0.0)
			p["right_thigh_rot"] = Vector3(8.0, 0.0, 8.0)
			p["right_shin_rot"] = Vector3(16.0, 0.0, 0.0)
		
	elif anim == "walk":
		var t = time_val * 4.8
		p["hips_pos"] = Vector3(0.0, ground_hips_y - cos(2.0 * t) * 0.020, 0.0)
		p["torso_rot"] = Vector3(8.0 + cos(2.0 * t) * 1.5, sin(t) * 4.5, sin(t) * 2.2)
		p["head_rot"] = Vector3(-3.0, -sin(t) * 3.5, -sin(t) * 1.5)
		
		var thigh_l = -cos(t) * 24.0
		var stance_l = pow(max(0.0, cos(t - 0.25 * PI)), 2.0)
		var swing_l = pow(max(0.0, cos(t - 1.35 * PI)), 1.8)
		p["left_thigh_rot"] = Vector3(thigh_l, 0.0, 0.0)
		p["left_shin_rot"] = Vector3(5.0 + stance_l * 8.0 + swing_l * 42.0, 0.0, 0.0)
		
		var t_r = t + PI
		var thigh_r = -cos(t_r) * 24.0
		var stance_r = pow(max(0.0, cos(t_r - 0.25 * PI)), 2.0)
		var swing_r = pow(max(0.0, cos(t_r - 1.35 * PI)), 1.8)
		p["right_thigh_rot"] = Vector3(thigh_r, 0.0, 0.0)
		p["right_shin_rot"] = Vector3(5.0 + stance_r * 8.0 + swing_r * 42.0, 0.0, 0.0)
		
		var w = _compute_stance_arms(t, stance, "walk")
		p["left_arm_rot"] = w["left_arm_rot"]
		p["left_forearm_rot"] = w["left_forearm_rot"]
		p["right_arm_rot"] = w["right_arm_rot"]
		p["right_forearm_rot"] = w["right_forearm_rot"]
		p["club_rot"] = w["club_rot"]
		
		if stance == "guard":
			p["torso_rot"] = Vector3(12.0 + cos(2.0 * t) * 1.5, -10.0 + sin(t) * 2.0, 0.0)
			p["head_rot"] = Vector3(-5.0, 8.0 - sin(t) * 2.0, 0.0)
		
	elif anim == "run":
		var t = time_val * 9.2
		p["hips_pos"] = Vector3(0.0, ground_hips_y + abs(sin(t)) * 0.055 - 0.025, 0.0)
		p["torso_rot"] = Vector3(24.0 + cos(2.0 * t) * 3.0, sin(t) * 10.0, cos(t) * 3.0)
		p["head_rot"] = Vector3(-14.0, -sin(t) * 4.0, 0.0)
		
		var thigh_l = -cos(t) * 36.0
		var stance_l = pow(max(0.0, cos(t - 0.9)), 2.0) * 18.0
		var rear_kick_l = pow(max(0.0, cos(t - PI)), 2.0) * 60.0
		var knee_drive_l = pow(max(0.0, cos(t - 4.52)), 2.0) * 68.0
		p["left_thigh_rot"] = Vector3(thigh_l, 0.0, 0.0)
		p["left_shin_rot"] = Vector3(8.0 + stance_l + max(rear_kick_l, knee_drive_l), 0.0, 0.0)
		
		var t_r = t + PI
		var thigh_r = -cos(t_r) * 36.0
		var stance_r = pow(max(0.0, cos(t_r - 0.9)), 2.0) * 18.0
		var rear_kick_r = pow(max(0.0, cos(t_r - PI)), 2.0) * 60.0
		var knee_drive_r = pow(max(0.0, cos(t_r - 4.52)), 2.0) * 68.0
		p["right_thigh_rot"] = Vector3(thigh_r, 0.0, 0.0)
		p["right_shin_rot"] = Vector3(8.0 + stance_r + max(rear_kick_r, knee_drive_r), 0.0, 0.0)
		
		var w = _compute_stance_arms(t, stance, "run")
		p["left_arm_rot"] = w["left_arm_rot"]
		p["left_forearm_rot"] = w["left_forearm_rot"]
		p["right_arm_rot"] = w["right_arm_rot"]
		p["right_forearm_rot"] = w["right_forearm_rot"]
		p["club_rot"] = w["club_rot"]
		
	elif anim == "smash":
		if current_outfit in [2, 3]:
			p = _compute_attack_smash_combo(attack_time)
		else:
			p = _compute_attack_smash(attack_time)
	elif anim == "cleave":
		p = _compute_attack_cleave(attack_time)
	elif anim == "parry_smash":
		p = _compute_parry_smash(parry_time)
	elif anim == "parry_cleave":
		p = _compute_parry_cleave(parry_time)
	elif anim == "stunned":
		p = _compute_stunned(time_val, stance)
		
	return p

func _init_stun_stars() -> void:
	stun_stars = StunStarsScript.new()
	stun_stars.name = "StunStarsFX"
	head.add_child(stun_stars)

# --- 4. PARRY REACTION: SMASH (Deflected Upward, Violent Backward Recoil & Stumble) ---
func _compute_parry_smash(t_p: float) -> Dictionary:
	var p: Dictionary = {}
	var tau = clampf(t_p / PARRY_DURATION, 0.0, 1.0)
	var key = "parry_smash" if stance_configs.has("parry_smash") else current_stance
	var cfg = stance_configs.get(key, default_stance_configs.get(key, default_stance_configs.get(current_stance, {})))
	var base_club: Vector3 = cfg.get("club_rot", Vector3(80.0, 0.0, -20.0))
	var base_r_arm: Vector3 = cfg.get("right_arm_rot", Vector3(0.0, 0.0, 20.0))
	var base_r_fore: Vector3 = cfg.get("right_forearm_rot", Vector3(-30.0, 0.0, 0.0))
	var base_l_arm: Vector3 = cfg.get("left_arm_rot", Vector3(0.0, 0.0, -12.0))
	var base_l_fore: Vector3 = cfg.get("left_forearm_rot", Vector3(-16.0, 0.0, 0.0))
	
	if tau < 0.20:
		# PHASE 1: Violent Deflection Impact (0.0s - 0.23s) - Weapon knocked high up, chest arches in shock!
		var s = sin((tau / 0.20) * 0.5 * PI)
		# Hips jerk backward
		p["hips_pos"] = Vector3(0.0, lerp(ground_hips_y, ground_hips_y - 0.02, s), lerp(0.08, -0.06, s))
		p["hips_rot"] = Vector3(lerp(0.0, -8.0, s), lerp(0.0, -4.0, s), 0.0)
		p["torso_rot"] = Vector3(lerp(12.0, -28.0, s), lerp(0.0, -8.0, s), 0.0) # Chest blown open!
		p["head_rot"] = Vector3(lerp(4.0, -26.0, s), -4.0, 0.0) # Head snaps back in shock
		
		# Right arm and club kicked violently upward and back
		p["right_arm_rot"] = _lerp_angles(base_r_arm, Vector3(-85.0, 25.0, 56.0), s)
		p["right_forearm_rot"] = _lerp_angles(base_r_fore, Vector3(-115.0, 15.0, 0.0), s)
		p["club_rot"] = _lerp_angles(base_club, Vector3(20.0, 25.0, -25.0), s)
		
		# Left arm flails back in surprise
		p["left_arm_rot"] = _lerp_angles(base_l_arm, Vector3(-45.0, 0.0, -36.0), s)
		p["left_forearm_rot"] = _lerp_angles(base_l_fore, Vector3(-55.0, 0.0, 0.0), s)
		
		# Legs brace against the sudden backward shock
		p["left_thigh_rot"] = Vector3(lerp(-15.0, -24.0, s), 0.0, 0.0)
		p["left_shin_rot"] = Vector3(lerp(25.0, 36.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(10.0, 8.0, s), 0.0, 4.0)
		p["right_shin_rot"] = Vector3(lerp(12.0, 16.0, s), 0.0, 0.0)
		
	elif tau < 0.60:
		# PHASE 2: Heavy Stumble Backward (0.23s - 0.69s) - Reeling back to catch footing
		var prog = (tau - 0.20) / 0.40
		var s = smoothstep(0.0, 1.0, prog)
		
		# Hips stumble back in -Z (-0.06m -> -0.18m) and drop low (-0.05m)
		p["hips_pos"] = Vector3(0.0, lerp(ground_hips_y - 0.02, ground_hips_y - 0.05, s), lerp(-0.06, -0.18, s))
		p["hips_rot"] = Vector3(lerp(-8.0, 4.0, s), lerp(-4.0, 0.0, s), 0.0)
		p["torso_rot"] = Vector3(lerp(-28.0, 14.0, s), lerp(-8.0, 0.0, s), 0.0)
		p["head_rot"] = Vector3(lerp(-26.0, 8.0, s), 0.0, 0.0)
		
		# Right leg steps back frantically
		p["right_thigh_rot"] = Vector3(lerp(8.0, 24.0, s), 0.0, 4.0)
		p["right_shin_rot"] = Vector3(lerp(16.0, 28.0, s), 0.0, 0.0)
		p["left_thigh_rot"] = Vector3(lerp(-24.0, -8.0, s), 0.0, -4.0)
		p["left_shin_rot"] = Vector3(lerp(36.0, 16.0, s), 0.0, 0.0)
		
		# Arms flailing outward to balance
		p["left_arm_rot"] = Vector3(lerp(-45.0, 12.0, s), 0.0, lerp(-36.0, -24.0, s))
		p["left_forearm_rot"] = Vector3(lerp(-55.0, -35.0, s), 0.0, 0.0)
		
		p["right_arm_rot"] = Vector3(lerp(-85.0, 0.0, s), lerp(25.0, 5.0, s), lerp(56.0, 42.0, s))
		p["right_forearm_rot"] = Vector3(lerp(-115.0, -45.0, s), 0.0, 0.0)
		p["club_rot"] = Vector3(lerp(20.0, 75.0, s), 0.0, -20.0)
		
	else:
		# PHASE 3: Regroup & Return to Stance (0.69s - 1.15s)
		var prog = (tau - 0.60) / 0.40
		var s = smoothstep(0.0, 1.0, prog)
		
		p["hips_pos"] = Vector3(0.0, lerp(ground_hips_y - 0.05, ground_hips_y, s), lerp(-0.18, 0.0, s))
		p["hips_rot"] = Vector3(lerp(4.0, 0.0, s), 0.0, 0.0)
		p["torso_rot"] = Vector3(lerp(14.0, 7.0, s), 0.0, 0.0)
		p["head_rot"] = Vector3(lerp(8.0, -2.0, s), 0.0, 0.0)
		
		p["left_thigh_rot"] = Vector3(lerp(-8.0, -2.0, s), 0.0, lerp(-4.0, 0.0, s))
		p["left_shin_rot"] = Vector3(lerp(16.0, 4.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(24.0, 1.0, s), 0.0, lerp(4.0, 0.0, s))
		p["right_shin_rot"] = Vector3(lerp(28.0, 3.0, s), 0.0, 0.0)
		
		var w_target = _compute_stance_arms(0.0, current_stance, "idle")
		p["left_arm_rot"] = _lerp_angles(Vector3(12.0, 0.0, -24.0), w_target["left_arm_rot"], s)
		p["left_forearm_rot"] = _lerp_angles(Vector3(-35.0, 0.0, 0.0), w_target["left_forearm_rot"], s)
		p["right_arm_rot"] = _lerp_angles(Vector3(0.0, 5.0, 42.0), w_target["right_arm_rot"], s)
		p["right_forearm_rot"] = _lerp_angles(Vector3(-45.0, 0.0, 0.0), w_target["right_forearm_rot"], s)
		p["club_rot"] = _lerp_angles(Vector3(75.0, 0.0, -20.0), w_target["club_rot"], s)
		
	return p

# --- 5. PARRY REACTION: CLEAVE (Deflected Horizontally, Violent Torque Ricochet & Lateral Stumble) ---
func _compute_parry_cleave(t_p: float) -> Dictionary:
	var p: Dictionary = {}
	var tau = clampf(t_p / PARRY_DURATION, 0.0, 1.0)
	var key = "parry_cleave" if stance_configs.has("parry_cleave") else current_stance
	var cfg = stance_configs.get(key, default_stance_configs.get(key, default_stance_configs.get(current_stance, {})))
	var base_club: Vector3 = cfg.get("club_rot", Vector3(90.0, 0.0, -60.0))
	var base_r_arm: Vector3 = cfg.get("right_arm_rot", Vector3(-50.0, 0.0, -18.0))
	var base_r_fore: Vector3 = cfg.get("right_forearm_rot", Vector3(-15.0, 0.0, 0.0))
	var base_l_arm: Vector3 = cfg.get("left_arm_rot", Vector3(25.0, 0.0, -20.0))
	var base_l_fore: Vector3 = cfg.get("left_forearm_rot", Vector3(-70.0, 0.0, 0.0))
	
	if tau < 0.20:
		# PHASE 1: Violent Horizontal Ricochet (0.0s - 0.23s) - Club bounces off shield to the right!
		var s = sin((tau / 0.20) * 0.5 * PI)
		p["hips_pos"] = Vector3(lerp(0.0, 0.05, s), ground_hips_y - 0.02, lerp(0.0, -0.04, s))
		p["hips_rot"] = Vector3(0.0, lerp(-20.0, 16.0, s), 0.0)
		p["torso_rot"] = Vector3(lerp(10.0, 4.0, s), lerp(-45.0, 32.0, s), lerp(-4.0, 8.0, s)) # Torso torqued clockwise!
		p["head_rot"] = Vector3(lerp(4.0, -6.0, s), lerp(20.0, -28.0, s), 0.0) # Head snaps away
		
		# Right arm bounces sharply back to the right (+Rz)
		p["right_arm_rot"] = _lerp_angles(base_r_arm, Vector3(-10.0, 15.0, 68.0), s)
		p["right_forearm_rot"] = _lerp_angles(base_r_fore, Vector3(-45.0, 0.0, 0.0), s)
		p["club_rot"] = _lerp_angles(base_club, Vector3(70.0, 0.0, 40.0), s)
		
		p["left_arm_rot"] = _lerp_angles(base_l_arm, Vector3(-20.0, 0.0, -32.0), s)
		p["left_forearm_rot"] = _lerp_angles(base_l_fore, Vector3(-30.0, 0.0, 0.0), s)
		
		p["left_thigh_rot"] = Vector3(lerp(8.0, -12.0, s), 0.0, -8.0)
		p["left_shin_rot"] = Vector3(lerp(18.0, 24.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(-12.0, 14.0, s), 0.0, 12.0)
		p["right_shin_rot"] = Vector3(lerp(28.0, 22.0, s), 0.0, 0.0)
		
	elif tau < 0.60:
		# PHASE 2: Lateral Stumble & Off-Axis Spin (0.23s - 0.69s)
		var prog = (tau - 0.20) / 0.40
		var s = smoothstep(0.0, 1.0, prog)
		
		p["hips_pos"] = Vector3(lerp(0.05, 0.14, s), lerp(ground_hips_y - 0.02, ground_hips_y - 0.04, s), lerp(-0.04, -0.10, s))
		p["hips_rot"] = Vector3(0.0, lerp(16.0, 6.0, s), 0.0)
		p["torso_rot"] = Vector3(lerp(4.0, 12.0, s), lerp(32.0, 8.0, s), lerp(8.0, -4.0, s))
		p["head_rot"] = Vector3(lerp(-6.0, 4.0, s), lerp(-28.0, 10.0, s), 0.0)
		
		# Right foot hops out to prevent falling sideways
		p["right_thigh_rot"] = Vector3(lerp(14.0, 6.0, s), 0.0, lerp(12.0, 14.0, s))
		p["right_shin_rot"] = Vector3(lerp(22.0, 28.0, s), 0.0, 0.0)
		p["left_thigh_rot"] = Vector3(lerp(-12.0, -8.0, s), 0.0, -6.0)
		p["left_shin_rot"] = Vector3(lerp(24.0, 16.0, s), 0.0, 0.0)
		
		p["left_arm_rot"] = Vector3(lerp(-20.0, 10.0, s), 0.0, lerp(-32.0, -20.0, s))
		p["left_forearm_rot"] = Vector3(lerp(-30.0, -25.0, s), 0.0, 0.0)
		
		p["right_arm_rot"] = Vector3(lerp(-10.0, 8.0, s), lerp(15.0, -5.0, s), lerp(68.0, 36.0, s))
		p["right_forearm_rot"] = Vector3(lerp(-45.0, -30.0, s), 0.0, 0.0)
		p["club_rot"] = Vector3(lerp(70.0, 110.0, s), 0.0, lerp(40.0, -10.0, s))
		
	else:
		# PHASE 3: Re-center & Recover to Stance (0.69s - 1.15s)
		var prog = (tau - 0.60) / 0.40
		var s = smoothstep(0.0, 1.0, prog)
		
		p["hips_pos"] = Vector3(lerp(0.14, 0.0, s), lerp(ground_hips_y - 0.04, ground_hips_y, s), lerp(-0.10, 0.0, s))
		p["hips_rot"] = Vector3(0.0, lerp(6.0, 0.0, s), 0.0)
		p["torso_rot"] = Vector3(lerp(12.0, 7.0, s), lerp(8.0, 0.0, s), lerp(-4.0, 0.0, s))
		p["head_rot"] = Vector3(lerp(4.0, -2.0, s), lerp(10.0, 0.0, s), 0.0)
		
		p["left_thigh_rot"] = Vector3(lerp(-8.0, -2.0, s), 0.0, lerp(-6.0, 0.0, s))
		p["left_shin_rot"] = Vector3(lerp(16.0, 4.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(6.0, 1.0, s), 0.0, lerp(14.0, 0.0, s))
		p["right_shin_rot"] = Vector3(lerp(28.0, 3.0, s), 0.0, 0.0)
		
		var w_target = _compute_stance_arms(0.0, current_stance, "idle")
		p["left_arm_rot"] = _lerp_angles(Vector3(10.0, 0.0, -20.0), w_target["left_arm_rot"], s)
		p["left_forearm_rot"] = _lerp_angles(Vector3(-25.0, 0.0, 0.0), w_target["left_forearm_rot"], s)
		p["right_arm_rot"] = _lerp_angles(Vector3(8.0, -5.0, 36.0), w_target["right_arm_rot"], s)
		p["right_forearm_rot"] = _lerp_angles(Vector3(-30.0, 0.0, 0.0), w_target["right_forearm_rot"], s)
		p["club_rot"] = _lerp_angles(Vector3(110.0, 0.0, -10.0), w_target["club_rot"], s)
		
	return p

# --- 6. STUNNED / DAZED (Drunken Spiral Sway, Buckling Knees, Limp Arms) ---
func _compute_stunned(time_val: float, stance: String) -> Dictionary:
	var p: Dictionary = {}
	var t = time_val * 2.8
	var key = "stunned" if stance_configs.has("stunned") else stance
	var cfg = stance_configs.get(key, default_stance_configs.get(key, default_stance_configs.get(stance, {})))
	var base_club: Vector3 = cfg.get("club_rot", Vector3(142.0, -10.0, -10.0))
	var base_r_arm: Vector3 = cfg.get("right_arm_rot", Vector3(14.0, -4.0, 16.0))
	var base_r_fore: Vector3 = cfg.get("right_forearm_rot", Vector3(-10.0, 0.0, 0.0))
	var base_l_arm: Vector3 = cfg.get("left_arm_rot", Vector3(0.0, 0.0, -14.0))
	var base_l_fore: Vector3 = cfg.get("left_forearm_rot", Vector3(-12.0, 0.0, 0.0))
	
	# Hips: slow 3D drunken circular wobble
	p["hips_pos"] = Vector3(
		sin(t) * 0.032,
		ground_hips_y - 0.035 + abs(sin(t * 2.0)) * 0.012,
		cos(t) * 0.026
	)
	p["hips_rot"] = Vector3(cos(t) * 3.0, sin(t) * 8.0, -sin(t) * 4.0)
	
	# Torso: slow wobbly spiral tilt
	p["torso_rot"] = Vector3(
		12.0 + sin(t) * 8.0,
		cos(t) * 14.0,
		sin(t) * 7.0
	)
	
	# Head: dazed, nodding drunkenly, tilting to sides
	p["head_rot"] = Vector3(
		-8.0 + cos(t * 1.4) * 12.0,
		-sin(t) * 18.0,
		cos(t * 0.8) * 15.0
	)
	
	# Legs: knees buckled inward, shifting weight clumsily
	p["left_thigh_rot"] = Vector3(-14.0 + sin(t) * 5.0, 0.0, -4.0 + cos(t) * 2.0)
	p["left_shin_rot"] = Vector3(22.0 + cos(t) * 6.0, 0.0, 0.0)
	p["right_thigh_rot"] = Vector3(10.0 - sin(t) * 5.0, 0.0, 4.0 - cos(t) * 2.0)
	p["right_shin_rot"] = Vector3(16.0 - cos(t) * 6.0, 0.0, 0.0)
	
	# Arms: limp, dangling loosely, club dragging near ground
	var sway = sin(t) * 6.0
	p["right_arm_rot"] = base_r_arm + Vector3(sway, 0.0, cos(t) * 4.0)
	p["right_forearm_rot"] = base_r_fore + Vector3(sway * 0.5, 0.0, 0.0)
	p["club_rot"] = base_club + Vector3(cos(t) * 6.0, 0.0, 0.0)
	
	p["left_arm_rot"] = base_l_arm + Vector3(-sway, 0.0, -cos(t) * 5.0)
	p["left_forearm_rot"] = base_l_fore
	
	return p

# --- 1. OVERHEAD SMASH (Aggressive Forward-Step Lunge Slam, Zero Splay, Solid Hit-Stop) ---
func _compute_attack_smash(t_atk: float) -> Dictionary:
	var p: Dictionary = {}
	var tau = clampf(t_atk / ATTACK_DURATION, 0.0, 1.0)
	
	if tau < 0.35:
		# PHASE 1: Windup & Stride Forward (0.0s - 0.45s)
		# Goblin raises spiked club high overhead while lifting LEFT leg and striding boldly forward (+Z)
		var s = smoothstep(0.0, 1.0, tau / 0.35)
		var key = "smash" if stance_configs.has("smash") else current_stance
		var cfg = stance_configs.get(key, default_stance_configs.get(key, default_stance_configs.get(current_stance, {})))
		var base_club: Vector3 = cfg.get("club_rot", Vector3(118.0, 26.0, -20.0))
		var base_r_arm: Vector3 = cfg.get("right_arm_rot", Vector3(12.0, -8.0, 26.0))
		var base_r_fore: Vector3 = cfg.get("right_forearm_rot", Vector3(-22.0, 0.0, 0.0))
		var base_l_arm: Vector3 = cfg.get("left_arm_rot", Vector3(0.0, 0.0, -18.0))
		var base_l_fore: Vector3 = cfg.get("left_forearm_rot", Vector3(-16.0, 0.0, 0.0))
		
		# Hips drive forward (+Z from 0.0 to 0.10m) and rise slightly (+0.03m) as front leg strides
		p["hips_pos"] = Vector3(0.0, lerp(ground_hips_y, ground_hips_y + 0.03, s), lerp(0.0, 0.10, s))
		p["hips_rot"] = Vector3(lerp(0.0, -4.0, s), lerp(0.0, -6.0, s), 0.0)
		p["torso_rot"] = Vector3(lerp(7.0, -24.0, s), lerp(0.0, -10.0, s), 0.0)
		p["head_rot"] = Vector3(lerp(-2.0, -18.0, s), 2.0, 0.0)
		
		# LEFT LEG (STRIDING LEG): Lifts knee and swings foot forward to step! (Zero sideways splay: Rz = 0)
		p["left_thigh_rot"] = Vector3(lerp(-2.0, -32.0, s), 0.0, 0.0)
		p["left_shin_rot"] = Vector3(lerp(4.0, 42.0, s), 0.0, 0.0)
		
		# RIGHT LEG (REAR PLANT LEG): Braces on ground, pushing body forward (Zero sideways splay: Rz = +2)
		p["right_thigh_rot"] = Vector3(lerp(1.0, 16.0, s), 0.0, 2.0)
		p["right_shin_rot"] = Vector3(lerp(3.0, 10.0, s), 0.0, 0.0)
		
		# Left arm reaches out forward for balance and target acquisition
		p["left_arm_rot"] = _lerp_angles(base_l_arm, Vector3(-52.0, 0.0, -18.0), s)
		p["left_forearm_rot"] = _lerp_angles(base_l_fore, Vector3(-45.0, 0.0, 0.0), s)
		
		# Right arm cocks spiked club high over right shoulder
		p["right_arm_rot"] = _lerp_angles(base_r_arm, Vector3(-96.0, 18.0, 42.0), s)
		p["right_forearm_rot"] = _lerp_angles(base_r_fore, Vector3(-120.0, 15.0, 0.0), s)
		p["club_rot"] = _lerp_angles(base_club, Vector3(26.0, 25.0, -20.0), s)
		
	elif tau < 0.50:
		# PHASE 2: Violent Forward Lunge Slam (0.45s - 0.65s)
		# Left foot slams down into a deep forward combat lunge, body crunches forward, club strikes earth!
		var prog = (tau - 0.35) / 0.15
		var s = sin(prog * 0.5 * PI)
		
		# Hips plunge forward (+Z to 0.16m) and sink deep into lunge (Y -0.04m)
		p["hips_pos"] = Vector3(0.0, lerp(ground_hips_y + 0.03, ground_hips_y - 0.04, s), lerp(0.10, 0.16, s))
		p["hips_rot"] = Vector3(lerp(-4.0, 6.0, s), lerp(-6.0, 2.0, s), 0.0)
		p["torso_rot"] = Vector3(lerp(-24.0, 32.0, s), lerp(-10.0, 4.0, s), 0.0)
		p["head_rot"] = Vector3(lerp(-18.0, 16.0, s), 3.0, 0.0)
		
		# LEFT LEG (FORWARD LUNGE LEG): Plants forward firmly, knee bent 90° over foot, solid base!
		p["left_thigh_rot"] = Vector3(lerp(-32.0, -36.0, s), 0.0, -2.0)
		p["left_shin_rot"] = Vector3(lerp(42.0, 44.0, s), 0.0, 0.0)
		
		# RIGHT LEG (REAR ANCHOR LEG): Extends back to brace the forward momentum
		p["right_thigh_rot"] = Vector3(lerp(16.0, 24.0, s), 0.0, 3.0)
		p["right_shin_rot"] = Vector3(lerp(10.0, 18.0, s), 0.0, 0.0)
		
		# Left arm swings down and back to counterbalance the massive forward blow
		p["left_arm_rot"] = Vector3(lerp(-52.0, 30.0, s), 0.0, -12.0)
		p["left_forearm_rot"] = Vector3(lerp(-45.0, -72.0, s), 0.0, 0.0)
		
		# Right arm and spiked club smash downward, stopping flush on ground (Y = +0.038m)
		p["right_arm_rot"] = Vector3(lerp(-96.0, 32.0, s), lerp(18.0, -10.0, s), lerp(42.0, 14.0, s))
		p["right_forearm_rot"] = Vector3(lerp(-120.0, -18.0, s), 0.0, 0.0)
		p["club_rot"] = Vector3(lerp(26.0, 138.0, s), -10.0, -10.0)
		
	elif tau < 0.56:
		# PHASE 3: Crisp Hit-Stop Freeze (0.65s - 0.73s) - 80ms locked in deep forward combat lunge
		p["hips_pos"] = Vector3(0.0, ground_hips_y - 0.04, 0.16)
		p["hips_rot"] = Vector3(6.0, 2.0, 0.0)
		p["torso_rot"] = Vector3(32.0, 4.0, 0.0)
		p["head_rot"] = Vector3(16.0, 3.0, 0.0)
		
		p["left_thigh_rot"] = Vector3(-36.0, 0.0, -2.0)
		p["left_shin_rot"] = Vector3(44.0, 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(24.0, 0.0, 3.0)
		p["right_shin_rot"] = Vector3(18.0, 0.0, 0.0)
		
		p["left_arm_rot"] = Vector3(30.0, 0.0, -12.0)
		p["left_forearm_rot"] = Vector3(-72.0, 0.0, 0.0)
		
		p["right_arm_rot"] = Vector3(32.0, -10.0, 14.0)
		p["right_forearm_rot"] = Vector3(-18.0, 0.0, 0.0)
		p["club_rot"] = Vector3(138.0, -10.0, -10.0)
		
	else:
		# PHASE 4: Fluid Rise & Step-Back to Stance (0.73s - 1.30s)
		# Front foot pushes off ground, hips step smoothly back to origin (Z: 0.16m -> 0.0m)
		var prog = (tau - 0.56) / 0.44
		var s = smoothstep(0.0, 1.0, prog)
		
		p["hips_pos"] = Vector3(0.0, lerp(ground_hips_y - 0.04, ground_hips_y, s), lerp(0.16, 0.0, s))
		p["hips_rot"] = Vector3(lerp(6.0, 0.0, s), lerp(2.0, 0.0, s), 0.0)
		p["torso_rot"] = Vector3(lerp(32.0, 7.0, s), lerp(4.0, 0.0, s), 0.0)
		p["head_rot"] = Vector3(lerp(16.0, -2.0, s), 0.0, 0.0)
		
		# Left leg pushes back into ready stance
		p["left_thigh_rot"] = Vector3(lerp(-36.0, -2.0, s), 0.0, lerp(-2.0, 0.0, s))
		p["left_shin_rot"] = Vector3(lerp(44.0, 4.0, s), 0.0, 0.0)
		
		# Right leg steps back under center of mass
		p["right_thigh_rot"] = Vector3(lerp(24.0, 1.0, s), 0.0, lerp(3.0, 0.0, s))
		p["right_shin_rot"] = Vector3(lerp(18.0, 3.0, s), 0.0, 0.0)
		
		p["left_arm_rot"] = Vector3(lerp(30.0, 0.0, s), 0.0, lerp(-12.0, -12.0, s))
		p["left_forearm_rot"] = Vector3(lerp(-72.0, -16.0, s), 0.0, 0.0)
		
		var w_target = _compute_stance_arms(0.0, current_stance, "idle")
		p["right_arm_rot"] = _lerp_angles(Vector3(32.0, -10.0, 14.0), w_target["right_arm_rot"], s)
		p["right_forearm_rot"] = _lerp_angles(Vector3(-18.0, 0.0, 0.0), w_target["right_forearm_rot"], s)
		p["club_rot"] = _lerp_angles(Vector3(138.0, -10.0, -10.0), w_target["club_rot"], s)
		
	return p

# --- 1B. WARRIOR OUTFIT 2: COMBO 1-2-3 ATTACK (Smash -> Cleave -> Rising Uppercut Finisher) ---
func _compute_attack_smash_combo(t_atk: float) -> Dictionary:
	var p: Dictionary = {}
	var key = "smash" if stance_configs.has("smash") else current_stance
	var cfg = stance_configs.get(key, default_stance_configs.get(key, default_stance_configs.get(current_stance, {})))
	var base_club: Vector3 = cfg.get("club_rot", Vector3(118.0, 26.0, -20.0))
	var base_r_arm: Vector3 = cfg.get("right_arm_rot", Vector3(12.0, -8.0, 26.0))
	var base_r_fore: Vector3 = cfg.get("right_forearm_rot", Vector3(-22.0, 0.0, 0.0))
	var base_l_arm: Vector3 = cfg.get("left_arm_rot", Vector3(0.0, 0.0, -18.0))
	var base_l_fore: Vector3 = cfg.get("left_forearm_rot", Vector3(-16.0, 0.0, 0.0))

	if t_atk < 0.35:
		# HIT 1 - PHASE 1A: Windup & Stride Forward (0.0s - 0.35s)
		var s = smoothstep(0.0, 1.0, t_atk / 0.35)
		p["hips_pos"] = Vector3(0.0, lerp(ground_hips_y, ground_hips_y + 0.03, s), lerp(0.0, 0.10, s))
		p["hips_rot"] = Vector3(lerp(0.0, -4.0, s), lerp(0.0, -6.0, s), 0.0)
		p["torso_rot"] = Vector3(lerp(7.0, -24.0, s), lerp(0.0, -10.0, s), 0.0)
		p["head_rot"] = Vector3(lerp(-2.0, -18.0, s), 2.0, 0.0)
		p["left_thigh_rot"] = Vector3(lerp(-2.0, -32.0, s), 0.0, 0.0)
		p["left_shin_rot"] = Vector3(lerp(4.0, 42.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(1.0, 16.0, s), 0.0, 2.0)
		p["right_shin_rot"] = Vector3(lerp(3.0, 10.0, s), 0.0, 0.0)
		p["left_arm_rot"] = _lerp_angles(base_l_arm, Vector3(-52.0, 0.0, -18.0), s)
		p["left_forearm_rot"] = _lerp_angles(base_l_fore, Vector3(-45.0, 0.0, 0.0), s)
		p["right_arm_rot"] = _lerp_angles(base_r_arm, Vector3(-96.0, 18.0, 42.0), s)
		p["right_forearm_rot"] = _lerp_angles(base_r_fore, Vector3(-120.0, 15.0, 0.0), s)
		p["club_rot"] = _lerp_angles(base_club, Vector3(26.0, 25.0, -20.0), s)

	elif t_atk < 0.50:
		# HIT 1 - PHASE 1B: Violent Forward Lunge Slam (0.35s - 0.50s)
		var prog = (t_atk - 0.35) / 0.15
		var s = sin(prog * 0.5 * PI)
		p["hips_pos"] = Vector3(0.0, lerp(ground_hips_y + 0.03, ground_hips_y - 0.04, s), lerp(0.10, 0.16, s))
		p["hips_rot"] = Vector3(lerp(-4.0, 6.0, s), lerp(-6.0, 2.0, s), 0.0)
		p["torso_rot"] = Vector3(lerp(-24.0, 32.0, s), lerp(-10.0, 4.0, s), 0.0)
		p["head_rot"] = Vector3(lerp(-18.0, 16.0, s), 3.0, 0.0)
		p["left_thigh_rot"] = Vector3(lerp(-32.0, -36.0, s), 0.0, -2.0)
		p["left_shin_rot"] = Vector3(lerp(42.0, 44.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(16.0, 24.0, s), 0.0, 3.0)
		p["right_shin_rot"] = Vector3(lerp(10.0, 18.0, s), 0.0, 0.0)
		p["left_arm_rot"] = Vector3(lerp(-52.0, 30.0, s), 0.0, -12.0)
		p["left_forearm_rot"] = Vector3(lerp(-45.0, -72.0, s), 0.0, 0.0)
		p["right_arm_rot"] = Vector3(lerp(-96.0, 32.0, s), lerp(18.0, -10.0, s), lerp(42.0, 14.0, s))
		p["right_forearm_rot"] = Vector3(lerp(-120.0, -18.0, s), 0.0, 0.0)
		p["club_rot"] = Vector3(lerp(26.0, 138.0, s), -10.0, -10.0)

	elif t_atk < 0.58:
		# HIT 1 - PHASE 1C: Hit-Stop & Ground Impact Tremble (0.50s - 0.58s)
		var shake = sin((t_atk - 0.50) * 80.0) * 0.003
		p["hips_pos"] = Vector3(0.0, ground_hips_y - 0.04 + shake, 0.16)
		p["hips_rot"] = Vector3(6.0, 2.0, 0.0)
		p["torso_rot"] = Vector3(32.0, 4.0, 0.0)
		p["head_rot"] = Vector3(16.0, 3.0, 0.0)
		p["left_thigh_rot"] = Vector3(-36.0, 0.0, -2.0)
		p["left_shin_rot"] = Vector3(44.0, 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(24.0, 0.0, 3.0)
		p["right_shin_rot"] = Vector3(18.0, 0.0, 0.0)
		p["left_arm_rot"] = Vector3(30.0, 0.0, -12.0)
		p["left_forearm_rot"] = Vector3(-72.0, 0.0, 0.0)
		p["right_arm_rot"] = Vector3(32.0, -10.0, 14.0)
		p["right_forearm_rot"] = Vector3(-18.0, 0.0, 0.0)
		p["club_rot"] = Vector3(138.0, -10.0, -10.0)

	elif t_atk < 0.70:
		# HIT 1 -> HIT 2: Pivot & Re-arm to Right Flank (0.58s - 0.70s)
		var prog = (t_atk - 0.58) / 0.12
		var s = smoothstep(0.0, 1.0, prog)
		p["hips_pos"] = Vector3(0.0, lerp(ground_hips_y - 0.04, ground_hips_y - 0.02, s), lerp(0.16, 0.10, s))
		p["hips_rot"] = Vector3(lerp(6.0, 0.0, s), lerp(2.0, 15.0, s), 0.0)
		p["torso_rot"] = Vector3(lerp(32.0, 12.0, s), lerp(4.0, 25.0, s), 0.0)
		p["head_rot"] = Vector3(lerp(16.0, 2.0, s), lerp(3.0, -15.0, s), 0.0)
		p["left_thigh_rot"] = Vector3(lerp(-36.0, -20.0, s), 0.0, lerp(-2.0, -8.0, s))
		p["left_shin_rot"] = Vector3(lerp(44.0, 26.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(24.0, 12.0, s), 0.0, lerp(3.0, 8.0, s))
		p["right_shin_rot"] = Vector3(lerp(18.0, 20.0, s), 0.0, 0.0)
		p["left_arm_rot"] = Vector3(lerp(30.0, -10.0, s), 0.0, lerp(-12.0, 0.0, s))
		p["left_forearm_rot"] = Vector3(lerp(-72.0, -45.0, s), 0.0, 0.0)
		p["right_arm_rot"] = Vector3(lerp(32.0, 20.0, s), lerp(-10.0, 5.0, s), lerp(14.0, 45.0, s))
		p["right_forearm_rot"] = Vector3(lerp(-18.0, -30.0, s), 0.0, 0.0)
		p["club_rot"] = Vector3(lerp(138.0, 100.0, s), lerp(-10.0, 10.0, s), lerp(-10.0, 0.0, s))

	elif t_atk < 0.95:
		# HIT 2 - PHASE 2A: Full Right Coil / Charge Cleave (0.70s - 0.95s)
		var prog = (t_atk - 0.70) / 0.25
		var s = smoothstep(0.0, 1.0, prog)
		p["hips_pos"] = Vector3(0.0, lerp(ground_hips_y - 0.02, ground_hips_y - 0.035, s), lerp(0.10, 0.04, s))
		p["hips_rot"] = Vector3(0.0, lerp(15.0, 36.0, s), 0.0)
		p["torso_rot"] = Vector3(lerp(12.0, 8.0, s), lerp(25.0, 56.0, s), lerp(0.0, 4.0, s))
		p["head_rot"] = Vector3(lerp(2.0, -4.0, s), lerp(-15.0, -36.0, s), 0.0)
		p["left_thigh_rot"] = Vector3(lerp(-20.0, -14.0, s), 0.0, lerp(-8.0, -14.0, s))
		p["left_shin_rot"] = Vector3(lerp(26.0, 20.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(12.0, 18.0, s), 0.0, lerp(8.0, 16.0, s))
		p["right_shin_rot"] = Vector3(lerp(20.0, 24.0, s), 0.0, 0.0)
		p["left_arm_rot"] = Vector3(lerp(-10.0, -42.0, s), 0.0, lerp(0.0, 15.0, s))
		p["left_forearm_rot"] = Vector3(lerp(-45.0, -55.0, s), 0.0, 0.0)
		p["right_arm_rot"] = Vector3(lerp(20.0, 18.0, s), lerp(5.0, 12.0, s), lerp(45.0, 78.0, s))
		p["right_forearm_rot"] = Vector3(lerp(-30.0, -35.0, s), 0.0, lerp(0.0, 20.0, s))
		p["club_rot"] = Vector3(lerp(100.0, 85.0, s), lerp(10.0, 30.0, s), lerp(0.0, 20.0, s))

	elif t_atk < 1.35:
		# HIT 2 - PHASE 2B: Explosive 180° Horizontal Cleave Across Front (0.95s - 1.35s)
		var prog = (t_atk - 0.95) / 0.40
		var s = 1.0 - pow(1.0 - prog, 2.8)
		p["hips_pos"] = Vector3(0.0, lerp(ground_hips_y - 0.035, ground_hips_y + 0.015, s), lerp(0.04, 0.08, s))
		p["hips_rot"] = Vector3(0.0, lerp(36.0, -42.0, s), 0.0)
		p["torso_rot"] = Vector3(lerp(8.0, 15.0, s), lerp(56.0, -70.0, s), lerp(4.0, -6.0, s))
		p["head_rot"] = Vector3(lerp(-4.0, 6.0, s), lerp(-36.0, 30.0, s), 0.0)
		p["left_thigh_rot"] = Vector3(lerp(-14.0, 12.0, s), 0.0, -14.0)
		p["left_shin_rot"] = Vector3(lerp(20.0, 14.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(18.0, -18.0, s), 0.0, 16.0)
		p["right_shin_rot"] = Vector3(lerp(24.0, 36.0, s), 0.0, 0.0)
		p["left_arm_rot"] = Vector3(lerp(-42.0, 32.0, s), 0.0, lerp(15.0, -20.0, s))
		p["left_forearm_rot"] = Vector3(lerp(-55.0, -80.0, s), 0.0, 0.0)
		p["right_arm_rot"] = Vector3(lerp(18.0, -72.0, s), lerp(12.0, 0.0, s), lerp(78.0, -20.0, s))
		p["right_forearm_rot"] = Vector3(lerp(-35.0, -15.0, s), 0.0, 0.0)
		p["club_rot"] = Vector3(lerp(85.0, 92.0, s), lerp(30.0, 0.0, s), lerp(20.0, -78.0, s))

	elif t_atk < 1.75:
		# HIT 2 -> HIT 3: Catch Heavy Inertia & Coil Reverse Slash on Left Flank (1.35s - 1.75s)
		var prog = (t_atk - 1.35) / 0.40
		var s = smoothstep(0.0, 1.0, prog)
		
		# Hips drop to load leg springs, weight transfers to left side (-X)
		p["hips_pos"] = Vector3(
			lerp(0.0, -0.03, s),
			lerp(ground_hips_y + 0.015, ground_hips_y - 0.035, s),
			lerp(0.08, 0.04, s)
		)
		p["hips_rot"] = Vector3(lerp(0.0, 4.0, s), lerp(-42.0, -48.0, s), 0.0)
		
		# Torso coils deeper into left flank (-70° -> -78°) with slight athletic crunch
		p["torso_rot"] = Vector3(lerp(15.0, 18.0, s), lerp(-70.0, -78.0, s), lerp(-6.0, -8.0, s))
		
		# Head anticipates attack: turns toward enemy in front-right
		p["head_rot"] = Vector3(lerp(6.0, 0.0, s), lerp(30.0, -18.0, s), 0.0)
		
		# Left leg absorbs heavy downward impact
		p["left_thigh_rot"] = Vector3(lerp(12.0, 18.0, s), 0.0, -14.0)
		p["left_shin_rot"] = Vector3(lerp(14.0, 24.0, s), 0.0, 0.0)
		
		# Right leg extends out to anchor
		p["right_thigh_rot"] = Vector3(lerp(-18.0, -24.0, s), 0.0, 16.0)
		p["right_shin_rot"] = Vector3(lerp(36.0, 42.0, s), 0.0, 0.0)
		
		# Left arm guards chest/core
		p["left_arm_rot"] = Vector3(lerp(32.0, -15.0, s), 0.0, lerp(-20.0, -25.0, s))
		p["left_forearm_rot"] = Vector3(lerp(-80.0, -45.0, s), 0.0, 0.0)
		
		# Right arm: Elbow flexes (-15° -> -52°), wrist cocks mace back along left flank (Z >= 0.38m, zero clipping!)
		p["right_arm_rot"] = Vector3(lerp(-72.0, -55.0, s), lerp(0.0, -12.0, s), lerp(-20.0, -32.0, s))
		p["right_forearm_rot"] = Vector3(lerp(-15.0, -52.0, s), 0.0, 0.0)
		p["club_rot"] = Vector3(lerp(92.0, 75.0, s), lerp(0.0, -25.0, s), lerp(-78.0, -95.0, s))

	elif t_atk < 2.20:
		# HIT 3 - PHASE 3B: Explosive Reverse Backhand Cleave (Left -> Right, 1.75s - 2.20s)
		var prog = (t_atk - 1.75) / 0.45
		var s = 1.0 - pow(1.0 - prog, 2.6)
		
		# Dynamic weight transfer: from left foot (-0.03m) surging forward & right (+0.04m, +0.10m Z)
		p["hips_pos"] = Vector3(
			lerp(-0.03, 0.04, s),
			lerp(ground_hips_y - 0.035, ground_hips_y + 0.015, s),
			lerp(0.04, 0.10, s)
		)
		p["hips_rot"] = Vector3(lerp(4.0, 0.0, s), lerp(-48.0, 36.0, s), 0.0)
		
		# Torso unleashes massive counter-rotational torque (-78° -> +58°)
		p["torso_rot"] = Vector3(lerp(18.0, 10.0, s), lerp(-78.0, 58.0, s), lerp(-8.0, 6.0, s))
		p["head_rot"] = Vector3(lerp(0.0, 4.0, s), lerp(-18.0, -30.0, s), 0.0)
		
		# Legs drive: left leg extends pushing forward, right leg plants on right side
		p["left_thigh_rot"] = Vector3(lerp(18.0, -14.0, s), 0.0, lerp(-14.0, -8.0, s))
		p["left_shin_rot"] = Vector3(lerp(24.0, 18.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(-24.0, 18.0, s), 0.0, lerp(16.0, 12.0, s))
		p["right_shin_rot"] = Vector3(lerp(42.0, 26.0, s), 0.0, 0.0)
		
		# Left arm whips backward to counterbalance torque
		p["left_arm_rot"] = Vector3(lerp(-15.0, 34.0, s), 0.0, lerp(-25.0, -18.0, s))
		p["left_forearm_rot"] = Vector3(lerp(-45.0, -72.0, s), 0.0, 0.0)
		
		# Right Arm & Forearm: Arm leads from left to right, elbow snaps open (-52° -> -14°) whipping the mace!
		p["right_arm_rot"] = Vector3(lerp(-55.0, 22.0, s), lerp(-12.0, 18.0, s), lerp(-32.0, 76.0, s))
		p["right_forearm_rot"] = Vector3(lerp(-52.0, -14.0, s), 0.0, lerp(0.0, 20.0, s))
		p["club_rot"] = Vector3(lerp(75.0, 95.0, s), lerp(-25.0, 22.0, s), lerp(-95.0, 35.0, s))

	else:
		# HIT 3 - PHASE 3C: Unified Fluid Deceleration & Stance Recovery (2.20s - 3.00s)
		# Continuous C1 motion: No static pause, no bounce-back drag, all joints flow seamlessly back to stance
		var prog = clampf((t_atk - 2.20) / 0.80, 0.0, 1.0)
		var s = smoothstep(0.0, 1.0, prog)
		
		p["hips_pos"] = Vector3(
			lerp(0.04, 0.0, s),
			lerp(ground_hips_y + 0.015, ground_hips_y, s),
			lerp(0.10, 0.0, s)
		)
		p["hips_rot"] = Vector3(0.0, lerp(36.0, 0.0, s), 0.0)
		p["torso_rot"] = Vector3(lerp(10.0, 7.0, s), lerp(58.0, 0.0, s), lerp(6.0, 0.0, s))
		p["head_rot"] = Vector3(lerp(4.0, -2.0, s), lerp(-30.0, 0.0, s), lerp(0.0, 2.5, s))
		
		p["left_thigh_rot"] = Vector3(lerp(-14.0, -2.0, s), 0.0, lerp(-8.0, 0.0, s))
		p["left_shin_rot"] = Vector3(lerp(18.0, 4.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(18.0, 1.0, s), 0.0, lerp(12.0, 0.0, s))
		p["right_shin_rot"] = Vector3(lerp(26.0, 3.0, s), 0.0, 0.0)
		
		var w_target = _compute_stance_arms(0.0, current_stance, "idle")
		p["left_arm_rot"] = _lerp_angles(Vector3(34.0, 0.0, -18.0), w_target["left_arm_rot"], s)
		p["left_forearm_rot"] = _lerp_angles(Vector3(-72.0, 0.0, 0.0), w_target["left_forearm_rot"], s)
		p["right_arm_rot"] = _lerp_angles(Vector3(22.0, 18.0, 76.0), w_target["right_arm_rot"], s)
		p["right_forearm_rot"] = _lerp_angles(Vector3(-14.0, 0.0, 20.0), w_target["right_forearm_rot"], s)
		p["club_rot"] = _lerp_angles(Vector3(95.0, 22.0, 35.0), w_target["club_rot"], s)

	return p

# --- 2. FULL-BODY 180° CLEAVE (Zero Torso-Clipping Recovery, Anatomically Safe Splay) ---
func _compute_attack_cleave(t_atk: float) -> Dictionary:
	var p: Dictionary = {}
	var tau = clampf(t_atk / ATTACK_DURATION, 0.0, 1.0)
	
	if tau < 0.35:
		# PHASE 1: Windup / Rewind (Coil Body & Weapon Back to the RIGHT) (0.0s - 0.45s)
		var s = smoothstep(0.0, 1.0, tau / 0.35)
		var key = "cleave" if stance_configs.has("cleave") else current_stance
		var cfg = stance_configs.get(key, default_stance_configs.get(key, default_stance_configs.get(current_stance, {})))
		var base_club: Vector3 = cfg.get("club_rot", Vector3(118.0, -15.0, -12.0))
		var base_r_arm: Vector3 = cfg.get("right_arm_rot", Vector3(12.0, -8.0, 26.0))
		var base_r_fore: Vector3 = cfg.get("right_forearm_rot", Vector3(-22.0, 0.0, 0.0))
		var base_l_arm: Vector3 = cfg.get("left_arm_rot", Vector3(0.0, 0.0, -12.0))
		var base_l_fore: Vector3 = cfg.get("left_forearm_rot", Vector3(-16.0, 0.0, 0.0))
		
		p["hips_pos"] = Vector3(0.0, lerp(ground_hips_y, ground_hips_y - 0.04, s), 0.0)
		p["hips_rot"] = Vector3(0.0, lerp(0.0, 32.0, s), 0.0)
		p["torso_rot"] = Vector3(lerp(7.0, 8.0, s), lerp(0.0, 52.0, s), lerp(0.0, 4.0, s))
		p["head_rot"] = Vector3(lerp(-2.0, -4.0, s), lerp(0.0, -32.0, s), 0.0)
		
		p["left_thigh_rot"] = Vector3(lerp(-2.0, -12.0, s), 0.0, lerp(0.0, -14.0, s))
		p["left_shin_rot"] = Vector3(lerp(4.0, 20.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(1.0, 16.0, s), 0.0, lerp(0.0, 16.0, s))
		p["right_shin_rot"] = Vector3(lerp(3.0, 22.0, s), 0.0, 0.0)
		
		# Left arm reaches forward to aim & balance
		p["left_arm_rot"] = _lerp_angles(base_l_arm, Vector3(-40.0, 0.0, 15.0), s)
		p["left_forearm_rot"] = _lerp_angles(base_l_fore, Vector3(-55.0, 0.0, 0.0), s)
		
		# RIGHT ARM: Pulls spiked club high and back behind right flank
		p["right_arm_rot"] = _lerp_angles(base_r_arm, Vector3(18.0, 10.0, 75.0), s)
		p["right_forearm_rot"] = _lerp_angles(base_r_fore, Vector3(-35.0, 0.0, 20.0), s)
		p["club_rot"] = _lerp_angles(base_club, Vector3(85.0, 30.0, 20.0), s)
		
	elif tau < 0.60:
		# PHASE 2: Explosive 180° Horizontal Cleave (0.45s - 0.78s)
		# Right arm extends forward (Rx = -70°) well in front of chest (Z >= 0.35m) while sweeping across
		var prog = (tau - 0.35) / 0.25
		var s = 1.0 - pow(1.0 - prog, 2.5)
		
		p["hips_pos"] = Vector3(0.0, lerp(ground_hips_y - 0.04, ground_hips_y + 0.02, s), 0.0)
		p["hips_rot"] = Vector3(0.0, lerp(32.0, -40.0, s), 0.0)
		p["torso_rot"] = Vector3(lerp(8.0, 14.0, s), lerp(52.0, -68.0, s), lerp(4.0, -6.0, s))
		p["head_rot"] = Vector3(lerp(-4.0, 6.0, s), lerp(-32.0, 28.0, s), 0.0)
		
		p["left_thigh_rot"] = Vector3(lerp(-12.0, 12.0, s), 0.0, -14.0)
		p["left_shin_rot"] = Vector3(lerp(20.0, 14.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(16.0, -18.0, s), 0.0, 16.0)
		p["right_shin_rot"] = Vector3(lerp(22.0, 36.0, s), 0.0, 0.0)
		
		p["left_arm_rot"] = Vector3(lerp(-40.0, 32.0, s), 0.0, lerp(15.0, -20.0, s))
		p["left_forearm_rot"] = Vector3(lerp(-55.0, -80.0, s), 0.0, 0.0)
		
		# Right arm: stays forward (Rx = -70°) and sweeps across to Rz = -18° (anatomically safe, zero clipping!)
		p["right_arm_rot"] = Vector3(lerp(18.0, -70.0, s), lerp(10.0, 0.0, s), lerp(75.0, -18.0, s))
		p["right_forearm_rot"] = Vector3(lerp(-35.0, -15.0, s), 0.0, 0.0)
		p["club_rot"] = Vector3(lerp(85.0, 90.0, s), lerp(30.0, 0.0, s), lerp(20.0, -75.0, s))
		
	elif tau < 0.72:
		# PHASE 3: Momentum Drag / Overshoot (0.78s - 0.94s)
		var prog = (tau - 0.60) / 0.12
		var drag = sin(prog * PI)
		
		p["hips_pos"] = Vector3(0.0, ground_hips_y + 0.02 - drag * 0.015, 0.0)
		p["hips_rot"] = Vector3(0.0, -40.0 - drag * 4.0, 0.0)
		p["torso_rot"] = Vector3(14.0, -68.0 - drag * 6.0, -6.0)
		p["head_rot"] = Vector3(6.0, 28.0 + drag * 4.0, 0.0)
		
		p["left_thigh_rot"] = Vector3(12.0, 0.0, -14.0)
		p["left_shin_rot"] = Vector3(14.0, 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(-18.0, 0.0, 16.0)
		p["right_shin_rot"] = Vector3(36.0, 0.0, 0.0)
		
		p["left_arm_rot"] = Vector3(32.0, 0.0, -20.0)
		p["left_forearm_rot"] = Vector3(-80.0, 0.0, 0.0)
		
		# Right arm remains safely forward in front of chest (Z >= 0.35m)
		p["right_arm_rot"] = Vector3(-70.0, 0.0, -18.0)
		p["right_forearm_rot"] = Vector3(-15.0, 0.0, 0.0)
		p["club_rot"] = Vector3(90.0, 0.0, -75.0 - drag * 15.0)
		
	else:
		# PHASE 4: Anti-Torso-Clipping Recovery (0.94s - 1.30s)
		# 2-stage recovery: arm sweeps back across front while raised, then drops down on right side only!
		var prog = (tau - 0.72) / 0.28
		var s = smoothstep(0.0, 1.0, prog)
		
		p["hips_pos"] = Vector3(0.0, lerp(ground_hips_y + 0.02, ground_hips_y, s), 0.0)
		p["hips_rot"] = Vector3(0.0, lerp(-40.0, 0.0, s), 0.0)
		p["torso_rot"] = Vector3(lerp(14.0, 7.0, s), lerp(-68.0, 0.0, s), lerp(-6.0, 0.0, s))
		p["head_rot"] = Vector3(lerp(6.0, -2.0, s), lerp(28.0, 0.0, s), 0.0)
		
		p["left_thigh_rot"] = Vector3(lerp(12.0, -2.0, s), 0.0, lerp(-14.0, 0.0, s))
		p["left_shin_rot"] = Vector3(lerp(14.0, 4.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(-18.0, 1.0, s), 0.0, lerp(16.0, 0.0, s))
		p["right_shin_rot"] = Vector3(lerp(36.0, 3.0, s), 0.0, 0.0)
		
		var w_target = _compute_stance_arms(0.0, current_stance, "idle")
		p["left_arm_rot"] = _lerp_angles(Vector3(32.0, 0.0, -20.0), w_target["left_arm_rot"], s)
		p["left_forearm_rot"] = _lerp_angles(Vector3(-80.0, 0.0, 0.0), w_target["left_forearm_rot"], s)
		
		# 2-stage arm return:
		var rec_rx: float = 0.0
		var rec_rz: float = 0.0
		if s < 0.50:
			var sub = s / 0.50
			# Sweep arm back across front while staying forward (Rx = -70 to -45, Rz = -18 to +20)
			rec_rx = lerp(-70.0, -45.0, sub)
			rec_rz = lerp(-18.0, 20.0, sub)
		else:
			var sub = (s - 0.50) / 0.50
			# Arm lowers on right side from +20 to target stance Rz, Rx from -45 to target stance Rx
			rec_rx = lerp(-45.0, w_target["right_arm_rot"].x, sub)
			rec_rz = lerp(20.0, w_target["right_arm_rot"].z, sub)
			
		p["right_arm_rot"] = Vector3(rec_rx, lerp(0.0, w_target["right_arm_rot"].y, s), rec_rz)
		p["right_forearm_rot"] = _lerp_angles(Vector3(-15.0, 0.0, 0.0), w_target["right_forearm_rot"], s)
		p["club_rot"] = _lerp_angles(Vector3(90.0, 0.0, -75.0), w_target["club_rot"], s)
		
	return p

# --- 3. DYNAMIC STANCE ARMS (Reads from configurable stance_configs) ---
func _compute_stance_arms(t: float, stance: String, motion: String) -> Dictionary:
	var w: Dictionary = {}
	var key = motion if stance_configs.has(motion) else stance
	var cfg = stance_configs.get(key, default_stance_configs.get(key, default_stance_configs.get(stance, {})))
	
	var base_r_arm: Vector3 = cfg.get("right_arm_rot", Vector3.ZERO)
	var base_r_fore: Vector3 = cfg.get("right_forearm_rot", Vector3.ZERO)
	var base_club: Vector3 = cfg.get("club_rot", Vector3.ZERO)
	var base_l_arm: Vector3 = cfg.get("left_arm_rot", Vector3.ZERO)
	var base_l_fore: Vector3 = cfg.get("left_forearm_rot", Vector3.ZERO)
	
	if motion == "idle":
		var sway = sin(t) * 1.5
		w["right_arm_rot"] = base_r_arm + Vector3(sway, 0.0, cos(t) * 0.8)
		w["right_forearm_rot"] = base_r_fore + Vector3(sway * 0.6, 0.0, 0.0)
		w["club_rot"] = base_club + Vector3(sway, 0.0, 0.0)
		w["left_arm_rot"] = base_l_arm + Vector3(sway * 1.2, 0.0, -cos(t) * 0.8)
		w["left_forearm_rot"] = base_l_fore + Vector3(sway, 0.0, 0.0)
	elif motion == "walk":
		w["right_arm_rot"] = base_r_arm + Vector3(-sin(t) * 10.0, 0.0, 0.0)
		w["right_forearm_rot"] = base_r_fore + Vector3(sin(t) * 4.0, 0.0, 0.0)
		w["club_rot"] = base_club + Vector3(cos(t) * 4.0, 0.0, 0.0)
		w["left_arm_rot"] = base_l_arm + Vector3(sin(t) * 24.0, 0.0, 0.0)
		w["left_forearm_rot"] = base_l_fore + Vector3(-max(0.0, sin(t)) * 20.0, 0.0, 0.0)
	elif motion == "run":
		w["right_arm_rot"] = base_r_arm + Vector3(-sin(t) * 12.0, 0.0, 0.0)
		w["right_forearm_rot"] = base_r_fore
		w["club_rot"] = base_club + Vector3(cos(t) * 6.0, 0.0, 0.0)
		w["left_arm_rot"] = base_l_arm + Vector3(sin(t) * 45.0, 0.0, 0.0)
		w["left_forearm_rot"] = base_l_fore + Vector3(-sin(t) * 24.0, 0.0, 0.0)
		
	return w
