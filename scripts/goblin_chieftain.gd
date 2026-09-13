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

@onready var cape: Node3D = $VisualRoot/Hips/Torso/Cape if has_node("VisualRoot/Hips/Torso/Cape") else null
@onready var cape_mesh: MeshInstance3D = $VisualRoot/Hips/Torso/Cape/CapeMesh if has_node("VisualRoot/Hips/Torso/Cape/CapeMesh") else null
var cape_current_rot: Vector3 = Vector3.ZERO

# State
var current_anim: String = "idle" # "idle", "walk", "cleave", "roar", "earthshaker", "whirlwind", "stagger", "stunned"
var base_anim: String = "idle"
var anim_time: float = 0.0
var anim_speed: float = 1.0

# Action Timers
var action_time: float = 0.0
const CLEAVE_DURATION: float = 1.50
const ROAR_DURATION: float = 2.10
const EARTHSHAKER_DURATION: float = 2.00
const WHIRLWIND_DURATION: float = 1.90
const PARRY_DURATION: float = 1.35
const STAGGER_DURATION: float = 1.35

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

# Stun Stars & Weapon Trail VFX
const StunStarsScript = preload("res://scripts/stun_stars.gd")
var stun_stars: Node3D = null

const WeaponTrailScript = preload("res://scripts/ogre_weapon_trail.gd")
var weapon_trail: Node3D = null
var earthshaker_impacted: bool = false
var stagger_planted: bool = false

var current_outfit: int = 1
var outfit_meshes: Dictionary = {}

signal anim_changed(anim_name: String)
signal outfit_changed(outfit_id: int)

func _ready() -> void:
	_init_cape()
	generate_voxel_meshes()
	_init_stun_stars()
	_init_weapon_trail()
	_init_default_stances()
	load_stance_config()
	current_pose = _compute_pose(current_anim, 0.0)
	_apply_pose(current_pose)

func _init_cape() -> void:
	if cape == null and torso != null:
		cape = torso.get_node_or_null("Cape")
		if cape == null:
			cape = Node3D.new()
			cape.name = "Cape"
			cape.transform = Transform3D(Basis(), Vector3(0.0, 0.48, -0.215))
			torso.add_child(cape)
			cape_mesh = MeshInstance3D.new()
			cape_mesh.name = "CapeMesh"
			cape.add_child(cape_mesh)
		else:
			cape_mesh = cape.get_node_or_null("CapeMesh")

