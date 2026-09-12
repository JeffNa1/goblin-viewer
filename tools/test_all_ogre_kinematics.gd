extends SceneTree

func _init() -> void:
	call_deferred("_run_full_audit")

func _run_full_audit() -> void:
	var scene = load("res://scenes/goblin_chieftain.tscn")
	var ogre: GoblinChieftain = scene.instantiate()
	root.add_child(ogre)
	await process_frame
	await process_frame
	ogre.set_process(false)
	
	print("==================================================================")
	print(">>> FULL KINEMATICS & GROUND CONTACT AUDIT FOR ALL OGRE ANIMATIONS <<<")
	print("==================================================================")
	
	# Set ground_hips_y to calibrated 0.598
	ogre.ground_hips_y = 0.598
	
	var anim_list = [
		{"name": "shoulder", "dur": 1.0, "type": "loop"},
		{"name": "ground", "dur": 1.0, "type": "loop"},
		{"name": "guard", "dur": 1.0, "type": "loop"},
		{"name": "walk", "dur": 2.5, "type": "loop"},
		{"name": "roar", "dur": 1.8, "type": "action"},
		{"name": "earthshaker", "dur": 2.0, "type": "action"},
		{"name": "whirlwind", "dur": 1.7, "type": "action"},
		{"name": "stagger", "dur": 1.6, "type": "action"},
		{"name": "stunned", "dur": 2.8, "type": "loop"}
	]
	
	for anim_info in anim_list:
		var a_name = anim_info["name"]
		var dur = anim_info["dur"]
		var min_plant = 999.0
		var max_plant = -999.0
		var samples = 20
		
		for i in range(samples + 1):
			var t = (float(i) / float(samples)) * dur
			var pose = _compute_test_pose(a_name, t, ogre.ground_hips_y)
			ogre._apply_pose(pose)
			ogre.hips.force_update_transform()
			ogre.left_shin.force_update_transform()
			ogre.right_shin.force_update_transform()
			
			var l_y = _get_min_y(ogre.left_shin_mesh)
			var r_y = _get_min_y(ogre.right_shin_mesh)
			var plant_y = minf(l_y, r_y)
			
			# In airborne phase of earthshaker leap, plant_y can be > 0 (feet in air!)
			if a_name == "earthshaker" and t >= 0.35 and t <= 0.85:
				pass # Airborne phase: feet are naturally in the air!
			else:
				if plant_y < min_plant: min_plant = plant_y
				if plant_y > max_plant: max_plant = plant_y
				
		print("Anim %-12s: Grounded Foot Y Range = [%+6.1f mm to %+6.1f mm]" % [
			a_name, min_plant * 1000.0, max_plant * 1000.0
		])
		
	quit(0)

func _compute_test_pose(anim: String, t: float, ground_hips_y: float) -> Dictionary:
	match anim:
		"shoulder": return _compute_shoulder_new(t, ground_hips_y)
		"ground": return _compute_ground_new(t, ground_hips_y)
		"guard": return _compute_guard_new(t, ground_hips_y)
		"walk": return _compute_walk_new(t, ground_hips_y)
		"roar": return _compute_roar_new(t, ground_hips_y)
		"earthshaker": return _compute_earthshaker_new(t, ground_hips_y)
		"whirlwind": return _compute_whirlwind_new(t, ground_hips_y)
		"stagger": return _compute_stagger_new(t, ground_hips_y)
		"stunned": return _compute_stunned_new(t, ground_hips_y)
		_: return _compute_shoulder_new(t, ground_hips_y)

# 1. SHOULDER
func _compute_shoulder_new(t_val: float, ground_hips_y: float) -> Dictionary:
	var p: Dictionary = {}
	var t = t_val * 1.6
	var heave = sin(t)
	var sway = sin(t * 0.5)
	
	# Pelvis stays grounded at exact floor height, slight lateral weight shift
	p["hips_pos"] = Vector3(sway * 0.008, ground_hips_y, 0.0)
	p["hips_rot"] = Vector3(4.0, sway * 2.5, 0.0)
	
	# Deep chest breathing in thoracic spine
	p["torso_rot"] = Vector3(6.0 + heave * 2.5, -sway * 2.0, 0.0)
	p["head_rot"] = Vector3(-4.0 - heave * 1.5, sway * 5.0, 0.0)
	
	# Arms
	p["right_arm_rot"] = Vector3(-32.0 + heave * 1.8, 25.0, 35.0)
	p["right_forearm_rot"] = Vector3(-115.0, 0.0, 0.0)
	p["warhammer_rot"] = Vector3(65.0 + heave * 1.2, 0.0, -30.0)
	p["left_arm_rot"] = Vector3(15.0 - heave * 2.0, 0.0, -15.0)
	p["left_forearm_rot"] = Vector3(-25.0 - heave * 3.0, 0.0, 0.0)
	
	# Balanced solid stance: both feet touch floor
	p["left_thigh_rot"] = Vector3(0.0, 0.0, -6.0)
	p["left_shin_rot"] = Vector3(7.0, 0.0, 0.0)
	p["right_thigh_rot"] = Vector3(0.0, 0.0, 6.0)
	p["right_shin_rot"] = Vector3(7.0, 0.0, 0.0)
	return p