func generate_voxel_meshes() -> void:
	outfit_meshes[1] = {
		"head": VoxelBuilder.build_ogre_head_mesh(1),
		"torso": VoxelBuilder.build_ogre_torso_mesh(1),
		"warhammer": VoxelBuilder.build_ogre_mace_mesh(1),
		"upper_arm": VoxelBuilder.build_ogre_upper_arm_mesh(1),
		"left_forearm": VoxelBuilder.build_ogre_forearm_mesh(false, 1),
		"right_forearm": VoxelBuilder.build_ogre_forearm_mesh(true, 1),
		"thigh": VoxelBuilder.build_ogre_thigh_mesh(1),
		"shin": VoxelBuilder.build_ogre_shin_mesh(1),
		"cape": null
	}
	outfit_meshes[2] = {
		"head": VoxelBuilder.build_ogre_head_mesh(2),
		"torso": VoxelBuilder.build_ogre_torso_mesh(2),
		"warhammer": VoxelBuilder.build_ogre_mace_mesh(2),
		"upper_arm": VoxelBuilder.build_ogre_upper_arm_mesh(2),
		"left_forearm": VoxelBuilder.build_ogre_forearm_mesh(false, 2),
		"right_forearm": VoxelBuilder.build_ogre_forearm_mesh(true, 2),
		"thigh": VoxelBuilder.build_ogre_thigh_mesh(2),
		"shin": VoxelBuilder.build_ogre_shin_mesh(2),
		"cape": null
	}
	outfit_meshes[3] = {
		"head": VoxelBuilder.build_ogre_head_mesh(3),
		"torso": VoxelBuilder.build_ogre_torso_mesh(3),
		"warhammer": VoxelBuilder.build_ogre_mace_mesh(3),
		"upper_arm": VoxelBuilder.build_ogre_upper_arm_mesh(3),
		"left_forearm": VoxelBuilder.build_ogre_forearm_mesh(false, 3),
		"right_forearm": VoxelBuilder.build_ogre_forearm_mesh(true, 3),
		"thigh": VoxelBuilder.build_ogre_thigh_mesh(3),
		"shin": VoxelBuilder.build_ogre_shin_mesh(3),
		"cape": VoxelBuilder.build_ogre_cape_mesh(3)
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
	warhammer_mesh.mesh = m["warhammer"]
	left_thigh_mesh.mesh = m["thigh"]
	left_shin_mesh.mesh = m["shin"]
	right_thigh_mesh.mesh = m["thigh"]
	right_shin_mesh.mesh = m["shin"]
	if cape_mesh:
		if m.has("cape") and m["cape"] != null:
			cape_mesh.mesh = m["cape"]
			cape_mesh.visible = true
		else:
			cape_mesh.mesh = null
			cape_mesh.visible = false
	_update_weapon_trail_colors(outfit_id)

func _update_weapon_trail_colors(outfit_id: int) -> void:
	if weapon_trail == null:
		return
	if outfit_id == 3:
		# Imperial Golden Titan Warlord: Radiant solar gold tip & royal crimson ruby base
		weapon_trail.color_tip = Color(1.0, 0.96, 0.60, 1.0)
		weapon_trail.color_base = Color(0.96, 0.12, 0.32, 0.95)
		weapon_trail.shockwave_color = Color(1.0, 0.85, 0.25)
	elif outfit_id == 2:
		# Iron Legion Warlord: Fiery ember & heavy iron sparks
		weapon_trail.color_tip = Color(1.0, 0.85, 0.40, 0.95)
		weapon_trail.color_base = Color(0.90, 0.20, 0.05, 0.85)
		weapon_trail.shockwave_color = Color(1.0, 0.55, 0.12)
	else:
		# Primitive Scavenger: Crude stone & dust trail
		weapon_trail.color_tip = Color(1.0, 0.70, 0.30, 0.90)
		weapon_trail.color_base = Color(0.80, 0.25, 0.05, 0.70)
		weapon_trail.shockwave_color = Color(0.90, 0.45, 0.10)

func _init_stun_stars() -> void:
	stun_stars = StunStarsScript.new()
	stun_stars.name = "StunStarsFX"
	head.add_child(stun_stars)

func _init_weapon_trail() -> void:
	weapon_trail = WeaponTrailScript.new()
	weapon_trail.name = "WeaponTrail"
	add_child(weapon_trail)
	weapon_trail.set_target(warhammer)
	weapon_trail.tip_offset = Vector3(0.0, 0.58, 0.0)
	weapon_trail.base_offset = Vector3(0.0, 0.18, 0.0)
	weapon_trail.max_points = 110
	_update_weapon_trail_colors(current_outfit)

func _init_default_stances() -> void:
	default_stance_configs = {
		"idle": {
			"right_arm_rot": Vector3(-32.0, 18.0, 48.0),
			"right_forearm_rot": Vector3(-115.0, 0.0, 0.0),
			"warhammer_rot": Vector3(65.0, 0.0, -52.0),
			"left_arm_rot": Vector3(15.0, 0.0, -15.0),
			"left_forearm_rot": Vector3(-25.0, 0.0, 0.0),
			"torso_rot": Vector3(6.0, 0.0, 0.0),
			"head_rot": Vector3(-4.0, 0.0, 0.0)
		},
		"walk": {
			"right_arm_rot": Vector3(-32.0, 18.0, 48.0),
			"right_forearm_rot": Vector3(-115.0, 0.0, 0.0),
			"warhammer_rot": Vector3(65.0, 0.0, -52.0),
			"left_arm_rot": Vector3(10.0, 0.0, -18.0),
			"left_forearm_rot": Vector3(-25.0, 0.0, 0.0),
			"torso_rot": Vector3(10.0, 0.0, 0.0),
			"head_rot": Vector3(-6.0, 0.0, 0.0)
		},
		"cleave": {
			"right_arm_rot": Vector3(-55.0, -10.0, -15.0),
			"right_forearm_rot": Vector3(-30.0, 0.0, 0.0),
			"warhammer_rot": Vector3(90.0, 0.0, -75.0),
			"left_arm_rot": Vector3(-65.0, 28.0, 10.0),
			"left_forearm_rot": Vector3(-5.0, 0.0, 0.0),
			"torso_rot": Vector3(10.0, -45.0, -4.0),
			"head_rot": Vector3(2.0, 22.0, 0.0)
		},
		"roar": {
			"right_arm_rot": Vector3(-78.0, 12.0, 35.0),
			"right_forearm_rot": Vector3(-42.0, 0.0, 0.0),
			"warhammer_rot": Vector3(88.0, 12.0, -15.0),
			"left_arm_rot": Vector3(-52.0, -12.0, -72.0),
			"left_forearm_rot": Vector3(-25.0, 0.0, 0.0),
			"torso_rot": Vector3(-18.0, 0.0, 2.0),
			"head_rot": Vector3(-40.0, 0.0, 0.0)
		},
		"earthshaker": {
			"right_arm_rot": Vector3(-35.0, 5.0, 10.0),
			"right_forearm_rot": Vector3(-65.0, 0.0, 0.0),
			"warhammer_rot": Vector3(175.0, 0.0, 0.0),
			"left_arm_rot": Vector3(-32.0, -5.0, -8.0),
			"left_forearm_rot": Vector3(-68.0, 0.0, 0.0),
			"torso_rot": Vector3(40.0, 0.0, 0.0),
			"head_rot": Vector3(-10.0, 0.0, 0.0)
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
			"right_arm_rot": Vector3(-28.0, 12.0, 62.0),
			"right_forearm_rot": Vector3(-35.0, 0.0, 0.0),
			"warhammer_rot": Vector3(78.0, 20.0, -55.0),
			"left_arm_rot": Vector3(-10.0, 0.0, -48.0),
			"left_forearm_rot": Vector3(-25.0, 0.0, 0.0),
			"torso_rot": Vector3(-14.0, 15.0, -6.0),
			"head_rot": Vector3(-15.0, 8.0, 0.0)
		},
		"parry": {
			"right_arm_rot": Vector3(-28.0, 12.0, 62.0),
			"right_forearm_rot": Vector3(-35.0, 0.0, 0.0),
			"warhammer_rot": Vector3(78.0, 20.0, -55.0),
			"left_arm_rot": Vector3(-10.0, 0.0, -48.0),
			"left_forearm_rot": Vector3(-25.0, 0.0, 0.0),
			"torso_rot": Vector3(-14.0, 15.0, -6.0),
			"head_rot": Vector3(-15.0, 8.0, 0.0)
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
			"right_arm_rot": Vector3(-32.0, 18.0, 48.0),
			"right_forearm_rot": Vector3(-115.0, 0.0, 0.0),
			"warhammer_rot": Vector3(65.0, 0.0, -52.0),
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
		{"id": "stagger", "name": "Bị Parry", "shortcut": "[ 7 ]"},
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
	if current_anim == anim_name and current_anim not in ["cleave", "roar", "earthshaker", "stagger", "parry"]:
		return
	_stop_all_weapon_trails()
	earthshaker_impacted = false
	stagger_planted = false
	_start_blend()
	current_anim = anim_name
	action_time = 0.0
	
	if current_anim in ["idle", "shoulder", "ground", "guard", "walk", "whirlwind", "stunned"]:
		base_anim = current_anim
		
	if stun_stars:
		stun_stars.set_active(current_anim == "stunned")
		
	if current_anim in ["parry", "stagger"] and weapon_trail:
		var spark_pos = warhammer.to_global(weapon_trail.tip_offset)
		weapon_trail.trigger_parry_spark(spark_pos)
		
	emit_signal("anim_changed", current_anim)

func _stop_all_weapon_trails() -> void:
	if weapon_trail:
		weapon_trail.stop_trail()
		weapon_trail.set_vortex_active(false)

func _update_attack_trails(t_cur: float) -> void:
	if not weapon_trail:
		return
		
	if current_anim == "cleave":
		var tau = clampf(t_cur / CLEAVE_DURATION, 0.0, 1.0)
		# Powerful horizontal sweep arc (tau in [0.28, 0.68])
		if tau >= 0.28 and tau <= 0.68:
			if not weapon_trail.is_emitting:
				weapon_trail.start_trail(Color(1.0, 0.92, 0.45, 0.98), Color(0.95, 0.35, 0.05, 0.85), 0.26)
		else:
			if weapon_trail.is_emitting:
				weapon_trail.stop_trail()
				
	elif current_anim == "earthshaker":
		var tau = clampf(t_cur / EARTHSHAKER_DURATION, 0.0, 1.0)
		# Overhead downward heave & slam (tau in [0.30, 0.48])
		if tau >= 0.30 and tau < 0.48:
			if not weapon_trail.is_emitting:
				weapon_trail.start_trail(Color(1.0, 0.85, 0.25, 0.98), Color(0.92, 0.22, 0.03, 0.90), 0.20)
		elif tau >= 0.48:
			if weapon_trail.is_emitting:
				weapon_trail.stop_trail()
			if not earthshaker_impacted:
				earthshaker_impacted = true
				var impact_pos = warhammer.to_global(weapon_trail.tip_offset)
				# Massive multi-layer shockwave, crater spikes & 22 rock shards
				weapon_trail.trigger_ground_impact(impact_pos, 2.35, 0.46, Color(1.0, 0.70, 0.18))
				
	elif current_anim == "whirlwind":
		# Intimidating 360° cyclone storm: thick blazing ribbon, multi-tier vortex & tornado debris
		if not weapon_trail.is_emitting:
			weapon_trail.start_trail(Color(1.0, 0.95, 0.50, 0.98), Color(1.0, 0.38, 0.05, 0.90), 0.45)
		weapon_trail.set_vortex_active(true, global_position, 1.85, Color(1.0, 0.82, 0.25))
		
	elif current_anim in ["stagger", "parry"]:
		if weapon_trail.is_emitting:
			weapon_trail.stop_trail()
			
	else:
		if weapon_trail.is_emitting or weapon_trail.is_vortex_active:
			_stop_all_weapon_trails()

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
			_stop_all_weapon_trails()
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
			_stop_all_weapon_trails()
			current_anim = base_anim
			action_time = 0.0
			_start_blend()
			emit_signal("anim_changed", current_anim)
	elif current_anim in ["stagger", "parry"]:
		action_time += dt
		if action_time >= PARRY_DURATION:
			_stop_all_weapon_trails()
			current_anim = base_anim
			action_time = 0.0
			_start_blend()
			emit_signal("anim_changed", current_anim)
			
	if stun_stars:
		stun_stars.set_active(current_anim == "stunned")
		
	var cur_t = action_time if current_anim in ["cleave", "roar", "earthshaker", "stagger", "parry"] else anim_time
	_update_attack_trails(cur_t)
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
	_update_cape_physics(dt)

func _update_cape_physics(delta: float) -> void:
	if not cape or not cape_mesh or not cape_mesh.visible:
		return

	var target_rot: Vector3 = Vector3.ZERO

	match current_anim:
		"idle", "shoulder", "ground", "guard":
			# Majestic slow breathing and ambient breeze
			var t = anim_time * 2.2
			target_rot.x = 4.5 + sin(t) * 2.2 + sin(t * 0.45) * 1.0
			target_rot.z = sin(t * 0.75) * 2.2
			target_rot.y = cos(t * 0.5) * 1.4

		"walk":
			# Pacing stride: trailing behind with rhythmic step counter-sway
			var t = anim_time * 3.8
			target_rot.x = 11.5 + sin(t * 2.0) * 4.2
			target_rot.z = sin(t) * 6.5
			target_rot.y = cos(t) * 3.5

		"cleave":
			# Heavy horizontal swing: windup drop, then explosive outward sweep & settle
			var tau = clampf(action_time / CLEAVE_DURATION, 0.0, 1.0)
			if tau < 0.28:
				var u = tau / 0.28
				target_rot.x = lerpf(4.5, -2.0, u)
				target_rot.z = lerpf(0.0, -4.0, u)
			elif tau < 0.62:
				var u = (tau - 0.28) / 0.34
				target_rot.x = lerpf(-2.0, 25.0, sin(u * PI * 0.85))
				target_rot.z = lerpf(-4.0, 16.0, u)
				target_rot.y = -8.0 * sin(u * PI)
			else:
				var u = (tau - 0.62) / 0.38
				target_rot.x = lerpf(25.0, 4.5, u) + sin(u * PI * 2.0) * 3.5 * (1.0 - u)
				target_rot.z = lerpf(16.0, 0.0, u) * (1.0 - u)

		"earthshaker":
			# Overhead hammer raise, then ground shockwave blast lifting cape upward
			var tau = clampf(action_time / EARTHSHAKER_DURATION, 0.0, 1.0)
			if tau < 0.35:
				target_rot.x = -6.0 * (tau / 0.35)
				target_rot.z = sin(tau * 10.0) * 2.0
			elif tau < 0.52:
				var shock_u = (tau - 0.35) / 0.17
				target_rot.x = lerpf(-6.0, 30.0, shock_u)
				target_rot.z = sin(shock_u * PI * 4.0) * 7.5
			else:
				var settle_u = (tau - 0.52) / 0.48
				target_rot.x = lerpf(30.0, 4.5, settle_u) + sin(settle_u * PI * 3.0) * 4.5 * (1.0 - settle_u)
				target_rot.z = sin(settle_u * PI * 2.0) * 4.0 * (1.0 - settle_u)

		"whirlwind":
			# Centrifugal cyclone spin: pulls cape high outward
			var t = anim_time * 8.5
			target_rot.x = 26.0 + sin(t) * 3.5
			target_rot.z = 14.0 + cos(t) * 4.0
			target_rot.y = -10.0

		"roar":
			# Chest arched into sky: acoustic vibrations flutter the cape
			var tau = clampf(action_time / ROAR_DURATION, 0.0, 1.0)
			if tau < 0.25:
				target_rot.x = lerpf(4.5, -5.0, tau / 0.25)
			elif tau < 0.75:
				target_rot.x = -5.0 + sin(anim_time * 28.0) * 2.2
				target_rot.z = sin(anim_time * 22.0) * 2.8
			else:
				var u = (tau - 0.75) / 0.25
				target_rot.x = lerpf(-5.0, 4.5, u)

		"stagger", "parry":
			# Heavy impact shudder
			var tau = clampf(action_time / PARRY_DURATION, 0.0, 1.0)
			target_rot.x = 16.0 * sin(tau * PI) + 4.5
			target_rot.z = -10.0 * sin(tau * PI)

		"stunned":
			# Dazed wobble
			var t = anim_time * 2.5
			target_rot.x = 3.0 + sin(t) * 3.5
			target_rot.z = cos(t * 0.9) * 4.5

	# Smooth cloth damping lerp
	cape_current_rot = cape_current_rot.lerp(target_rot, delta * 6.5)
	cape.rotation_degrees = cape_current_rot

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
		"stagger", "parry": return _compute_parry(time_val)
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
	var cfg = stance_configs.get("shoulder", default_stance_configs.get("shoulder", {}))
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

# --- 5. CLEAVE (Thiết Quẹt - Massive Two-Handed Horizontal Sweeping Arc) ---
func _compute_cleave(t_c: float) -> Dictionary:
	var p: Dictionary = {}
	var tau = clampf(t_c / CLEAVE_DURATION, 0.0, 1.0)
	var base_cfg = _get_base_stance_cfg()
	var base_hammer = base_cfg.get("warhammer_rot", Vector3(65.0, 0.0, -30.0))
	var base_r_arm = base_cfg.get("right_arm_rot", Vector3(-32.0, 25.0, 35.0))
	var base_r_fore = base_cfg.get("right_forearm_rot", Vector3(-115.0, 0.0, 0.0))
	var base_l_arm = base_cfg.get("left_arm_rot", Vector3(15.0, 0.0, -15.0))
	var base_l_fore = base_cfg.get("left_forearm_rot", Vector3(-25.0, 0.0, 0.0))
	
	if tau < 0.30:
		# PHASE 1: Synchronized Two-Handed Windup & Deep Beastly Coil to Right
		var s = smoothstep(0.0, 1.0, tau / 0.30)
		p["hips_pos"] = Vector3(0.0, ground_hips_y + 0.003 * s, 0.02 * s)
		p["hips_rot"] = Vector3(4.0, lerp(0.0, 36.0, s), 0.0)
		p["torso_rot"] = Vector3(lerp(6.0, 8.0, s), lerp(0.0, 48.0, s), lerp(0.0, 2.0, s))
		p["head_rot"] = Vector3(lerp(-4.0, -2.0, s), lerp(0.0, -38.0, s), 0.0)
		
		# Both hands grip shaft back at right shoulder
		p["right_arm_rot"] = _lerp_angles(base_r_arm, Vector3(-42.0, 18.0, 20.0), s)
		p["right_forearm_rot"] = _lerp_angles(base_r_fore, Vector3(-90.0, 0.0, 0.0), s)
		p["warhammer_rot"] = _lerp_angles(base_hammer, Vector3(65.0, 15.0, -18.0), s)
		p["left_arm_rot"] = _lerp_angles(base_l_arm, Vector3(-78.0, 25.0, 20.0), s)
		p["left_forearm_rot"] = _lerp_angles(base_l_fore, Vector3(-15.0, 0.0, 0.0), s)
		
		# Legs coil into loaded crouch stance
		p["left_thigh_rot"] = Vector3(lerp(0.0, -12.0, s), 0.0, -6.5)
		p["left_shin_rot"] = Vector3(lerp(7.0, 18.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(0.0, 14.0, s), 0.0, 6.5)
		p["right_shin_rot"] = Vector3(lerp(7.0, 18.0, s), 0.0, 0.0)
		
	elif tau < 0.54:
		# PHASE 2: Devastating Two-Handed Cleave Sweep Across Front (Z >= +0.40m)
		var prog = (tau - 0.30) / 0.24
		var s = 1.0 - pow(1.0 - prog, 3.0)
		
		p["hips_pos"] = Vector3(0.0, ground_hips_y + lerp(0.003, 0.004, s), lerp(0.02, 0.10, s))
		p["hips_rot"] = Vector3(4.0, lerp(36.0, -25.0, s), 0.0)
		p["torso_rot"] = Vector3(lerp(8.0, 10.0, s), lerp(48.0, -45.0, s), lerp(2.0, -4.0, s))
		p["head_rot"] = Vector3(lerp(-2.0, 2.0, s), lerp(-38.0, 22.0, s), 0.0)
		
		# Both arms sweep mace forward and across in an athletic power arc
		p["right_arm_rot"] = Vector3(lerp(-42.0, -55.0, s), lerp(18.0, -10.0, s), lerp(20.0, -15.0, s))
		p["right_forearm_rot"] = Vector3(lerp(-90.0, -30.0, s), 0.0, 0.0)
		p["warhammer_rot"] = Vector3(lerp(65.0, 90.0, s), lerp(15.0, 0.0, s), lerp(-18.0, -75.0, s))
		p["left_arm_rot"] = Vector3(lerp(-78.0, -65.0, s), lerp(25.0, 28.0, s), lerp(20.0, 10.0, s))
		p["left_forearm_rot"] = Vector3(lerp(-15.0, -5.0, s), 0.0, 0.0)
		
		p["left_thigh_rot"] = Vector3(lerp(-12.0, 10.0, s), 0.0, -6.5)
		p["left_shin_rot"] = Vector3(lerp(18.0, 14.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(14.0, -14.0, s), 0.0, 6.5)
		p["right_shin_rot"] = Vector3(lerp(18.0, 28.0, s), 0.0, 0.0)
		
	elif tau < 0.70:
		# PHASE 3: Heavy Inertial Follow-Through & Overshoot
		var prog = (tau - 0.54) / 0.16
		var s = sin(prog * 0.5 * PI)
		
		p["hips_pos"] = Vector3(0.0, ground_hips_y + 0.004, lerp(0.10, 0.12, s))
		p["hips_rot"] = Vector3(4.0, lerp(-25.0, -35.0, s), 0.0)
		p["torso_rot"] = Vector3(lerp(10.0, 12.0, s), lerp(-45.0, -65.0, s), lerp(-4.0, -6.0, s))
		p["head_rot"] = Vector3(lerp(2.0, 4.0, s), lerp(22.0, 32.0, s), 0.0)
		
		p["right_arm_rot"] = Vector3(lerp(-55.0, -50.0, s), lerp(-10.0, -15.0, s), lerp(-15.0, -35.0, s))
		p["right_forearm_rot"] = Vector3(lerp(-30.0, -20.0, s), 0.0, 0.0)
		p["warhammer_rot"] = Vector3(lerp(90.0, 95.0, s), 0.0, lerp(-75.0, -85.0, s))
		p["left_arm_rot"] = Vector3(lerp(-65.0, -2.0, s), lerp(28.0, 15.0, s), lerp(10.0, 32.0, s))
		p["left_forearm_rot"] = Vector3(lerp(-5.0, -105.0, s), 0.0, 0.0)
		
		p["left_thigh_rot"] = Vector3(lerp(10.0, 12.0, s), 0.0, -6.5)
		p["left_shin_rot"] = Vector3(lerp(14.0, 15.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(-14.0, 0.0, 6.5)
		p["right_shin_rot"] = Vector3(28.0, 0.0, 0.0)
		
	else:
		# PHASE 4: Muscular Heave & Seamless Recovery to Base Stance
		var prog = (tau - 0.70) / 0.30
		var s = smoothstep(0.0, 1.0, prog)
		
		p["hips_pos"] = Vector3(0.0, ground_hips_y, lerp(0.12, 0.0, s))
		p["hips_rot"] = Vector3(4.0, lerp(-35.0, 0.0, s), 0.0)
		p["torso_rot"] = Vector3(lerp(12.0, 6.0, s), lerp(-65.0, 0.0, s), lerp(-6.0, 0.0, s))
		p["head_rot"] = Vector3(lerp(4.0, -4.0, s), lerp(32.0, 0.0, s), 0.0)
		
		p["right_arm_rot"] = _lerp_angles(Vector3(-50.0, -15.0, -35.0), base_r_arm, s)
		p["right_forearm_rot"] = _lerp_angles(Vector3(-20.0, 0.0, 0.0), base_r_fore, s)
		p["warhammer_rot"] = _lerp_angles(Vector3(95.0, 0.0, -85.0), base_hammer, s)
		p["left_arm_rot"] = _lerp_angles(Vector3(-2.0, 15.0, 32.0), base_l_arm, s)
		p["left_forearm_rot"] = _lerp_angles(Vector3(-105.0, 0.0, 0.0), base_l_fore, s)
		
		p["left_thigh_rot"] = Vector3(lerp(12.0, 0.0, s), 0.0, -6.0)
		p["left_shin_rot"] = Vector3(lerp(15.0, 7.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(-14.0, 0.0, s), 0.0, 6.0)
		p["right_shin_rot"] = Vector3(lerp(28.0, 7.0, s), 0.0, 0.0)
	return p

# --- 6. WAR ROAR (Chieftain Battle Cry: Titanic Skyward Bellow & Muscular War Totem) ---
func _compute_roar(t_r: float) -> Dictionary:
	var p: Dictionary = {}
	var tau = clampf(t_r / ROAR_DURATION, 0.0, 1.0)
	var base_cfg = _get_base_stance_cfg()
	var base_target_pose = _compute_pose(base_anim, anim_time)
	var base_hammer = base_cfg.get("warhammer_rot", Vector3(65.0, 0.0, -30.0))
	var base_r_arm = base_cfg.get("right_arm_rot", Vector3(-32.0, 25.0, 35.0))
	var base_r_fore = base_cfg.get("right_forearm_rot", Vector3(-115.0, 0.0, 0.0))
	var base_l_arm = base_cfg.get("left_arm_rot", Vector3(15.0, 0.0, -15.0))
	var base_l_fore = base_cfg.get("left_forearm_rot", Vector3(-25.0, 0.0, 0.0))
	
	if tau < 0.24:
		# PHASE 1: Heavy Inhale & Power Windup (Hít Sâu & Tụ Lực Thần Tốc)
		var s = smoothstep(0.0, 1.0, tau / 0.24)
		p["hips_pos"] = Vector3(0.0, ground_hips_y + 0.002 * s, -0.02 * s)
		p["hips_rot"] = Vector3(lerp(4.0, 2.0, s), lerp(0.0, -4.0, s), 0.0)
		p["torso_rot"] = Vector3(lerp(6.0, -6.0, s), lerp(0.0, -5.0, s), 0.0)
		p["head_rot"] = Vector3(lerp(-4.0, -16.0, s), 0.0, 0.0)
		
		# Right arm hoists great warhammer up and back off the shoulder
		p["right_arm_rot"] = _lerp_angles(base_r_arm, Vector3(-50.0, 15.0, 32.0), s)
		p["right_forearm_rot"] = _lerp_angles(base_r_fore, Vector3(-85.0, 0.0, 0.0), s)
		p["warhammer_rot"] = _lerp_angles(base_hammer, Vector3(68.0, 8.0, -22.0), s)
		
		# Left arm draws back into a clenched predatory claw
		p["left_arm_rot"] = _lerp_angles(base_l_arm, Vector3(-25.0, -5.0, -35.0), s)
		p["left_forearm_rot"] = _lerp_angles(base_l_fore, Vector3(-55.0, 0.0, 0.0), s)
		
		p["left_thigh_rot"] = Vector3(lerp(0.0, -4.0, s), 0.0, -6.5)
		p["left_shin_rot"] = Vector3(lerp(7.0, 9.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(0.0, 4.0, s), 0.0, 6.5)
		p["right_shin_rot"] = Vector3(lerp(7.0, 9.0, s), 0.0, 0.0)
		
	elif tau < 0.62:
		# PHASE 2: TITANIC SKYWARD BELLOW - High War Totem Brandish & Diaphragm Pulse
		var prog = (tau - 0.24) / 0.38
		var s = smoothstep(0.0, 1.0, prog)
		
		# Organic acoustic chest rumble with smooth ramp-up and complete decay to 0.0 before phase end
		var ramp = smoothstep(0.0, 0.15, prog)
		var decay = 1.0 - smoothstep(0.70, 1.00, prog)
		var rumble_amp = ramp * decay
		var rumble = sin(t_r * 26.0) * (1.2 * rumble_amp)
		var chest_pulse = sin(prog * PI) * 3.5
		
		p["hips_pos"] = Vector3(0.0, ground_hips_y + 0.002, lerp(-0.02, 0.01, s))
		p["hips_rot"] = Vector3(lerp(2.0, -4.0, sin(prog * PI)), 0.0, 0.0)
		p["torso_rot"] = Vector3(lerp(-6.0, -20.0, sin(prog * PI)) - chest_pulse + rumble, 0.0, 0.0)
		p["head_rot"] = Vector3(lerp(-16.0, -40.0, sin(prog * PI)) + rumble * 0.7, 0.0, 0.0)
		
		# Right hand raises warhammer high into the sky as a war totem
		p["right_arm_rot"] = Vector3(lerp(-50.0, -78.0, s) + rumble * 0.4, 12.0, 35.0)
		p["right_forearm_rot"] = Vector3(lerp(-85.0, -42.0, s), 0.0, 0.0)
		p["warhammer_rot"] = Vector3(lerp(68.0, 88.0, s) + rumble * 0.5, 12.0, -15.0)
		
		# Left arm splays wide to intimidate the battlefield
		p["left_arm_rot"] = Vector3(lerp(-25.0, -52.0, s) + rumble * 0.5, -12.0, lerp(-35.0, -72.0, s))
		p["left_forearm_rot"] = Vector3(lerp(-55.0, -25.0, s), 0.0, 0.0)
		
		p["left_thigh_rot"] = Vector3(lerp(-4.0, -2.0, s), 0.0, -7.0)
		p["left_shin_rot"] = Vector3(lerp(9.0, 8.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(4.0, 2.0, s), 0.0, 7.0)
		p["right_shin_rot"] = Vector3(lerp(9.0, 8.0, s), 0.0, 0.0)
		
	elif tau < 0.84:
		# PHASE 3: Heavy Exhale & Gravitational Hammer Descent (Zero Jerk, Zero Vibration)
		var prog = (tau - 0.62) / 0.22
		var s = smoothstep(0.0, 1.0, prog)
		
		p["hips_pos"] = Vector3(0.0, ground_hips_y + 0.001 * (1.0 - s), lerp(0.01, 0.0, s))
		p["hips_rot"] = Vector3(lerp(2.0, 4.0, s), 0.0, 0.0)
		p["torso_rot"] = Vector3(lerp(-6.0, 10.0, s), 0.0, 0.0)
		p["head_rot"] = Vector3(lerp(-16.0, -6.0, s), 0.0, 0.0)
		
		# Warhammer descends smoothly in a heavy arc back towards resting shoulder carriage
		p["right_arm_rot"] = Vector3(lerp(-78.0, -38.0, s), lerp(12.0, 22.0, s), lerp(35.0, 34.0, s))
		p["right_forearm_rot"] = Vector3(lerp(-42.0, -108.0, s), 0.0, 0.0)
		p["warhammer_rot"] = Vector3(lerp(88.0, 66.0, s), lerp(12.0, 2.0, s), lerp(-15.0, -28.0, s))
		
		# Left arm relaxes naturally
		p["left_arm_rot"] = Vector3(lerp(-52.0, 12.0, s), lerp(-12.0, 0.0, s), lerp(-72.0, -18.0, s))
		p["left_forearm_rot"] = Vector3(lerp(-25.0, -25.0, s), 0.0, 0.0)
		
		p["left_thigh_rot"] = Vector3(lerp(-2.0, 0.0, s), 0.0, -6.0)
		p["left_shin_rot"] = Vector3(lerp(8.0, 7.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(2.0, 0.0, s), 0.0, 6.0)
		p["right_shin_rot"] = Vector3(lerp(8.0, 7.0, s), 0.0, 0.0)
		
	else:
		# PHASE 4: Seamless Settle to Live Base Stance (Zero Discontinuity, Zero Snap)
		var prog = (tau - 0.84) / 0.16
		var s = smoothstep(0.0, 1.0, prog)
		
		var end_p3_pose = {
			"hips_pos": Vector3(0.0, ground_hips_y, 0.0),
			"hips_rot": Vector3(4.0, 0.0, 0.0),
			"torso_rot": Vector3(10.0, 0.0, 0.0),
			"head_rot": Vector3(-6.0, 0.0, 0.0),
			"right_arm_rot": Vector3(-38.0, 22.0, 34.0),
			"right_forearm_rot": Vector3(-108.0, 0.0, 0.0),
			"warhammer_rot": Vector3(66.0, 2.0, -28.0),
			"left_arm_rot": Vector3(12.0, 0.0, -18.0),
			"left_forearm_rot": Vector3(-25.0, 0.0, 0.0),
			"left_thigh_rot": Vector3(0.0, 0.0, -6.0),
			"left_shin_rot": Vector3(7.0, 0.0, 0.0),
			"right_thigh_rot": Vector3(0.0, 0.0, 6.0),
			"right_shin_rot": Vector3(7.0, 0.0, 0.0)
		}
		p = _blend_poses(end_p3_pose, base_target_pose, s)
		
	return p

# --- 7. EARTHSHAKER SLAM (Grounded 2-Handed Overhead Heave & Devastating Impact) ---
func _compute_earthshaker(t_e: float) -> Dictionary:
	var p: Dictionary = {}
	var tau = clampf(t_e / EARTHSHAKER_DURATION, 0.0, 1.0)
	var base_cfg = _get_base_stance_cfg()
	var base_hammer = base_cfg.get("warhammer_rot", Vector3(65.0, 0.0, -30.0))
	var base_r_arm = base_cfg.get("right_arm_rot", Vector3(-32.0, 25.0, 35.0))
	var base_r_fore = base_cfg.get("right_forearm_rot", Vector3(-115.0, 0.0, 0.0))
	var base_l_arm = base_cfg.get("left_arm_rot", Vector3(15.0, 0.0, -15.0))
	var base_l_fore = base_cfg.get("left_forearm_rot", Vector3(-25.0, 0.0, 0.0))
	
	if tau < 0.32:
		# PHASE 1: Heavy Crouch & Two-Handed Overhead Hoist
		var s = smoothstep(0.0, 1.0, tau / 0.32)
		p["hips_pos"] = Vector3(0.0, ground_hips_y + lerp(0.0, 0.005, s), lerp(0.0, -0.04, s))
		p["hips_rot"] = Vector3(lerp(4.0, -4.0, s), 0.0, 0.0)
		p["torso_rot"] = Vector3(lerp(6.0, -16.0, s), 0.0, 0.0)
		p["head_rot"] = Vector3(lerp(-4.0, -12.0, s), 0.0, 0.0)
		
		# Both hands heave the colossal 200kg mace straight overhead
		p["right_arm_rot"] = _lerp_angles(base_r_arm, Vector3(-145.0, 5.0, 14.0), s)
		p["right_forearm_rot"] = _lerp_angles(base_r_fore, Vector3(-35.0, 0.0, 0.0), s)
		p["warhammer_rot"] = _lerp_angles(base_hammer, Vector3(160.0, 0.0, 0.0), s)
		p["left_arm_rot"] = _lerp_angles(base_l_arm, Vector3(-140.0, -5.0, -12.0), s)
		p["left_forearm_rot"] = _lerp_angles(base_l_fore, Vector3(-40.0, 0.0, 0.0), s)
		
		p["left_thigh_rot"] = Vector3(lerp(0.0, -12.0, s), 0.0, -6.5)
		p["left_shin_rot"] = Vector3(lerp(7.0, 20.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(0.0, 10.0, s), 0.0, 6.5)
		p["right_shin_rot"] = Vector3(lerp(7.0, 14.0, s), 0.0, 0.0)
		
	elif tau < 0.48:
		# PHASE 2: Cataclysmic Forward Power Lunge & Downward Earth Slam
		var prog = (tau - 0.32) / 0.16
		var s = 1.0 - pow(1.0 - prog, 2.8)
		
		p["hips_pos"] = Vector3(0.0, lerp(ground_hips_y + 0.005, ground_hips_y + 0.015, s), lerp(-0.04, 0.18, s))
		p["hips_rot"] = Vector3(lerp(-4.0, 18.0, s), 0.0, 0.0)
		p["torso_rot"] = Vector3(lerp(-16.0, 40.0, s), 0.0, 0.0)
		p["head_rot"] = Vector3(lerp(-12.0, -10.0, s), 0.0, 0.0)
		
		# Mace slammed down into earth with both hands driving the blow forward
		p["right_arm_rot"] = Vector3(lerp(-145.0, -35.0, s), 5.0, lerp(14.0, 10.0, s))
		p["right_forearm_rot"] = Vector3(lerp(-35.0, -65.0, s), 0.0, 0.0)
		p["warhammer_rot"] = Vector3(lerp(160.0, 175.0, s), 0.0, 0.0)
		p["left_arm_rot"] = Vector3(lerp(-140.0, -32.0, s), -5.0, lerp(-12.0, -8.0, s))
		p["left_forearm_rot"] = Vector3(lerp(-40.0, -68.0, s), 0.0, 0.0)
		
		p["left_thigh_rot"] = Vector3(lerp(-12.0, -24.0, s), 0.0, -7.5)
		p["left_shin_rot"] = Vector3(lerp(20.0, 36.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(10.0, 16.0, s), 0.0, 7.5)
		p["right_shin_rot"] = Vector3(lerp(14.0, 22.0, s), 0.0, 0.0)
		
	elif tau < 0.70:
		# PHASE 3: Crater Impact Freeze & Damped Shockwave Decay (Smooth, Zero Jerk)
		var decay = 1.0 - smoothstep(0.48, 0.70, tau)
		var shake = sin(t_e * 60.0) * (0.8 * decay)
		
		p["hips_pos"] = Vector3(0.0, ground_hips_y + 0.015, 0.18)
		p["hips_rot"] = Vector3(18.0, 0.0, 0.0)
		p["torso_rot"] = Vector3(40.0 + shake, 0.0, 0.0)
		p["head_rot"] = Vector3(-10.0 + shake * 0.4, 0.0, 0.0)
		
		p["right_arm_rot"] = Vector3(-35.0 + shake * 0.5, 5.0, 10.0)
		p["right_forearm_rot"] = Vector3(-65.0, 0.0, 0.0)
		p["warhammer_rot"] = Vector3(175.0, 0.0, 0.0)
		p["left_arm_rot"] = Vector3(-32.0 + shake * 0.5, -5.0, -8.0)
		p["left_forearm_rot"] = Vector3(-68.0, 0.0, 0.0)
		
		p["left_thigh_rot"] = Vector3(-24.0, 0.0, -7.5)
		p["left_shin_rot"] = Vector3(36.0, 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(16.0, 0.0, 7.5)
		p["right_shin_rot"] = Vector3(22.0, 0.0, 0.0)
		
	else:
		# PHASE 4: Heavy Heave & Smooth Recovery Back to Base Stance
		var prog = (tau - 0.70) / 0.30
		var s = smoothstep(0.0, 1.0, prog)
		
		p["hips_pos"] = Vector3(0.0, lerp(ground_hips_y + 0.015, ground_hips_y, s), lerp(0.18, 0.0, s))
		p["hips_rot"] = Vector3(lerp(18.0, 4.0, s), 0.0, 0.0)
		p["torso_rot"] = Vector3(lerp(40.0, 6.0, s), 0.0, 0.0)
		p["head_rot"] = Vector3(lerp(-10.0, -4.0, s), 0.0, 0.0)
		
		p["right_arm_rot"] = _lerp_angles(Vector3(-35.0, 5.0, 10.0), base_r_arm, s)
		p["right_forearm_rot"] = _lerp_angles(Vector3(-65.0, 0.0, 0.0), base_r_fore, s)
		p["warhammer_rot"] = _lerp_angles(Vector3(175.0, 0.0, 0.0), base_hammer, s)
		p["left_arm_rot"] = _lerp_angles(Vector3(-32.0, -5.0, -8.0), base_l_arm, s)
		p["left_forearm_rot"] = _lerp_angles(Vector3(-68.0, 0.0, 0.0), base_l_fore, s)
		
		p["left_thigh_rot"] = Vector3(lerp(-24.0, 0.0, s), 0.0, -6.0)
		p["left_shin_rot"] = Vector3(lerp(36.0, 7.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(16.0, 0.0, s), 0.0, 6.0)
		p["right_shin_rot"] = Vector3(lerp(22.0, 7.0, s), 0.0, 0.0)
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

# --- 9. PARRY REACTION (Deflected Upward/Backward, Violent Recoil & Heavy Stumble) ---
func _compute_parry(t_p: float) -> Dictionary:
	var p: Dictionary = {}
	var tau = clampf(t_p / PARRY_DURATION, 0.0, 1.0)
	var base_cfg = _get_base_stance_cfg()
	var base_hammer = base_cfg.get("warhammer_rot", Vector3(65.0, 0.0, -52.0))
	var base_r_arm = base_cfg.get("right_arm_rot", Vector3(-32.0, 18.0, 48.0))
	var base_r_fore = base_cfg.get("right_forearm_rot", Vector3(-115.0, 0.0, 0.0))
	var base_l_arm = base_cfg.get("left_arm_rot", Vector3(15.0, 0.0, -15.0))
	var base_l_fore = base_cfg.get("left_forearm_rot", Vector3(-25.0, 0.0, 0.0))
	
	if tau < 0.18:
		# PHASE 1: Violent Clash & Explosive Deflection Outward to Right Flank
		var s = 1.0 - pow(1.0 - (tau / 0.18), 1.6)
		p["hips_pos"] = Vector3(0.0, ground_hips_y + 0.010 * s, -0.10 * s)
		p["hips_rot"] = Vector3(lerp(4.0, -12.0, s), lerp(0.0, 10.0, s), 0.0)
		p["torso_rot"] = Vector3(lerp(6.0, -22.0, s), lerp(0.0, 20.0, s), lerp(0.0, -6.0, s))
		p["head_rot"] = Vector3(lerp(-4.0, -28.0, s), lerp(0.0, 14.0, s), 0.0)
		
		# Right arm and mace blown outward and backward to right flank (zero head clipping)
		var arm_z = lerp(base_r_arm.z, 68.0, s)
		p["right_arm_rot"] = Vector3(lerp(base_r_arm.x, -20.0, s), lerp(base_r_arm.y, 10.0, s), arm_z)
		p["right_forearm_rot"] = _lerp_angles(base_r_fore, Vector3(-15.0, 0.0, 0.0), s)
		p["warhammer_rot"] = _lerp_angles(base_hammer, Vector3(88.0, 30.0, -55.0), s)
		
		# Left arm blown off grip, splayed outward for balance
		p["left_arm_rot"] = _lerp_angles(base_l_arm, Vector3(-20.0, -10.0, -60.0), s)
		p["left_forearm_rot"] = _lerp_angles(base_l_fore, Vector3(-15.0, 0.0, 0.0), s)
		
		p["left_thigh_rot"] = Vector3(lerp(0.0, 14.0, s), 0.0, -7.0)
		p["left_shin_rot"] = Vector3(lerp(7.0, 10.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(0.0, -16.0, s), 0.0, 7.0)
		p["right_shin_rot"] = Vector3(lerp(7.0, 24.0, s), 0.0, 0.0)
		
	elif tau < 0.50:
		# PHASE 2: Heavy Backward Stumble & Poise Breakdown (Mace Wide on Flank)
		var prog = (tau - 0.18) / 0.32
		var s = smoothstep(0.0, 1.0, prog)
		var dip = sin(prog * PI) * 0.025
		var shock = sin(t_p * 50.0) * (2.0 * (1.0 - prog))
		
		# Sliding backward in a heavy stumble
		p["hips_pos"] = Vector3(lerp(0.0, -0.04, s), ground_hips_y - dip, lerp(-0.10, -0.22, s))
		p["hips_rot"] = Vector3(lerp(-12.0, -8.0, s), lerp(10.0, 12.0, s), lerp(0.0, -3.0, s))
		p["torso_rot"] = Vector3(lerp(-22.0, -14.0, s) + shock, lerp(20.0, 15.0, s), -6.0)
		p["head_rot"] = Vector3(lerp(-28.0, -15.0, s), lerp(14.0, 8.0, s), 0.0)
		
		# Right arm strained fighting the recoiling mace, kept safe away from head
		p["right_arm_rot"] = Vector3(lerp(-20.0, -28.0, s) + shock, 12.0, lerp(68.0, 62.0, s))
		p["right_forearm_rot"] = Vector3(lerp(-15.0, -35.0, s), 0.0, 0.0)
		p["warhammer_rot"] = Vector3(lerp(88.0, 78.0, s), lerp(30.0, 20.0, s), -55.0 + shock * 1.5)
		
		# Left arm flailing wide for counterbalance
		p["left_arm_rot"] = Vector3(lerp(-20.0, -10.0, s), 0.0, lerp(-60.0, -48.0, s))
		p["left_forearm_rot"] = Vector3(lerp(-15.0, -25.0, s), 0.0, 0.0)
		
		# Right foot steps back hard to brake fall; left foot drags
		p["right_thigh_rot"] = Vector3(lerp(-16.0, -32.0, s), 0.0, 8.0)
		p["right_shin_rot"] = Vector3(lerp(24.0, 44.0, s), 0.0, 0.0)
		p["left_thigh_rot"] = Vector3(lerp(14.0, 24.0, s), 0.0, -8.0)
		p["left_shin_rot"] = Vector3(lerp(10.0, 15.0, s), 0.0, 0.0)
		
	elif tau < 0.74:
		# PHASE 3: Regaining Balance & Firm Heel Stomp (Lowering Outside Shoulder)
		var prog = (tau - 0.50) / 0.24
		var s = smoothstep(0.0, 1.0, prog)
		var head_shake_z = sin(prog * 3.0 * PI) * 4.0
		
		p["hips_pos"] = Vector3(lerp(-0.04, 0.0, s), ground_hips_y, lerp(-0.22, -0.12, s))
		p["hips_rot"] = Vector3(lerp(-8.0, 4.0, s), lerp(12.0, 4.0, s), lerp(-3.0, 0.0, s))
		p["torso_rot"] = Vector3(lerp(-14.0, 10.0, s), lerp(15.0, 4.0, s), lerp(-6.0, 0.0, s))
		p["head_rot"] = Vector3(lerp(-15.0, -6.0, s), lerp(8.0, 0.0, s), head_shake_z)
		
		# Right arm guides mace back outside shoulder line
		p["right_arm_rot"] = _lerp_angles(Vector3(-28.0, 12.0, 62.0), Vector3(-32.0, 16.0, 55.0), s)
		p["right_forearm_rot"] = _lerp_angles(Vector3(-35.0, 0.0, 0.0), Vector3(-105.0, 0.0, 0.0), s)
		p["warhammer_rot"] = _lerp_angles(Vector3(78.0, 20.0, -55.0), Vector3(66.0, 5.0, -54.0), s)
		p["left_arm_rot"] = _lerp_angles(Vector3(-10.0, 0.0, -48.0), Vector3(10.0, 0.0, -20.0), s)
		p["left_forearm_rot"] = _lerp_angles(Vector3(-25.0, 0.0, 0.0), Vector3(-30.0, 0.0, 0.0), s)
		
		p["right_thigh_rot"] = Vector3(lerp(-32.0, -12.0, s), 0.0, 7.0)
		p["right_shin_rot"] = Vector3(lerp(44.0, 20.0, s), 0.0, 0.0)
		p["left_thigh_rot"] = Vector3(lerp(24.0, 10.0, s), 0.0, -7.0)
		p["left_shin_rot"] = Vector3(lerp(15.0, 10.0, s), 0.0, 0.0)
		
	else:
		# PHASE 4: Muscular Step-Up Back to Base Stance
		var prog = (tau - 0.74) / 0.26
		var s = smoothstep(0.0, 1.0, prog)
		
		p["hips_pos"] = Vector3(0.0, ground_hips_y, lerp(-0.12, 0.0, s))
		p["hips_rot"] = Vector3(lerp(4.0, 4.0, s), lerp(4.0, 0.0, s), 0.0)
		p["torso_rot"] = Vector3(lerp(10.0, 6.0, s), lerp(4.0, 0.0, s), 0.0)
		p["head_rot"] = Vector3(lerp(-6.0, -4.0, s), 0.0, 0.0)
		
		p["right_arm_rot"] = _lerp_angles(Vector3(-32.0, 16.0, 55.0), base_r_arm, s)
		p["right_forearm_rot"] = _lerp_angles(Vector3(-105.0, 0.0, 0.0), base_r_fore, s)
		p["warhammer_rot"] = _lerp_angles(Vector3(66.0, 5.0, -54.0), base_hammer, s)
		p["left_arm_rot"] = _lerp_angles(Vector3(10.0, 0.0, -20.0), base_l_arm, s)
		p["left_forearm_rot"] = _lerp_angles(Vector3(-30.0, 0.0, 0.0), base_l_fore, s)
		
		p["left_thigh_rot"] = Vector3(lerp(10.0, 0.0, s), 0.0, -6.0)
		p["left_shin_rot"] = Vector3(lerp(10.0, 7.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(-12.0, 0.0, s), 0.0, 6.0)
		p["right_shin_rot"] = Vector3(lerp(20.0, 7.0, s), 0.0, 0.0)
		
	return p

func _compute_stagger(t_s: float) -> Dictionary:
	return _compute_parry(t_s)

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