# 2. GROUND
func _compute_ground_new(t_val: float, ground_hips_y: float) -> Dictionary:
	var p: Dictionary = {}
	var t = t_val * 1.6
	var heave = sin(t)
	var sway = sin(t * 0.4)
	
	# Resting weight on right leg and mace
	# Resting weight on right leg and mace
	p["hips_pos"] = Vector3(0.02, ground_hips_y + 0.001, 0.0)
	p["hips_rot"] = Vector3(3.0, 4.0 + sway * 1.5, -2.0)
	p["torso_rot"] = Vector3(8.0 + heave * 2.0, -2.0, 2.0)
	p["head_rot"] = Vector3(-2.0, 6.0 + sway * 4.0, 0.0)
	
	p["right_arm_rot"] = Vector3(-15.0 + heave * 1.5, 10.0, 24.0)
	p["right_forearm_rot"] = Vector3(-42.0, 0.0, 0.0)
	p["warhammer_rot"] = Vector3(15.0, 0.0, -10.0)
	p["left_arm_rot"] = Vector3(0.0 - heave * 1.5, 0.0, -18.0)
	p["left_forearm_rot"] = Vector3(-18.0, 0.0, 0.0)
	
	# Right leg takes weight, left leg kickstand
	p["left_thigh_rot"] = Vector3(-4.0, 0.0, -7.5)
	p["left_shin_rot"] = Vector3(9.5, 0.0, 0.0)
	p["right_thigh_rot"] = Vector3(1.0, 0.0, 5.0)
	p["right_shin_rot"] = Vector3(6.0, 0.0, 0.0)
	return p

# 3. GUARD
func _compute_guard_new(t_val: float, ground_hips_y: float) -> Dictionary:
	var p: Dictionary = {}
	var t = t_val * 2.0
	var heave = sin(t)
	
	# Low center of gravity battle crouch
	p["hips_pos"] = Vector3(0.0, ground_hips_y + 0.008, 0.0)
	p["hips_rot"] = Vector3(8.0, 0.0, 0.0)
	p["torso_rot"] = Vector3(12.0 + heave * 2.0, 0.0, 0.0)
	p["head_rot"] = Vector3(-6.0, 0.0, 0.0)
	
	p["right_arm_rot"] = Vector3(-38.0 + heave * 1.5, -10.0, 18.0)
	p["right_forearm_rot"] = Vector3(-75.0, 0.0, 0.0)
	p["warhammer_rot"] = Vector3(120.0, 25.0, -45.0)
	p["left_arm_rot"] = Vector3(-42.0 + heave * 1.5, 18.0, -15.0)
	p["left_forearm_rot"] = Vector3(-80.0, 0.0, 0.0)
	
	# Braced wide feet
	p["left_thigh_rot"] = Vector3(-10.0, 0.0, -7.5)
	p["left_shin_rot"] = Vector3(14.5, 0.0, 0.0)
	p["right_thigh_rot"] = Vector3(8.0, 0.0, 7.5)
	p["right_shin_rot"] = Vector3(11.5, 0.0, 0.0)
	return p

# 4. WALK
func _compute_walk_new(t_val: float, ground_hips_y: float) -> Dictionary:
	var p: Dictionary = {}
	var t = t_val * 2.5 # ~1.25s stride cycle
	var s_leg = sin(t)
	var c_leg = cos(t)
	
	# Bobbing and sway
	var bob = -cos(2.0 * t) * 0.020
	var sway = s_leg * 0.038
	p["hips_pos"] = Vector3(sway, ground_hips_y + bob - 0.005, 0.0)
	p["hips_rot"] = Vector3(10.0 + cos(2.0 * t) * 1.5, s_leg * 7.0, -c_leg * 4.0)
	p["torso_rot"] = Vector3(12.0 - cos(2.0 * t) * 2.0, -s_leg * 6.0, c_leg * 3.0)
	p["head_rot"] = Vector3(-6.0 + cos(2.0 * t) * 1.5, -s_leg * 3.0, -c_leg * 2.0)
	
	# Legs
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
	
	# Heavy hammer inertia & dynamic arm motion
	var hammer_heave = cos(2.0 * t) * 3.5
	var arm_r_swing = cos(t) * 8.0
	var elbow_r_cushion = -cos(2.0 * t) * 5.0
	var hammer_inertia = cos(t - 0.3) * 6.0 + sin(2.0 * t) * 3.0
	p["right_arm_rot"] = Vector3(25.0 + arm_r_swing + hammer_heave, -10.0, 30.0 + sin(t) * 2.0)
	p["right_forearm_rot"] = Vector3(-20.0 + elbow_r_cushion, 0.0, 0.0)
	p["warhammer_rot"] = Vector3(145.0 + hammer_inertia, 0.0, -10.0)
	
	var arm_l_swing = -s_leg * 22.0
	var elbow_l_flex = s_leg * 16.0
	p["left_arm_rot"] = Vector3(arm_l_swing, 0.0, -20.0 - c_leg * 3.0)
	p["left_forearm_rot"] = Vector3(-25.0 + elbow_l_flex, 0.0, 0.0)
	return p

# 5. ROAR
func _compute_roar_new(t_r: float, ground_hips_y: float) -> Dictionary:
	var p: Dictionary = {}
	var dur = 1.80
	var tau = clampf(t_r / dur, 0.0, 1.0)
	
	if tau < 0.22:
		# Windup & deep compression
		var s = smoothstep(0.0, 1.0, tau / 0.22)
		p["hips_pos"] = Vector3(0.0, ground_hips_y - s * 0.012, 0.0)
		p["hips_rot"] = Vector3(lerp(4.0, 12.0, s), 0.0, 0.0)
		p["torso_rot"] = Vector3(lerp(6.0, 18.0, s), 0.0, 0.0)
		p["head_rot"] = Vector3(lerp(-4.0, -14.0, s), 0.0, 0.0)
		p["left_arm_rot"] = Vector3(lerp(15.0, 20.0, s), lerp(0.0, 35.0, s), lerp(-15.0, 10.0, s))
		p["left_forearm_rot"] = Vector3(lerp(-25.0, -90.0, s), 0.0, 0.0)
		p["right_arm_rot"] = Vector3(lerp(-32.0, -45.0, s), lerp(25.0, 10.0, s), lerp(35.0, 30.0, s))
		p["right_forearm_rot"] = Vector3(lerp(-115.0, -75.0, s), 0.0, 0.0)
		p["warhammer_rot"] = Vector3(lerp(65.0, 85.0, s), 0.0, lerp(-30.0, -10.0, s))
		p["left_thigh_rot"] = Vector3(lerp(0.0, -8.0, s), 0.0, -6.5)
		p["left_shin_rot"] = Vector3(lerp(7.0, 14.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(0.0, 6.0, s), 0.0, 6.5)
		p["right_shin_rot"] = Vector3(lerp(7.0, 12.0, s), 0.0, 0.0)
		
	elif tau < 0.38:
		# Chest pound impact!
		var s = (tau - 0.22) / 0.16
		var impact = sin(s * PI)
		p["hips_pos"] = Vector3(0.0, ground_hips_y - 0.012, 0.0)
		p["hips_rot"] = Vector3(12.0 - impact * 3.0, 0.0, 0.0)
		p["torso_rot"] = Vector3(18.0 - impact * 6.0, 0.0, 0.0)
		p["head_rot"] = Vector3(-14.0 + impact * 5.0, 0.0, 0.0)
		p["left_arm_rot"] = Vector3(-55.0, 45.0, 20.0)
		p["left_forearm_rot"] = Vector3(-125.0, 0.0, 0.0)
		p["right_arm_rot"] = Vector3(-45.0, 10.0, 30.0)
		p["right_forearm_rot"] = Vector3(-75.0, 0.0, 0.0)
		p["warhammer_rot"] = Vector3(85.0, 0.0, -10.0)
		p["left_thigh_rot"] = Vector3(-8.0, 0.0, -6.5)
		p["left_shin_rot"] = Vector3(14.0, 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(6.0, 0.0, 6.5)
		p["right_shin_rot"] = Vector3(12.0, 0.0, 0.0)
		
	elif tau < 0.80:
		# TITANIC SKYWARD BELLOW with hammer aloft & body vibration
		var s = smoothstep(0.0, 1.0, (tau - 0.38) / 0.15)
		var shake = sin(t_r * 65.0) * 1.6
		p["hips_pos"] = Vector3(0.0, ground_hips_y, 0.0)
		p["hips_rot"] = Vector3(lerp(12.0, -4.0, s), 0.0, 0.0)
		p["torso_rot"] = Vector3(lerp(18.0, -28.0, s) + shake, 0.0, 0.0)
		p["head_rot"] = Vector3(lerp(-14.0, -42.0, s) + shake * 0.8, 0.0, 0.0)
		
		# Hammer held straight to the heavens
		p["right_arm_rot"] = Vector3(lerp(-45.0, -145.0, s) + shake, 10.0, 22.0)
		p["right_forearm_rot"] = Vector3(lerp(-75.0, -10.0, s), 0.0, 0.0)
		p["warhammer_rot"] = Vector3(lerp(85.0, 0.0, s), 0.0, 0.0)
		
		# Left arm wide splay
		p["left_arm_rot"] = Vector3(lerp(-55.0, -115.0, s) + shake, -20.0, -50.0)
		p["left_forearm_rot"] = Vector3(lerp(-125.0, -35.0, s), 0.0, 0.0)
		
		p["left_thigh_rot"] = Vector3(lerp(-8.0, 0.0, s), 0.0, -6.0)
		p["left_shin_rot"] = Vector3(lerp(14.0, 7.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(6.0, 0.0, s), 0.0, 6.0)
		p["right_shin_rot"] = Vector3(lerp(12.0, 7.0, s), 0.0, 0.0)
		
	else:
		# Smooth recovery
		var s = smoothstep(0.0, 1.0, (tau - 0.80) / 0.20)
		p["hips_pos"] = Vector3(0.0, ground_hips_y, 0.0)
		p["hips_rot"] = Vector3(lerp(-4.0, 4.0, s), 0.0, 0.0)
		p["torso_rot"] = Vector3(lerp(-28.0, 6.0, s), 0.0, 0.0)
		p["head_rot"] = Vector3(lerp(-42.0, -4.0, s), 0.0, 0.0)
		p["right_arm_rot"] = Vector3(lerp(-145.0, -32.0, s), lerp(10.0, 25.0, s), lerp(22.0, 35.0, s))
		p["right_forearm_rot"] = Vector3(lerp(-10.0, -115.0, s), 0.0, 0.0)
		p["warhammer_rot"] = Vector3(lerp(0.0, 65.0, s), 0.0, lerp(0.0, -30.0, s))
		p["left_arm_rot"] = Vector3(lerp(-115.0, 15.0, s), lerp(-20.0, 0.0, s), lerp(-50.0, -15.0, s))
		p["left_forearm_rot"] = Vector3(lerp(-35.0, -25.0, s), 0.0, 0.0)
		p["left_thigh_rot"] = Vector3(0.0, 0.0, -6.0)
		p["left_shin_rot"] = Vector3(7.0, 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(0.0, 0.0, 6.0)
		p["right_shin_rot"] = Vector3(7.0, 0.0, 0.0)
	return p

# 6. EARTHSHAKER
func _compute_earthshaker_new(t_e: float, ground_hips_y: float) -> Dictionary:
	var p: Dictionary = {}
	var dur = 2.00
	var tau = clampf(t_e / dur, 0.0, 1.0)
	
	if tau < 0.17:
		# Deep crouch preparation
		var s = smoothstep(0.0, 1.0, tau / 0.17)
		p["hips_pos"] = Vector3(0.0, ground_hips_y - s * 0.025, 0.0)
		p["hips_rot"] = Vector3(lerp(4.0, 14.0, s), 0.0, 0.0)
		p["torso_rot"] = Vector3(lerp(6.0, 24.0, s), 0.0, 0.0)
		p["head_rot"] = Vector3(lerp(-4.0, -12.0, s), 0.0, 0.0)
		p["right_arm_rot"] = Vector3(lerp(-32.0, -65.0, s), lerp(25.0, 10.0, s), lerp(35.0, 15.0, s))
		p["right_forearm_rot"] = Vector3(lerp(-115.0, -50.0, s), 0.0, 0.0)
		p["warhammer_rot"] = Vector3(lerp(65.0, 30.0, s), 0.0, lerp(-30.0, 0.0, s))
		p["left_arm_rot"] = Vector3(lerp(15.0, -55.0, s), lerp(0.0, -10.0, s), lerp(-15.0, -15.0, s))
		p["left_forearm_rot"] = Vector3(lerp(-25.0, -50.0, s), 0.0, 0.0)
		p["left_thigh_rot"] = Vector3(lerp(0.0, -16.0, s), 0.0, -7.5)
		p["left_shin_rot"] = Vector3(lerp(7.0, 24.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(0.0, 12.0, s), 0.0, 7.5)
		p["right_shin_rot"] = Vector3(lerp(7.0, 20.0, s), 0.0, 0.0)
		
	elif tau < 0.42:
		# TITANIC LEAP INTO THE AIR
		var s = (tau - 0.17) / 0.25
		var y_arc = sin(s * PI) * 0.35
		var z_adv = s * 0.25
		p["hips_pos"] = Vector3(0.0, ground_hips_y + y_arc, z_adv)
		p["hips_rot"] = Vector3(lerp(14.0, -18.0, s), 0.0, 0.0)
		p["torso_rot"] = Vector3(lerp(24.0, -36.0, s), 0.0, 0.0)
		p["head_rot"] = Vector3(lerp(-12.0, 16.0, s), 0.0, 0.0)
		
		# 2 hands raise hammer high overhead
		p["right_arm_rot"] = Vector3(lerp(-65.0, -155.0, s), 5.0, 15.0)
		p["right_forearm_rot"] = Vector3(lerp(-50.0, -25.0, s), 0.0, 0.0)
		p["warhammer_rot"] = Vector3(lerp(30.0, -35.0, s), 0.0, 0.0)
		p["left_arm_rot"] = Vector3(lerp(-55.0, -145.0, s), -5.0, -15.0)
		p["left_forearm_rot"] = Vector3(lerp(-50.0, -35.0, s), 0.0, 0.0)
		
		p["left_thigh_rot"] = Vector3(lerp(-16.0, -30.0, s), 0.0, -6.5)
		p["left_shin_rot"] = Vector3(lerp(24.0, 45.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(12.0, -15.0, s), 0.0, 6.5)
		p["right_shin_rot"] = Vector3(lerp(20.0, 40.0, s), 0.0, 0.0)
		
	elif tau < 0.50:
		# CATACLYSMIC GRAVITY PLUMMET & IMPACT
		var s = smoothstep(0.0, 1.0, (tau - 0.42) / 0.08)
		p["hips_pos"] = Vector3(0.0, lerp(ground_hips_y + 0.12, ground_hips_y - 0.028, s), 0.25)
		p["hips_rot"] = Vector3(lerp(-18.0, 24.0, s), 0.0, 0.0)
		p["torso_rot"] = Vector3(lerp(-36.0, 50.0, s), 0.0, 0.0)
		p["head_rot"] = Vector3(lerp(16.0, -18.0, s), 0.0, 0.0)
		
		# Hammer smashes into the floor!
		p["right_arm_rot"] = Vector3(lerp(-155.0, -32.0, s), 0.0, 10.0)
		p["right_forearm_rot"] = Vector3(lerp(-25.0, -75.0, s), 0.0, 0.0)
		p["warhammer_rot"] = Vector3(lerp(-35.0, 80.0, s), 0.0, 0.0)
		p["left_arm_rot"] = Vector3(lerp(-145.0, -22.0, s), 0.0, -20.0)
		p["left_forearm_rot"] = Vector3(lerp(-35.0, -60.0, s), 0.0, 0.0)
		
		p["left_thigh_rot"] = Vector3(lerp(-30.0, -22.0, s), 0.0, -8.5)
		p["left_shin_rot"] = Vector3(lerp(45.0, 32.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(-15.0, 18.0, s), 0.0, 8.5)
		p["right_shin_rot"] = Vector3(lerp(40.0, 26.0, s), 0.0, 0.0)
		
	elif tau < 0.72:
		# CRATER FREEZE & HIT-STOP SHOCKWAVE TREMOR
		var shake = sin(t_e * 75.0) * 0.9
		p["hips_pos"] = Vector3(0.0, ground_hips_y - 0.028, 0.25)
		p["hips_rot"] = Vector3(24.0, 0.0, 0.0)
		p["torso_rot"] = Vector3(50.0 + shake, 0.0, 0.0)
		p["head_rot"] = Vector3(-18.0 + shake * 0.5, 0.0, 0.0)
		
		p["right_arm_rot"] = Vector3(-32.0 + shake * 0.7, 0.0, 10.0)
		p["right_forearm_rot"] = Vector3(-75.0, 0.0, 0.0)
		p["warhammer_rot"] = Vector3(80.0, 0.0, 0.0)
		p["left_arm_rot"] = Vector3(-22.0 + shake * 0.7, 0.0, -20.0)
		p["left_forearm_rot"] = Vector3(-60.0, 0.0, 0.0)
		
		p["left_thigh_rot"] = Vector3(-22.0, 0.0, -8.5)
		p["left_shin_rot"] = Vector3(32.0, 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(18.0, 0.0, 8.5)
		p["right_shin_rot"] = Vector3(26.0, 0.0, 0.0)
		
	else:
		# PULL HAMMER FROM CRATER & RECOVER
		var s = smoothstep(0.0, 1.0, (tau - 0.72) / 0.28)
		p["hips_pos"] = Vector3(0.0, lerp(ground_hips_y - 0.028, ground_hips_y, s), lerp(0.25, 0.0, s))
		p["hips_rot"] = Vector3(lerp(24.0, 4.0, s), 0.0, 0.0)
		p["torso_rot"] = Vector3(lerp(50.0, 6.0, s), 0.0, 0.0)
		p["head_rot"] = Vector3(lerp(-18.0, -4.0, s), 0.0, 0.0)
		p["right_arm_rot"] = Vector3(lerp(-32.0, -32.0, s), lerp(0.0, 25.0, s), lerp(10.0, 35.0, s))
		p["right_forearm_rot"] = Vector3(lerp(-75.0, -115.0, s), 0.0, 0.0)
		p["warhammer_rot"] = Vector3(lerp(80.0, 65.0, s), 0.0, lerp(0.0, -30.0, s))
		p["left_arm_rot"] = Vector3(lerp(-22.0, 15.0, s), 0.0, lerp(-20.0, -15.0, s))
		p["left_forearm_rot"] = Vector3(lerp(-60.0, -25.0, s), 0.0, 0.0)
		p["left_thigh_rot"] = Vector3(lerp(-22.0, 0.0, s), 0.0, -6.0)
		p["left_shin_rot"] = Vector3(lerp(32.0, 7.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(18.0, 0.0, s), 0.0, 6.0)
		p["right_shin_rot"] = Vector3(lerp(26.0, 7.0, s), 0.0, 0.0)
	return p

# 7. WHIRLWIND
func _compute_whirlwind_new(t_w: float, ground_hips_y: float) -> Dictionary:
	var p: Dictionary = {}
	var dur = 1.70
	var tau = clampf(t_w / dur, 0.0, 1.0)
	
	if tau < 0.20:
		# Windup torque: coiling left
		var s = smoothstep(0.0, 1.0, tau / 0.20)
		p["hips_pos"] = Vector3(0.0, ground_hips_y - s * 0.010, 0.0)
		p["hips_rot"] = Vector3(8.0, lerp(0.0, -50.0, s), 0.0)
		p["torso_rot"] = Vector3(14.0, lerp(0.0, -60.0, s), 0.0)
		p["head_rot"] = Vector3(-8.0, lerp(0.0, 45.0, s), 0.0)
		p["right_arm_rot"] = Vector3(lerp(-32.0, 35.0, s), lerp(25.0, -45.0, s), lerp(35.0, 45.0, s))
		p["right_forearm_rot"] = Vector3(lerp(-115.0, -35.0, s), 0.0, 0.0)
		p["warhammer_rot"] = Vector3(lerp(65.0, 110.0, s), 0.0, lerp(-30.0, 0.0, s))
		p["left_arm_rot"] = Vector3(lerp(15.0, -25.0, s), lerp(0.0, 20.0, s), lerp(-15.0, -25.0, s))
		p["left_forearm_rot"] = Vector3(lerp(-25.0, -65.0, s), 0.0, 0.0)
		p["left_thigh_rot"] = Vector3(lerp(0.0, -10.0, s), 0.0, -7.0)
		p["left_shin_rot"] = Vector3(lerp(7.0, 16.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(0.0, 8.0, s), 0.0, 7.0)
		p["right_shin_rot"] = Vector3(lerp(7.0, 14.0, s), 0.0, 0.0)
		
	elif tau < 0.68:
		# 360 DEGREE EXPLOSIVE CENTRIFUGAL SWEEP
		var s = (tau - 0.20) / 0.48
		var spin_angle = -50.0 + s * 360.0
		p["hips_pos"] = Vector3(0.0, ground_hips_y - 0.008, 0.0)
		p["hips_rot"] = Vector3(10.0, spin_angle, 0.0)
		p["torso_rot"] = Vector3(14.0, spin_angle * 0.12, 0.0)
		p["head_rot"] = Vector3(-8.0, 0.0, 0.0)
		
		# Centrifugal arm extension
		p["right_arm_rot"] = Vector3(-10.0, 0.0, 80.0)
		p["right_forearm_rot"] = Vector3(-12.0, 0.0, 0.0)
		p["warhammer_rot"] = Vector3(90.0, 0.0, 0.0)
		p["left_arm_rot"] = Vector3(-10.0, 0.0, -80.0)
		p["left_forearm_rot"] = Vector3(-12.0, 0.0, 0.0)
		
		var step_leg = sin(s * TAU * 2.0) * 12.0
		p["left_thigh_rot"] = Vector3(step_leg, 0.0, -6.5)
		p["left_shin_rot"] = Vector3(14.0, 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(-step_leg, 0.0, 6.5)
		p["right_shin_rot"] = Vector3(14.0, 0.0, 0.0)
		
	else:
		# INERTIAL DRAG BRAKE & OVERSHOOT RECOVERY
		var s = smoothstep(0.0, 1.0, (tau - 0.68) / 0.32)
		var overshoot_yaw = lerp(35.0, 0.0, s)
		p["hips_pos"] = Vector3(0.0, ground_hips_y, 0.0)
		p["hips_rot"] = Vector3(lerp(10.0, 4.0, s), overshoot_yaw, 0.0)
		p["torso_rot"] = Vector3(lerp(14.0, 6.0, s), overshoot_yaw * 0.5, 0.0)
		p["head_rot"] = Vector3(-4.0, 0.0, 0.0)
		p["right_arm_rot"] = Vector3(lerp(-10.0, -32.0, s), lerp(0.0, 25.0, s), lerp(80.0, 35.0, s))
		p["right_forearm_rot"] = Vector3(lerp(-12.0, -115.0, s), 0.0, 0.0)
		p["warhammer_rot"] = Vector3(lerp(90.0, 65.0, s), 0.0, lerp(0.0, -30.0, s))
		p["left_arm_rot"] = Vector3(lerp(-10.0, 15.0, s), 0.0, lerp(-80.0, -15.0, s))
		p["left_forearm_rot"] = Vector3(lerp(-12.0, -25.0, s), 0.0, 0.0)
		p["left_thigh_rot"] = Vector3(0.0, 0.0, -6.0)
		p["left_shin_rot"] = Vector3(7.0, 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(0.0, 0.0, 6.0)
		p["right_shin_rot"] = Vector3(7.0, 0.0, 0.0)
	return p

# 8. STAGGER
func _compute_stagger_new(t_s: float, ground_hips_y: float) -> Dictionary:
	var p: Dictionary = {}
	var dur = 1.60
	var tau = clampf(t_s / dur, 0.0, 1.0)
	
	if tau < 0.20:
		# Crushing impact recoil back
		var s = smoothstep(0.0, 1.0, tau / 0.20)
		p["hips_pos"] = Vector3(0.0, ground_hips_y - s * 0.015, -s * 0.08)
		p["hips_rot"] = Vector3(lerp(4.0, -14.0, s), 0.0, 0.0)
		p["torso_rot"] = Vector3(lerp(6.0, -26.0, s), 0.0, 0.0)
		p["head_rot"] = Vector3(lerp(-4.0, -28.0, s), 0.0, 0.0)
		p["right_arm_rot"] = Vector3(lerp(-32.0, -20.0, s), lerp(25.0, 10.0, s), lerp(35.0, 25.0, s))
		p["right_forearm_rot"] = Vector3(lerp(-115.0, -45.0, s), 0.0, 0.0)
		p["warhammer_rot"] = Vector3(lerp(65.0, 45.0, s), 0.0, lerp(-30.0, 0.0, s))
		p["left_arm_rot"] = Vector3(lerp(15.0, 35.0, s), 0.0, lerp(-15.0, -35.0, s))
		p["left_forearm_rot"] = Vector3(lerp(-25.0, -15.0, s), 0.0, 0.0)
		p["left_thigh_rot"] = Vector3(lerp(0.0, -12.0, s), 0.0, -7.0)
		p["left_shin_rot"] = Vector3(lerp(7.0, 18.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(0.0, 16.0, s), 0.0, 7.0)
		p["right_shin_rot"] = Vector3(lerp(7.0, 15.0, s), 0.0, 0.0)
		
	elif tau < 0.45:
		# Knee collapse & ground hand plant
		var s = smoothstep(0.0, 1.0, (tau - 0.20) / 0.25)
		p["hips_pos"] = Vector3(0.0, lerp(ground_hips_y - 0.015, ground_hips_y - 0.045, s), lerp(-0.08, -0.12, s))
		p["hips_rot"] = Vector3(lerp(-14.0, 16.0, s), 0.0, 0.0)
		p["torso_rot"] = Vector3(lerp(-26.0, 35.0, s), 0.0, 0.0)
		p["head_rot"] = Vector3(lerp(-28.0, -18.0, s), 0.0, 0.0)
		
		# Hammer planted like crutch, left hand plants on floor
		p["right_arm_rot"] = Vector3(-35.0, 0.0, 18.0)
		p["right_forearm_rot"] = Vector3(-65.0, 0.0, 0.0)
		p["warhammer_rot"] = Vector3(75.0, 0.0, 0.0)
		p["left_arm_rot"] = Vector3(28.0, 0.0, -25.0)
		p["left_forearm_rot"] = Vector3(-20.0, 0.0, 0.0)
		
		p["left_thigh_rot"] = Vector3(lerp(-12.0, -28.0, s), 0.0, -8.0)
		p["left_shin_rot"] = Vector3(lerp(18.0, 42.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(16.0, 36.0, s), 0.0, 8.0)
		p["right_shin_rot"] = Vector3(lerp(15.0, 48.0, s), 0.0, 0.0)
		
	elif tau < 0.75:
		# Panting & groggy on knee
		var pant = sin(t_s * 14.0) * 0.015
		p["hips_pos"] = Vector3(0.0, ground_hips_y - 0.045 + pant, -0.12)
		p["hips_rot"] = Vector3(16.0, 0.0, 0.0)
		p["torso_rot"] = Vector3(35.0 + pant * 80.0, 0.0, 0.0)
		p["head_rot"] = Vector3(-18.0, 0.0, 0.0)
		p["right_arm_rot"] = Vector3(-35.0, 0.0, 18.0)
		p["right_forearm_rot"] = Vector3(-65.0, 0.0, 0.0)
		p["warhammer_rot"] = Vector3(75.0, 0.0, 0.0)
		p["left_arm_rot"] = Vector3(28.0, 0.0, -25.0)
		p["left_forearm_rot"] = Vector3(-20.0, 0.0, 0.0)
		p["left_thigh_rot"] = Vector3(-28.0, 0.0, -8.0)
		p["left_shin_rot"] = Vector3(42.0, 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(36.0, 0.0, 8.0)
		p["right_shin_rot"] = Vector3(48.0, 0.0, 0.0)
		
	else:
		# Furious ground push-off & recovery
		var s = smoothstep(0.0, 1.0, (tau - 0.75) / 0.25)
		p["hips_pos"] = Vector3(0.0, lerp(ground_hips_y - 0.045, ground_hips_y, s), lerp(-0.12, 0.0, s))
		p["hips_rot"] = Vector3(lerp(16.0, 4.0, s), 0.0, 0.0)
		p["torso_rot"] = Vector3(lerp(35.0, 6.0, s), 0.0, 0.0)
		p["head_rot"] = Vector3(lerp(-18.0, -4.0, s), 0.0, 0.0)
		p["right_arm_rot"] = Vector3(lerp(-35.0, -32.0, s), lerp(0.0, 25.0, s), lerp(18.0, 35.0, s))
		p["right_forearm_rot"] = Vector3(lerp(-65.0, -115.0, s), 0.0, 0.0)
		p["warhammer_rot"] = Vector3(lerp(75.0, 65.0, s), 0.0, lerp(0.0, -30.0, s))
		p["left_arm_rot"] = Vector3(lerp(28.0, 15.0, s), 0.0, lerp(-25.0, -15.0, s))
		p["left_forearm_rot"] = Vector3(lerp(-20.0, -25.0, s), 0.0, 0.0)
		p["left_thigh_rot"] = Vector3(lerp(-28.0, 0.0, s), 0.0, -6.0)
		p["left_shin_rot"] = Vector3(lerp(42.0, 7.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(36.0, 0.0, s), 0.0, 6.0)
		p["right_shin_rot"] = Vector3(lerp(48.0, 7.0, s), 0.0, 0.0)
	return p

# 9. STUNNED
func _compute_stunned_new(t_val: float, ground_hips_y: float) -> Dictionary:
	var p: Dictionary = {}
	var t = t_val * 1.8
	
	# Woozy drunken figure-8 sway
	var sway_x = sin(t) * 0.025
	var sway_z = cos(t * 0.5) * 0.020
	p["hips_pos"] = Vector3(sway_x, ground_hips_y - 0.008, sway_z)
	p["hips_rot"] = Vector3(cos(t) * 3.0, sin(t * 0.7) * 7.0, -sin(t) * 3.5)
	p["torso_rot"] = Vector3(12.0 + sin(t) * 6.0, cos(t * 0.7) * 10.0, sin(t) * 5.0)
	p["head_rot"] = Vector3(-8.0 + cos(t * 1.2) * 14.0, -sin(t) * 16.0, cos(t * 0.8) * 12.0)
	
	# Limp dragging hammer
	p["right_arm_rot"] = Vector3(-15.0 + sin(t) * 6.0, 10.0, 22.0)
	p["right_forearm_rot"] = Vector3(-35.0, 0.0, 0.0)
	p["warhammer_rot"] = Vector3(35.0 + cos(t) * 5.0, 0.0, -10.0)
	p["left_arm_rot"] = Vector3(10.0 - sin(t) * 6.0, 0.0, -18.0)
	p["left_forearm_rot"] = Vector3(-15.0, 0.0, 0.0)
	
	# Wobbling knees
	p["left_thigh_rot"] = Vector3(-6.0 + sin(t) * 4.0, 0.0, -6.0)
	p["left_shin_rot"] = Vector3(13.0 + cos(t) * 4.0, 0.0, 0.0)
	p["right_thigh_rot"] = Vector3(4.0 - sin(t) * 4.0, 0.0, 6.0)
	p["right_shin_rot"] = Vector3(11.0 - cos(t) * 4.0, 0.0, 0.0)
	return p

func _get_min_y(mi: MeshInstance3D) -> float:
	var min_y = 999.0
	var mesh: ArrayMesh = mi.mesh as ArrayMesh
	for v in mesh.surface_get_arrays(0)[Mesh.ARRAY_VERTEX]:
		var wv = mi.global_transform * v
		if wv.y < min_y: min_y = wv.y
	return min_y
