extends Node3D

# Monsters
@onready var m_warrior: Node3D = $Monsters/Warrior
@onready var m_archer: Node3D = $Monsters/Archer
@onready var m_shaman: Node3D = $Monsters/Shaman
@onready var m_rogue: Node3D = $Monsters/Rogue
@onready var m_chieftain: Node3D = $Monsters/Chieftain

var active_monster_type: String = "warrior" # "warrior", "archer", "shaman", "rogue", "chieftain"
var current_monster_node: Node3D = null

# Environment & Camera
@onready var camera_pivot: Node3D = $CameraPivot
@onready var camera_pitch: Node3D = $CameraPivot/CameraPitch
@onready var camera: Camera3D = $CameraPivot/CameraPitch/Camera3D
@onready var meadow: MeshInstance3D = $Meadow
@onready var forest: MeshInstance3D = $Forest
@onready var world_env: WorldEnvironment = $WorldEnvironment
@onready var key_sun: DirectionalLight3D = $KeySun
@onready var fill_light: DirectionalLight3D = $FillLight
@onready var rim_light: DirectionalLight3D = $RimLight
@onready var bounce_light: DirectionalLight3D = $BounceLight

# Top Bar Elements
@onready var status_lbl: Label = $UI/TopLeftBadge/HBox/Status
@onready var btn_help: Button = $UI/TopRightBar/HBox/BtnHelp
@onready var chk_auto_rotate: CheckBox = $UI/TopRightBar/HBox/ChkAutoRotate
@onready var btn_reset_cam: Button = $UI/TopRightBar/HBox/BtnResetCam
@onready var help_popup: PanelContainer = $UI/HelpPopup
@onready var btn_close_help: Button = $UI/HelpPopup/VBox/Header/BtnCloseHelp

# Monster Selector Bar
@onready var btn_sel_warrior: Button = $UI/MonsterSelectorBar/HBox/BtnSelWarrior
@onready var btn_sel_archer: Button = $UI/MonsterSelectorBar/HBox/BtnSelArcher
@onready var btn_sel_shaman: Button = $UI/MonsterSelectorBar/HBox/BtnSelShaman
@onready var btn_sel_rogue: Button = $UI/MonsterSelectorBar/HBox/BtnSelRogue
@onready var btn_sel_boss: Button = $UI/MonsterSelectorBar/HBox/BtnSelBoss

# Bottom Dock - Row 1 (Dynamic Actions)
@onready var btn_act1: Button = $UI/BottomDock/VBox/Row1/BtnAct1
@onready var btn_act2: Button = $UI/BottomDock/VBox/Row1/BtnAct2
@onready var btn_act3: Button = $UI/BottomDock/VBox/Row1/BtnAct3
@onready var btn_act4: Button = $UI/BottomDock/VBox/Row1/BtnAct4
@onready var btn_act5: Button = $UI/BottomDock/VBox/Row1/BtnAct5
@onready var btn_act6: Button = $UI/BottomDock/VBox/Row1/BtnAct6
@onready var btn_act7: Button = $UI/BottomDock/VBox/Row1/BtnAct7
@onready var btn_act8: Button = $UI/BottomDock/VBox/Row1/BtnAct8

# Bottom Dock - Row 2 (Stances & Controls)
@onready var sub_group_stances: HBoxContainer = $UI/BottomDock/VBox/Row2/SubGroupStances
@onready var btn_stance1: Button = $UI/BottomDock/VBox/Row2/SubGroupStances/BtnStance1
@onready var btn_stance2: Button = $UI/BottomDock/VBox/Row2/SubGroupStances/BtnStance2
@onready var btn_stance3: Button = $UI/BottomDock/VBox/Row2/SubGroupStances/BtnStance3
@onready var btn_toggle_editor: Button = $UI/BottomDock/VBox/Row2/SubGroupStances/BtnToggleEditor

var btn_outfit1: Button = null
var btn_outfit2: Button = null

@onready var lbl_speed: Label = $UI/BottomDock/VBox/Row2/HBoxSpeed/LblSpeed
@onready var slider_speed: HSlider = $UI/BottomDock/VBox/Row2/HBoxSpeed/SpeedSlider
@onready var lbl_light: Label = $UI/BottomDock/VBox/Row2/HBoxLight/LblLight
@onready var slider_light: HSlider = $UI/BottomDock/VBox/Row2/HBoxLight/LightSlider

# Stance Editor UI Elements
@onready var editor_panel: PanelContainer = $UI/StanceEditorPanel
@onready var ed_title: Label = $UI/StanceEditorPanel/Scroll/VBoxEd/EdHeader/EdTitle
@onready var btn_close_ed: Button = $UI/StanceEditorPanel/Scroll/VBoxEd/EdHeader/BtnCloseEd
@onready var ed_stance_tabs: Container = $UI/StanceEditorPanel/Scroll/VBoxEd/EdStanceTabs
@onready var btn_copy_idle: Button = $UI/StanceEditorPanel/Scroll/VBoxEd/BtnCopyIdle

@onready var lbl_right_arm_x: Label = $UI/StanceEditorPanel/Scroll/VBoxEd/LblRightArmX
@onready var slide_right_arm_x: HSlider = $UI/StanceEditorPanel/Scroll/VBoxEd/SlideRightArmX
@onready var lbl_right_arm_y: Label = $UI/StanceEditorPanel/Scroll/VBoxEd/LblRightArmY
@onready var slide_right_arm_y: HSlider = $UI/StanceEditorPanel/Scroll/VBoxEd/SlideRightArmY
@onready var lbl_right_arm_z: Label = $UI/StanceEditorPanel/Scroll/VBoxEd/LblRightArmZ
@onready var slide_right_arm_z: HSlider = $UI/StanceEditorPanel/Scroll/VBoxEd/SlideRightArmZ
@onready var lbl_right_forearm_x: Label = $UI/StanceEditorPanel/Scroll/VBoxEd/LblRightForearmX
@onready var slide_right_forearm_x: HSlider = $UI/StanceEditorPanel/Scroll/VBoxEd/SlideRightForearmX

@onready var sec_weapon: Label = $UI/StanceEditorPanel/Scroll/VBoxEd/SecWeapon
@onready var lbl_weapon_x: Label = $UI/StanceEditorPanel/Scroll/VBoxEd/LblWeaponX
@onready var slide_weapon_x: HSlider = $UI/StanceEditorPanel/Scroll/VBoxEd/SlideWeaponX
@onready var lbl_weapon_y: Label = $UI/StanceEditorPanel/Scroll/VBoxEd/LblWeaponY
@onready var slide_weapon_y: HSlider = $UI/StanceEditorPanel/Scroll/VBoxEd/SlideWeaponY
@onready var lbl_weapon_z: Label = $UI/StanceEditorPanel/Scroll/VBoxEd/LblWeaponZ
@onready var slide_weapon_z: HSlider = $UI/StanceEditorPanel/Scroll/VBoxEd/SlideWeaponZ

@onready var lbl_left_arm_x: Label = $UI/StanceEditorPanel/Scroll/VBoxEd/LblLeftArmX
@onready var slide_left_arm_x: HSlider = $UI/StanceEditorPanel/Scroll/VBoxEd/SlideLeftArmX
@onready var lbl_left_arm_y: Label = $UI/StanceEditorPanel/Scroll/VBoxEd/LblLeftArmY
@onready var slide_left_arm_y: HSlider = $UI/StanceEditorPanel/Scroll/VBoxEd/SlideLeftArmY
@onready var lbl_left_arm_z: Label = $UI/StanceEditorPanel/Scroll/VBoxEd/LblLeftArmZ
@onready var slide_left_arm_z: HSlider = $UI/StanceEditorPanel/Scroll/VBoxEd/SlideLeftArmZ
@onready var lbl_left_forearm_x: Label = $UI/StanceEditorPanel/Scroll/VBoxEd/LblLeftForearmX
@onready var slide_left_forearm_x: HSlider = $UI/StanceEditorPanel/Scroll/VBoxEd/SlideLeftForearmX

@onready var lbl_torso_x: Label = $UI/StanceEditorPanel/Scroll/VBoxEd/LblTorsoX
@onready var slide_torso_x: HSlider = $UI/StanceEditorPanel/Scroll/VBoxEd/SlideTorsoX
@onready var lbl_torso_y: Label = $UI/StanceEditorPanel/Scroll/VBoxEd/LblTorsoY
@onready var slide_torso_y: HSlider = $UI/StanceEditorPanel/Scroll/VBoxEd/SlideTorsoY
@onready var lbl_torso_z: Label = $UI/StanceEditorPanel/Scroll/VBoxEd/LblTorsoZ
@onready var slide_torso_z: HSlider = $UI/StanceEditorPanel/Scroll/VBoxEd/SlideTorsoZ
@onready var lbl_head_y: Label = $UI/StanceEditorPanel/Scroll/VBoxEd/LblHeadY
@onready var slide_head_y: HSlider = $UI/StanceEditorPanel/Scroll/VBoxEd/SlideHeadY

@onready var lbl_ground_y: Label = $UI/StanceEditorPanel/Scroll/VBoxEd/LblGroundY
@onready var slide_ground_y: HSlider = $UI/StanceEditorPanel/Scroll/VBoxEd/SlideGroundY

@onready var btn_save_permanent: Button = $UI/StanceEditorPanel/Scroll/VBoxEd/BtnSavePermanent
@onready var btn_reset_stance: Button = $UI/StanceEditorPanel/Scroll/VBoxEd/BtnResetStance
@onready var lbl_toast: Label = $UI/StanceEditorPanel/Scroll/VBoxEd/LblToast

# Camera variables
var is_dragging: bool = false
var auto_rotate: bool = false
var camera_distance: float = 3.4
var yaw: float = 30.0
var pitch: float = -6.0
const MOUSE_SENSITIVITY: float = 0.35

const BASE_KEY_ENERGY: float = 1.35
const BASE_FILL_ENERGY: float = 0.50
const BASE_RIM_ENERGY: float = 0.65
const BASE_BOUNCE_ENERGY: float = 0.25
const BASE_AMBIENT_ENERGY: float = 0.65

var editor_target_stance: String = "aim"
var is_updating_sliders: bool = false

# Monster Action Configurations
var monster_actions: Dictionary = {
	"warrior": [
		{"anim": "idle", "label": "[ 1 ] IDLE", "color": Color(0.35, 1.0, 0.5)},
		{"anim": "walk", "label": "[ 2 ] WALK", "color": Color(0.35, 1.0, 0.5)},
		{"anim": "run", "label": "[ 3 ] RUN", "color": Color(0.35, 1.0, 0.5)},
		{"anim": "smash", "label": "⚔ [ 4 ] BỔ", "color": Color(1.0, 0.8, 0.35)},
		{"anim": "cleave", "label": "🌪 [ 5 ] QUÉT", "color": Color(1.0, 0.6, 0.2)},
		{"anim": "parry_smash", "label": "🛡 [ 6 ] PARRY BỔ", "color": Color(1.0, 0.45, 0.35)},
		{"anim": "parry_cleave", "label": "🛡 [ 7 ] PARRY QUÉT", "color": Color(1.0, 0.55, 0.25)},
		{"anim": "stunned", "label": "💫 [ 8 ] CHOÁNG", "color": Color(1.0, 0.9, 0.25)}
	],
	"archer": [
		{"anim": "idle", "label": "[ 1 ] IDLE", "color": Color(0.35, 1.0, 0.5)},
		{"anim": "walk", "label": "[ 2 ] WALK", "color": Color(0.35, 1.0, 0.5)},
		{"anim": "run", "label": "[ 3 ] SPRINT", "color": Color(0.35, 1.0, 0.5)},
		{"anim": "aim", "label": "🎯 [ 4 ] NGẮM BẮN", "color": Color(1.0, 0.85, 0.3)},
		{"anim": "shoot", "label": "🏹 [ 5 ] BẮN TÊN", "color": Color(1.0, 0.55, 0.2)},
		{"anim": "backstep", "label": "💨 [ 6 ] LÙI NÉ ĐÒN", "color": Color(0.4, 0.85, 1.0)},
		{"anim": "hurt", "label": "💥 [ 7 ] TRÚNG ĐÒN", "color": Color(1.0, 0.4, 0.4)},
		{"anim": "stunned", "label": "💫 [ 8 ] CHOÁNG", "color": Color(1.0, 0.9, 0.25)}
	],
	"shaman": [
		{"anim": "idle", "label": "[ 1 ] IDLE", "color": Color(0.35, 1.0, 0.5)},
		{"anim": "walk", "label": "[ 2 ] WALK", "color": Color(0.35, 1.0, 0.5)},
		{"anim": "run", "label": "[ 3 ] RUN", "color": Color(0.35, 1.0, 0.5)},
		{"anim": "chant", "label": "✨ [ 4 ] NIỆM CHÚ", "color": Color(0.75, 0.45, 1.0)},
		{"anim": "summon", "label": "🗿 [ 5 ] GỌI TOTEM", "color": Color(0.25, 0.9, 0.95)},
		{"anim": "hex", "label": "⚡ [ 6 ] PHÓNG PHÉP", "color": Color(1.0, 0.6, 0.2)},
		{"anim": "hurt", "label": "💥 [ 7 ] TRÚNG ĐÒN", "color": Color(1.0, 0.4, 0.4)},
		{"anim": "stunned", "label": "💫 [ 8 ] CHOÁNG", "color": Color(1.0, 0.9, 0.25)}
	],
	"rogue": [
		{"anim": "idle", "label": "[ 1 ] DAO NGƯỢC", "color": Color(0.35, 1.0, 0.5)},
		{"anim": "walk", "label": "[ 2 ] LẺN ĐI", "color": Color(0.35, 1.0, 0.5)},
		{"anim": "scurry", "label": "[ 3 ] LƯỚT NHANH", "color": Color(0.35, 1.0, 0.5)},
		{"anim": "dual_slash", "label": "⚔ [ 4 ] CHÉM CHÉO X", "color": Color(1.0, 0.8, 0.25)},
		{"anim": "backstab", "label": "🗡 [ 5 ] ĐÂM LÉN", "color": Color(1.0, 0.4, 0.3)},
		{"anim": "parry", "label": "🛡 [ 6 ] GẠT DAO", "color": Color(0.4, 0.85, 1.0)},
		{"anim": "hurt", "label": "💥 [ 7 ] TRÚNG ĐÒN", "color": Color(1.0, 0.4, 0.4)},
		{"anim": "stunned", "label": "💫 [ 8 ] CHOÁNG", "color": Color(1.0, 0.9, 0.25)}
	],
	"chieftain": [
		{"anim": "idle", "label": "[ 1 ] UY VŨ", "color": Color(0.35, 1.0, 0.5)},
		{"anim": "walk", "label": "[ 2 ] BƯỚC NẶNG", "color": Color(0.35, 1.0, 0.5)},
		{"anim": "roar", "label": "🦁 [ 3 ] GẦM THÉT", "color": Color(1.0, 0.85, 0.3)},
		{"anim": "earthshaker", "label": "💥 [ 4 ] ĐỊA CHẤN", "color": Color(1.0, 0.45, 0.2)},
		{"anim": "whirlwind", "label": "🌪 [ 5 ] BÃO CHÙY 360°", "color": Color(1.0, 0.65, 0.15)},
		{"anim": "stagger", "label": "🛡 [ 6 ] QUỲ GỐI", "color": Color(0.4, 0.85, 1.0)},
		{"anim": "stunned", "label": "💫 [ 7 ] CHOÁNG", "color": Color(1.0, 0.9, 0.25)},
		{"anim": "idle", "label": "—", "color": Color(0.5, 0.5, 0.5)}
	]
}

func _ready() -> void:
	meadow.mesh = VoxelBuilder.build_meadow_mesh()
	forest.mesh = VoxelBuilder.build_forest_mesh()
	
	# Monster Selector buttons
	btn_sel_warrior.pressed.connect(func(): switch_monster("warrior"))
	btn_sel_archer.pressed.connect(func(): switch_monster("archer"))
	btn_sel_shaman.pressed.connect(func(): switch_monster("shaman"))
	btn_sel_rogue.pressed.connect(func(): switch_monster("rogue"))
	btn_sel_boss.pressed.connect(func(): switch_monster("chieftain"))
	
	# Action buttons (Row 1)
	btn_act1.pressed.connect(func(): _trigger_action(0))
	btn_act2.pressed.connect(func(): _trigger_action(1))
	btn_act3.pressed.connect(func(): _trigger_action(2))
	btn_act4.pressed.connect(func(): _trigger_action(3))
	btn_act5.pressed.connect(func(): _trigger_action(4))
	btn_act6.pressed.connect(func(): _trigger_action(5))
	btn_act7.pressed.connect(func(): _trigger_action(6))
	btn_act8.pressed.connect(func(): _trigger_action(7))
	
	# Universal Stances Row 2
	btn_stance1.pressed.connect(func(): _on_stance_btn_pressed(0))
	btn_stance2.pressed.connect(func(): _on_stance_btn_pressed(1))
	btn_stance3.pressed.connect(func(): _on_stance_btn_pressed(2))
	btn_toggle_editor.pressed.connect(toggle_editor)
	
	# Top bar utility
	btn_help.pressed.connect(toggle_help)
	btn_close_help.pressed.connect(func(): help_popup.visible = false)
	chk_auto_rotate.toggled.connect(func(val): auto_rotate = val)
	btn_reset_cam.pressed.connect(reset_camera)
	
	# Sliders
	slider_speed.value_changed.connect(_on_speed_changed)
	slider_light.value_changed.connect(_on_light_changed)
	
	# Signals
	m_warrior.anim_changed.connect(func(_a): _update_ui_state())
	m_archer.anim_changed.connect(func(_a): _update_ui_state())
	m_shaman.anim_changed.connect(func(_a): _update_ui_state())
	m_rogue.anim_changed.connect(func(_a): _update_ui_state())
	m_chieftain.anim_changed.connect(func(_a): _update_ui_state())
	
	# Outfit switcher buttons for Archer
	var sep = VSeparator.new()
	sep.name = "OutfitSep"
	sub_group_stances.add_child(sep)
	
	btn_outfit1 = Button.new()
	btn_outfit1.name = "BtnOutfit1"
	btn_outfit1.text = "⚔️ Đồ 1 (Thô Sơ)"
	btn_outfit1.tooltip_text = "Bộ đồ 1: Thô sơ [Phím O]"
	btn_outfit1.pressed.connect(func(): _select_outfit(1))
	sub_group_stances.add_child(btn_outfit1)
	
	btn_outfit2 = Button.new()
	btn_outfit2.name = "BtnOutfit2"
	btn_outfit2.text = "🛡️ Đồ 2 (Chiến Binh)"
	btn_outfit2.tooltip_text = "Bộ đồ 2: Chiến binh thép [Phím O]"
	btn_outfit2.pressed.connect(func(): _select_outfit(2))
	sub_group_stances.add_child(btn_outfit2)
	
	if m_warrior and m_warrior.has_signal("outfit_changed"):
		m_warrior.outfit_changed.connect(func(_id): 
			_update_outfit_ui()
			_update_ui_state()
		)
	if m_archer and m_archer.has_signal("outfit_changed"):
		m_archer.outfit_changed.connect(func(_id): 
			_update_outfit_ui()
			_update_ui_state()
		)
	if m_shaman and m_shaman.has_signal("outfit_changed"):
		m_shaman.outfit_changed.connect(func(_id): 
			_update_outfit_ui()
			_update_ui_state()
		)
	if m_rogue and m_rogue.has_signal("outfit_changed"):
		m_rogue.outfit_changed.connect(func(_id): 
			_update_outfit_ui()
			_update_ui_state()
		)
	
	_setup_stance_editor()
	switch_monster("warrior")
	if m_warrior:
		m_warrior.play_anim("idle")
	reset_camera()
	# _capture_ogre_walk()

func switch_monster(m_type: String) -> void:
	active_monster_type = m_type
	
	m_warrior.visible = (m_type == "warrior")
	m_archer.visible = (m_type == "archer")
	m_shaman.visible = (m_type == "shaman")
	m_rogue.visible = (m_type == "rogue")
	m_chieftain.visible = (m_type == "chieftain")
	
	match m_type:
		"warrior": current_monster_node = m_warrior
		"archer": current_monster_node = m_archer
		"shaman": current_monster_node = m_shaman
		"rogue": current_monster_node = m_rogue
		"chieftain": current_monster_node = m_chieftain
		
	# Update selector tabs styling
	btn_sel_warrior.modulate = Color(0.2, 1.0, 0.6) if m_type == "warrior" else Color(0.8, 0.8, 0.8)
	btn_sel_archer.modulate = Color(0.2, 1.0, 0.6) if m_type == "archer" else Color(0.8, 0.8, 0.8)
	btn_sel_shaman.modulate = Color(0.2, 1.0, 0.6) if m_type == "shaman" else Color(0.8, 0.8, 0.8)
	btn_sel_rogue.modulate = Color(0.2, 1.0, 0.6) if m_type == "rogue" else Color(0.8, 0.8, 0.8)
	btn_sel_boss.modulate = Color(1.0, 0.8, 0.2) if m_type == "chieftain" else Color(0.8, 0.8, 0.8)
	
	sub_group_stances.visible = true
	_update_stance_ui()
	
	if editor_panel.visible:
		if current_monster_node and "current_stance" in current_monster_node:
			editor_target_stance = current_monster_node.current_stance
		sync_editor_from_monster()
		
	reset_camera()
	_reconfigure_action_buttons()
	_update_outfit_ui()
	_update_ui_state()

func _select_outfit(id: int) -> void:
	if current_monster_node and current_monster_node.has_method("set_outfit"):
		current_monster_node.set_outfit(id)
	_reconfigure_action_buttons()
	_update_outfit_ui()
	_update_ui_state()

func _select_archer_outfit(id: int) -> void:
	_select_outfit(id)

func _update_outfit_ui() -> void:
	if not btn_outfit1 or not btn_outfit2:
		return
	var has_outfit = (active_monster_type in ["warrior", "archer", "shaman", "rogue"])
	var sep = sub_group_stances.get_node_or_null("OutfitSep")
	if sep:
		sep.visible = has_outfit
	btn_outfit1.visible = has_outfit
	btn_outfit2.visible = has_outfit
	
	if has_outfit and current_monster_node:
		var cur = current_monster_node.get("current_outfit") if "current_outfit" in current_monster_node else 1
		btn_outfit1.modulate = Color(0.2, 1.0, 0.5) if cur == 1 else Color(0.7, 0.7, 0.7)
		btn_outfit2.modulate = Color(0.2, 1.0, 0.5) if cur == 2 else Color(0.7, 0.7, 0.7)
		
		if active_monster_type == "warrior":
			btn_outfit1.text = "⚔️ Đồ 1 (Thô Sơ)"
			btn_outfit1.tooltip_text = "Bộ đồ 1: Dã nhân thô sơ (da thú rách, chùy gai gỗ) [Phím O]"
			btn_outfit2.text = "🛡️ Đồ 2 (Chiến Binh)"
			btn_outfit2.tooltip_text = "Bộ đồ 2: Chiến binh giáp sắt, mũ chiến trận, thiết chùy nâng cấp [Phím O]"
		elif active_monster_type == "archer":
			btn_outfit1.text = "🏹 Đồ 1 (Thô Sơ)"
			btn_outfit1.tooltip_text = "Bộ đồ 1: Thợ săn nguyên thủy (áo da thú, nanh vuốt hoang dã) [Phím O]"
			btn_outfit2.text = "🌲 Đồ 2 (Ranger)"
			btn_outfit2.tooltip_text = "Bộ đồ 2: Xạ thủ kiểm lâm (áo chẽn gambeson, giáp ngực plastron, ủng buộc dây) [Phím O]"
		elif active_monster_type == "shaman":
			btn_outfit1.text = "🧙‍♂️ Đồ 1 (Thầy Mo)"
			btn_outfit1.tooltip_text = "Bộ đồ 1: Thầy Mo Bộ Lạc (da thú dã tính, mặt nạ sọ quỷ thô sơ, trượng gỗ) [Phím O]"
			btn_outfit2.text = "🔮 Đồ 2 (Đại Pháp Sư)"
			btn_outfit2.tooltip_text = "Bộ đồ 2: Đại Pháp Sư Hoàng Gia (áo choàng Magenta dài thướt tha, sừng rồng uốn lượn, trượng ngọc quyền năng) [Phím O]"
		elif active_monster_type == "rogue":
			btn_outfit1.text = "🗡️ Đồ 1 (Thô Sơ)"
			btn_outfit1.tooltip_text = "Bộ đồ 1: Dã nhân rình rập (khăn bố gai, khố da thú, dao đá & nanh thú) [Phím O]"
			btn_outfit2.text = "🥷 Đồ 2 (Sát Thủ)"
			btn_outfit2.tooltip_text = "Bộ đồ 2: Sát thủ bóng đêm (giáp da viền cowl, phi đao, song dao răng cưa tẩm độc) [Phím O]"

func _on_stance_btn_pressed(idx: int) -> void:
	if not current_monster_node or not current_monster_node.has_method("get_stance_definitions"):
		return
	var defs: Array = current_monster_node.get_stance_definitions()
	if idx < defs.size():
		var st_id = defs[idx]["id"]
		current_monster_node.set_stance(st_id)
		if editor_panel.visible:
			_switch_editor_tab(st_id)
		_update_stance_ui()
		_update_ui_state()

func _update_stance_ui() -> void:
	if not current_monster_node or not current_monster_node.has_method("get_stance_definitions"):
		return
	var defs: Array = current_monster_node.get_stance_definitions()
	var cur_st: String = current_monster_node.get("current_stance") if "current_stance" in current_monster_node else ""
	var btns = [btn_stance1, btn_stance2, btn_stance3]
	
	for i in range(btns.size()):
		if i < defs.size():
			btns[i].text = "%s %s" % [defs[i].get("shortcut", ""), defs[i].get("name", "")]
			btns[i].visible = true
			var is_active = (cur_st == defs[i]["id"])
			btns[i].modulate = Color(0.2, 1.0, 0.7) if is_active else Color(0.85, 0.85, 0.85)
		else:
			btns[i].visible = false

func _reconfigure_action_buttons() -> void:
	var acts: Array = monster_actions.get(active_monster_type, [])
	var btns = [btn_act1, btn_act2, btn_act3, btn_act4, btn_act5, btn_act6, btn_act7, btn_act8]
	for i in range(btns.size()):
		if i < acts.size():
			var label = acts[i]["label"]
			var tooltip = ""
			if active_monster_type == "warrior" and acts[i]["anim"] == "smash":
				var w_outfit = m_warrior.current_outfit if m_warrior and "current_outfit" in m_warrior else 1
				if w_outfit == 2:
					label = "🔥 [ 4 ] COMBO 1-2-3"
					tooltip = "Combo 3 Đòn: Bổ Chùy -> Quét Thuận -> Quét Ngược [Phím 4]"
				else:
					label = "⚔ [ 4 ] BỔ"
					tooltip = "Bổ chùy uy lực [Phím 4]"
			btns[i].text = label
			if tooltip != "":
				btns[i].tooltip_text = tooltip
			btns[i].visible = true
		else:
			btns[i].visible = false

func _trigger_action(idx: int) -> void:
	var acts: Array = monster_actions.get(active_monster_type, [])
	if idx < acts.size() and current_monster_node:
		var anim_name = acts[idx]["anim"]
		if anim_name != "—":
			current_monster_node.play_anim(anim_name)
			if editor_panel.visible:
				editor_target_stance = anim_name
				sync_editor_from_monster()
			_update_ui_state()

func toggle_help() -> void:
	help_popup.visible = not help_popup.visible

func toggle_editor() -> void:
	editor_panel.visible = not editor_panel.visible
	if editor_panel.visible and current_monster_node:
		if "current_anim" in current_monster_node and current_monster_node.current_anim != "":
			editor_target_stance = current_monster_node.current_anim
		elif "current_stance" in current_monster_node:
			editor_target_stance = current_monster_node.current_stance
		sync_editor_from_monster()

func _setup_stance_editor() -> void:
	btn_close_ed.pressed.connect(func(): editor_panel.visible = false)
	btn_save_permanent.pressed.connect(_on_save_permanent_pressed)
	btn_copy_idle.pressed.connect(_on_copy_idle_pressed)
	btn_reset_stance.pressed.connect(_on_reset_stance_pressed)
	
	var sliders = [
		slide_right_arm_x, slide_right_arm_y, slide_right_arm_z, slide_right_forearm_x,
		slide_weapon_x, slide_weapon_y, slide_weapon_z,
		slide_left_arm_x, slide_left_arm_y, slide_left_arm_z, slide_left_forearm_x,
		slide_torso_x, slide_torso_y, slide_torso_z, slide_head_y,
		slide_ground_y
	]
	for s in sliders:
		s.value_changed.connect(_on_editor_slider_changed)

func _switch_editor_tab(st_name: String) -> void:
	editor_target_stance = st_name
	if current_monster_node:
		if current_monster_node.has_method("play_anim"):
			current_monster_node.play_anim(st_name)
		if current_monster_node.has_method("set_stance") and st_name in ["low", "guard", "shoulder", "aim", "ready", "dual_guard", "reverse", "ground"]:
			current_monster_node.set_stance(st_name)
	_update_stance_ui()
	_update_ui_state()
	sync_editor_from_monster()

func sync_editor_from_monster() -> void:
	if not current_monster_node:
		return
	is_updating_sliders = true
	
	var m_names = {
		"warrior": "CHIẾN BINH",
		"archer": "CUNG THỦ",
		"shaman": "PHÁP SƯ",
		"rogue": "SÁT THỦ",
		"chieftain": "MACE OGRE"
	}
	ed_title.text = "🛠 BỘ CHỈNH TƯ THẾ & VŨ KHÍ: %s" % m_names.get(active_monster_type, "QUÁI VẬT")
	
	var defs: Array = []
	if current_monster_node.has_method("get_stance_definitions"):
		defs = current_monster_node.get_stance_definitions()
		
	var w_info: Dictionary = {}
	if current_monster_node.has_method("get_weapon_info"):
		w_info = current_monster_node.get_weapon_info()
		
	sec_weapon.text = w_info.get("title", "⚔ VŨ KHÍ (VỊ TRÍ & GÓC)")
	
	for child in ed_stance_tabs.get_children():
		ed_stance_tabs.remove_child(child)
		child.queue_free()
		
	var valid_target = false
	for def in defs:
		if def["id"] == editor_target_stance:
			valid_target = true
			break
	if not valid_target and defs.size() > 0:
		editor_target_stance = defs[0]["id"]
		
	for def in defs:
		var btn = Button.new()
		var s_text = def.get("shortcut", "")
		var n_text = def.get("name", "")
		btn.text = "%s %s" % [s_text, n_text] if s_text != "" else n_text
		btn.custom_minimum_size = Vector2(85, 26)
		btn.add_theme_font_size_override("font_size", 10)
		var is_active = (def["id"] == editor_target_stance)
		btn.modulate = Color(0.2, 1.0, 0.7) if is_active else Color(0.85, 0.85, 0.85)
		var st_id = def["id"]
		btn.pressed.connect(func(): _switch_editor_tab(st_id))
		ed_stance_tabs.add_child(btn)
		
	var st = editor_target_stance
	var cfg = {}
	if "stance_configs" in current_monster_node:
		cfg = current_monster_node.stance_configs.get(st, {})
		
	var r_arm: Vector3 = cfg.get("right_arm_rot", Vector3.ZERO)
	var r_fore: Vector3 = cfg.get("right_forearm_rot", Vector3.ZERO)
	var wp_prop: String = w_info.get("prop", "sword_rot")
	var wp_rot: Vector3 = cfg.get(wp_prop, Vector3.ZERO)
	var l_arm: Vector3 = cfg.get("left_arm_rot", Vector3.ZERO)
	var l_fore: Vector3 = cfg.get("left_forearm_rot", Vector3.ZERO)
	var torso_rot: Vector3 = cfg.get("torso_rot", Vector3.ZERO)
	var head_rot: Vector3 = cfg.get("head_rot", Vector3.ZERO)
	
	slide_right_arm_x.value = r_arm.x
	slide_right_arm_y.value = r_arm.y
	slide_right_arm_z.value = r_arm.z
	slide_right_forearm_x.value = r_fore.x
	
	slide_weapon_x.value = wp_rot.x
	slide_weapon_y.value = wp_rot.y
	slide_weapon_z.value = wp_rot.z
	
	slide_left_arm_x.value = l_arm.x
	slide_left_arm_y.value = l_arm.y
	slide_left_arm_z.value = l_arm.z
	slide_left_forearm_x.value = l_fore.x
	
	slide_torso_x.value = torso_rot.x
	slide_torso_y.value = torso_rot.y
	slide_torso_z.value = torso_rot.z
	slide_head_y.value = head_rot.y
	
	slide_ground_y.value = current_monster_node.get("ground_hips_y") if "ground_hips_y" in current_monster_node else 0.618
	
	_update_slider_labels()
	is_updating_sliders = false

func _update_slider_labels() -> void:
	lbl_right_arm_x.text = "Vai phải X (Gập/Duỗi): %d°" % int(slide_right_arm_x.value)
	lbl_right_arm_y.text = "Vai phải Y (Xoay Trục): %d°" % int(slide_right_arm_y.value)
	lbl_right_arm_z.text = "Vai phải Z (Dang/Khép): %d°" % int(slide_right_arm_z.value)
	lbl_right_forearm_x.text = "Khuỷu tay phải (Gập): %d°" % int(slide_right_forearm_x.value)
	
	lbl_weapon_x.text = "Góc X: %d°" % int(slide_weapon_x.value)
	lbl_weapon_y.text = "Góc Y: %d°" % int(slide_weapon_y.value)
	lbl_weapon_z.text = "Góc Z: %d°" % int(slide_weapon_z.value)
	
	lbl_left_arm_x.text = "Vai trái X: %d°" % int(slide_left_arm_x.value)
	lbl_left_arm_y.text = "Vai trái Y: %d°" % int(slide_left_arm_y.value)
	lbl_left_arm_z.text = "Vai trái Z: %d°" % int(slide_left_arm_z.value)
	lbl_left_forearm_x.text = "Khuỷu tay trái: %d°" % int(slide_left_forearm_x.value)
	
	lbl_torso_x.text = "Thân Gập/Ngửa (X): %d°" % int(slide_torso_x.value)
	lbl_torso_y.text = "Thân Xoay Hông (Y): %d°" % int(slide_torso_y.value)
	lbl_torso_z.text = "Thân Nghiêng Bên (Z): %d°" % int(slide_torso_z.value)
	lbl_head_y.text = "Đầu Xoay Ngắm (Y): %d°" % int(slide_head_y.value)
	
	lbl_ground_y.text = "Cao độ hông: %.3fm" % slide_ground_y.value

func _on_editor_slider_changed(_val: float) -> void:
	if is_updating_sliders or not current_monster_node: return
	_update_slider_labels()
	
	var r_arm = Vector3(slide_right_arm_x.value, slide_right_arm_y.value, slide_right_arm_z.value)
	var r_fore = Vector3(slide_right_forearm_x.value, 0.0, 0.0)
	var wp = Vector3(slide_weapon_x.value, slide_weapon_y.value, slide_weapon_z.value)
	var l_arm = Vector3(slide_left_arm_x.value, slide_left_arm_y.value, slide_left_arm_z.value)
	var l_fore = Vector3(slide_left_forearm_x.value, 0.0, 0.0)
	var torso = Vector3(slide_torso_x.value, slide_torso_y.value, slide_torso_z.value)
	
	var w_info: Dictionary = {}
	if current_monster_node.has_method("get_weapon_info"):
		w_info = current_monster_node.get_weapon_info()
	var wp_prop: String = w_info.get("prop", "sword_rot")
	
	if current_monster_node.has_method("update_live_stance"):
		current_monster_node.update_live_stance(editor_target_stance, "right_arm_rot", r_arm)
		current_monster_node.update_live_stance(editor_target_stance, "right_forearm_rot", r_fore)
		current_monster_node.update_live_stance(editor_target_stance, wp_prop, wp)
		current_monster_node.update_live_stance(editor_target_stance, "left_arm_rot", l_arm)
		current_monster_node.update_live_stance(editor_target_stance, "left_forearm_rot", l_fore)
		current_monster_node.update_live_stance(editor_target_stance, "torso_rot", torso)
		current_monster_node.update_live_stance(editor_target_stance, "head_rot", Vector3(0.0, slide_head_y.value, 0.0))
		
	if current_monster_node.has_method("set_live_ground_hips_y"):
		current_monster_node.set_live_ground_hips_y(slide_ground_y.value)

func _on_save_permanent_pressed() -> void:
	if current_monster_node and current_monster_node.has_method("save_stance_config"):
		current_monster_node.save_stance_config()
	lbl_toast.visible = true
	lbl_toast.text = "✓ Đã chốt và lưu vĩnh viễn tư thế cho %s!" % active_monster_type.capitalize()
	await get_tree().create_timer(2.5).timeout
	lbl_toast.visible = false

func _on_copy_idle_pressed() -> void:
	if current_monster_node and current_monster_node.has_method("copy_weapon_from_idle"):
		current_monster_node.copy_weapon_from_idle(editor_target_stance)
		sync_editor_from_monster()
		lbl_toast.visible = true
		lbl_toast.text = "✓ Đã copy góc vũ khí từ Idle sang '%s'!" % editor_target_stance
		await get_tree().create_timer(2.0).timeout
		lbl_toast.visible = false

func _on_reset_stance_pressed() -> void:
	if current_monster_node and current_monster_node.has_method("reset_stance_to_default"):
		current_monster_node.reset_stance_to_default(editor_target_stance)
	sync_editor_from_monster()

func _save_shot(filename: String) -> void:
	var img = get_viewport().get_texture().get_image()
	if img:
		var brain_dir = "C:/Users/Administrator/.gemini/antigravity/brain/ec0b555c-b953-40a9-a69a-c4d1848bb995"
		if DirAccess.dir_exists_absolute(brain_dir):
			img.save_png(brain_dir + "/" + filename)
		else:
			img.save_png("user://" + filename)

func _capture_warrior_outfits() -> void:
	await get_tree().create_timer(0.4).timeout
	editor_panel.visible = false
	switch_monster("warrior")
	
	# 1. Warrior Outfit 1 - Idle Front (Primitive)
	_select_outfit(1)
	m_warrior.play_anim("idle")
	yaw = 25.0
	pitch = -6.0
	camera_distance = 2.8
	_update_camera_transform()
	await get_tree().create_timer(0.4).timeout
	_save_shot("warrior_outfit1_idle_front.png")
	
	# 2. Warrior Outfit 2 - Idle Front (Ironclad Warrior)
	_select_outfit(2)
	m_warrior.play_anim("idle")
	await get_tree().create_timer(0.4).timeout
	_save_shot("warrior_outfit2_idle_front.png")
	
	# 3. Warrior Outfit 2 - Idle Side (Weapon & Flanged Mace detail)
	yaw = 75.0
	pitch = -4.0
	camera_distance = 2.5
	_update_camera_transform()
	await get_tree().create_timer(0.4).timeout
	_save_shot("warrior_outfit2_idle_side.png")
	
	# 4. Warrior Outfit 2 - Idle Rear (Pauldrons & Back Armor)
	yaw = 145.0
	pitch = -8.0
	camera_distance = 2.6
	_update_camera_transform()
	await get_tree().create_timer(0.4).timeout
	_save_shot("warrior_outfit2_idle_rear.png")
	
	# 5. Warrior Outfit 2 - Action: Smash (Bổ)
	yaw = 35.0
	pitch = -6.0
	camera_distance = 3.0
	_update_camera_transform()
	m_warrior.play_anim("smash")
	await get_tree().create_timer(0.45).timeout
	_save_shot("warrior_outfit2_action_smash.png")
	
	# 6. Warrior Outfit 2 - Action: Cleave (Quét)
	m_warrior.play_anim("cleave")
	await get_tree().create_timer(0.42).timeout
	_save_shot("warrior_outfit2_action_cleave.png")
	
	# 7. Warrior Outfit 2 - Action: Parry Smash
	m_warrior.play_anim("parry_smash")
	await get_tree().create_timer(0.4).timeout
	_save_shot("warrior_outfit2_parry.png")
	
	# 8. Warrior Outfit 2 - Run (Chạy)
	m_warrior.play_anim("run")
	yaw = 55.0
	pitch = -6.0
	camera_distance = 2.9
	_update_camera_transform()
	await get_tree().create_timer(0.4).timeout
	_save_shot("warrior_outfit2_run.png")
	
	# 9. Warrior Outfit 2 - Stunned (Choáng)
	m_warrior.play_anim("stunned")
	yaw = 25.0
	pitch = -6.0
	camera_distance = 2.7
	_update_camera_transform()
	await get_tree().create_timer(0.45).timeout
	_save_shot("warrior_outfit2_stunned.png")
	
	# 10. Reset to Warrior Outfit 2 Idle
	m_warrior.play_anim("idle")
	reset_camera()
	_update_ui_state()

func _capture_warrior_combo() -> void:
	await get_tree().create_timer(0.4).timeout
	editor_panel.visible = false
	switch_monster("warrior")
	_select_outfit(2)
	
	yaw = 35.0
	pitch = -6.0
	camera_distance = 2.9
	_update_camera_transform()
	
	# Trigger Combo 1-2-3
	m_warrior.play_anim("smash")
	
	# Hit 1: Smash / Ground Slam impact (t = 0.50s)
	await get_tree().create_timer(0.50).timeout
	_save_shot("warrior_combo_hit1_smash.png")
	
	# Hit 2: Sweep / 180° Cleave (t = 1.15s, so wait +0.65s)
	await get_tree().create_timer(0.65).timeout
	_save_shot("warrior_combo_hit2_cleave.png")
	
	# Hit 3: Explosive Reverse Cleave (Left -> Right) midpoint (t = 2.00s, wait +0.85s)
	await get_tree().create_timer(0.85).timeout
	_save_shot("warrior_combo_hit3_reverse_cleave.png")
	
	# Hit 3 Smooth Recovery: Continuous fluid deceleration along right flank (t = 2.55s, wait +0.55s)
	await get_tree().create_timer(0.55).timeout
	_save_shot("warrior_combo_hit3_smooth_recovery.png")
	
	await get_tree().create_timer(0.8).timeout
	m_warrior.play_anim("idle")
	reset_camera()
	_update_ui_state()
	get_tree().quit()

func _capture_ogre_walk() -> void:
	await get_tree().create_timer(0.4).timeout
	editor_panel.visible = false
	switch_monster("chieftain")
	m_chieftain.play_anim("walk")
	
	# 1. Front view: Lateral weight shift & wide stance
	yaw = 20.0
	pitch = -6.0
	camera_distance = 4.6
	camera_pivot.position.y = 0.80
	_update_camera_transform()
	await get_tree().create_timer(0.45).timeout
	_save_shot("ogre_walk_front_sway.png")
	
	# 2. 3/4 Perspective: Stride plant & knee flexion & warhammer cushion
	yaw = 45.0
	pitch = -8.0
	camera_distance = 4.4
	camera_pivot.position.y = 0.85
	_update_camera_transform()
	await get_tree().create_timer(0.35).timeout
	_save_shot("ogre_walk_stride_plant.png")
	
	# 3. Side profile: Spine posture, passing foot lift & free arm pump
	yaw = 80.0
	pitch = -4.0
	camera_distance = 4.2
	camera_pivot.position.y = 0.85
	_update_camera_transform()
	await get_tree().create_timer(0.40).timeout
	_save_shot("ogre_walk_side_profile.png")
	
	m_chieftain.play_anim("idle")
	reset_camera()
	_update_ui_state()
	get_tree().quit()

func _capture_showcase_screenshots() -> void:
	await get_tree().create_timer(0.4).timeout
	
	# 1. Archer in Aim stance with Stance Editor Open
	switch_monster("archer")
	_on_stance_btn_pressed(0) # Aim
	editor_panel.visible = true
	sync_editor_from_monster()
	reset_camera()
	await get_tree().create_timer(0.35).timeout
	_save_shot("universal_stance_editor_archer.png")
	
	# 2. Rogue in Dual Guard stance with Stance Editor Open
	switch_monster("rogue")
	_on_stance_btn_pressed(1) # Dual Guard
	editor_panel.visible = true
	sync_editor_from_monster()
	await get_tree().create_timer(0.35).timeout
	_save_shot("universal_stance_editor_rogue.png")
	
	# 3. Chieftain in Guard stance with Stance Editor Open
	switch_monster("chieftain")
	_on_stance_btn_pressed(2) # Guard
	editor_panel.visible = true
	sync_editor_from_monster()
	await get_tree().create_timer(0.35).timeout
	_save_shot("universal_stance_editor_chieftain.png")
	
	# 4. Warrior in Guard stance with Stance Editor Open
	switch_monster("warrior")
	_on_stance_btn_pressed(1) # Guard
	editor_panel.visible = true
	sync_editor_from_monster()
	await get_tree().create_timer(0.35).timeout
	_save_shot("universal_stance_editor_warrior.png")
	
	# 5. Shaman in Ward stance with Stance Editor Open
	switch_monster("shaman")
	_on_stance_btn_pressed(2) # Ward
	editor_panel.visible = true
	sync_editor_from_monster()
	await get_tree().create_timer(0.35).timeout
	_save_shot("universal_stance_editor_shaman.png")
	
	# Reset back to Archer with editor open
	switch_monster("archer")
	_on_stance_btn_pressed(0)
	editor_panel.visible = true
	sync_editor_from_monster()

func _capture_archer_showcase() -> void:
	await get_tree().create_timer(0.4).timeout
	switch_monster("archer")
	editor_panel.visible = false
	
	# 1. Aim Stance (Unclipped classic archery stance)
	m_archer.play_anim("aim")
	reset_camera()
	await get_tree().create_timer(0.4).timeout
	_save_shot("archer_aim_stance.png")
	
	# 2. Rear View - Quiver on Back (Zero torso clipping, flush on strap)
	yaw = 150.0
	pitch = -8.0
	camera_distance = 1.9
	_update_camera_transform()
	await get_tree().create_timer(0.4).timeout
	_save_shot("archer_quiver_back.png")
	
	# 3. Walk Animation
	m_archer.play_anim("walk")
	yaw = 35.0
	pitch = -12.0
	camera_distance = 2.2
	_update_camera_transform()
	await get_tree().create_timer(0.5).timeout
	_save_shot("archer_walk.png")
	
	# 4. Sprint / Run Animation (Ranger Bow Carriage, zero thigh collision)
	m_archer.play_anim("run")
	yaw = 50.0
	pitch = -10.0
	camera_distance = 2.4
	_update_camera_transform()
	await get_tree().create_timer(0.5).timeout
	_save_shot("archer_run.png")
	
	# 5. Stunned Animation (Zero hovering, soles firmly planted on floor)
	m_archer.play_anim("stunned")
	yaw = 20.0
	pitch = -14.0
	camera_distance = 2.2
	_update_camera_transform()
	await get_tree().create_timer(0.5).timeout
	_save_shot("archer_stunned_grounded.png")
	
	# Reset back to Aim stance with standard view
	m_archer.play_anim("aim")
	reset_camera()
	_update_ui_state()

func _capture_outfit_comparison() -> void:
	await get_tree().create_timer(0.4).timeout
	switch_monster("archer")
	editor_panel.visible = false
	
	# Outfit 1 - Aim
	_select_archer_outfit(1)
	m_archer.play_anim("aim")
	reset_camera()
	await get_tree().create_timer(0.4).timeout
	_save_shot("archer_outfit1_aim.png")
	
	# Outfit 1 - Rear Quiver
	yaw = 150.0
	pitch = -8.0
	camera_distance = 1.9
	_update_camera_transform()
	await get_tree().create_timer(0.4).timeout
	_save_shot("archer_outfit1_rear.png")
	
	# Outfit 1 - Stunned Grounded
	m_archer.play_anim("stunned")
	yaw = 20.0
	pitch = -14.0
	camera_distance = 2.2
	_update_camera_transform()
	await get_tree().create_timer(0.5).timeout
	_save_shot("archer_outfit1_stunned.png")
	
	# Outfit 2 - Aim
	_select_archer_outfit(2)
	m_archer.play_anim("aim")
	reset_camera()
	await get_tree().create_timer(0.4).timeout
	_save_shot("archer_outfit2_aim.png")
	
	# Outfit 2 - Stunned Grounded
	m_archer.play_anim("stunned")
	yaw = 20.0
	pitch = -14.0
	camera_distance = 2.2
	_update_camera_transform()
	await get_tree().create_timer(0.5).timeout
	_save_shot("archer_outfit2_stunned.png")
	
	# Reset back to Outfit 1 Aim
	_select_archer_outfit(1)
	m_archer.play_anim("aim")
	reset_camera()
	_update_ui_state()

func _capture_shaman_showcase() -> void:
	await get_tree().create_timer(0.4).timeout
	switch_monster("shaman")
	editor_panel.visible = false
	
	# 1. Idle - Breathing, firmly planted staff
	m_shaman.play_anim("idle")
	yaw = 20.0
	pitch = -6.0
	camera_distance = 3.0
	camera_pivot.position = Vector3(0.0, 0.58, 0.0)
	_update_camera_transform()
	await get_tree().create_timer(0.4).timeout
	_save_shot("shaman_anim_idle.png")
	
	# 2. Walk - Pilgrim walking stride with staff pacing
	m_shaman.play_anim("walk")
	yaw = 35.0
	pitch = -6.0
	camera_distance = 3.0
	camera_pivot.position = Vector3(0.0, 0.58, 0.0)
	_update_camera_transform()
	await get_tree().create_timer(0.5).timeout
	_save_shot("shaman_anim_walk.png")
	
	# 3. Run - Aggressive scurry with staff tucked along flank
	m_shaman.play_anim("run")
	yaw = 45.0
	pitch = -8.0
	camera_distance = 3.1
	camera_pivot.position = Vector3(0.0, 0.56, 0.0)
	_update_camera_transform()
	await get_tree().create_timer(0.5).timeout
	_save_shot("shaman_anim_run.png")
	
	# 4. Chant - Ground-rooted skyward ritual
	m_shaman.play_anim("chant")
	yaw = 25.0
	pitch = -4.0
	camera_distance = 3.2
	camera_pivot.position = Vector3(0.0, 0.65, 0.0)
	_update_camera_transform()
	await get_tree().create_timer(0.5).timeout
	_save_shot("shaman_anim_chant.png")
	
	# 5. Summon - Cataclysmic staff slam & Totem eruption
	m_shaman.play_anim("summon")
	yaw = 25.0
	pitch = -8.0
	camera_distance = 3.4
	camera_pivot.position = Vector3(0.0, 0.62, 0.0)
	_update_camera_transform()
	await get_tree().create_timer(0.65).timeout
	_save_shot("shaman_anim_summon.png")
	
	# 6. Hex - Eldritch bolt discharge pointing soul orb
	m_shaman.play_anim("hex")
	yaw = 35.0
	pitch = -6.0
	camera_distance = 3.2
	camera_pivot.position = Vector3(0.0, 0.60, 0.0)
	_update_camera_transform()
	await get_tree().create_timer(0.48).timeout
	_save_shot("shaman_anim_hex.png")
	
	# 7. Hurt - Elastic shockwave recoil, zero clipping
	m_shaman.play_anim("hurt")
	yaw = 25.0
	pitch = -6.0
	camera_distance = 3.0
	camera_pivot.position = Vector3(0.0, 0.58, 0.0)
	_update_camera_transform()
	await get_tree().create_timer(0.25).timeout
	_save_shot("shaman_anim_hurt.png")
	
	# 8. Stunned - Dazed leaning on staff crutch, feet firmly on ground
	m_shaman.play_anim("stunned")
	yaw = 20.0
	pitch = -10.0
	camera_distance = 2.8
	camera_pivot.position = Vector3(0.0, 0.55, 0.0)
	_update_camera_transform()
	await get_tree().create_timer(0.5).timeout
	_save_shot("shaman_anim_stunned.png")
	
	# Reset back to Shaman Idle
	m_shaman.play_anim("idle")
	reset_camera()
	_update_ui_state()

func _capture_all_clean_characters() -> void:
	await get_tree().create_timer(0.4).timeout
	editor_panel.visible = false
	
	# 1. Archer Outfit 1 Aim
	switch_monster("archer")
	_select_archer_outfit(1)
	m_archer.play_anim("aim")
	yaw = 30.0
	pitch = -6.0
	camera_distance = 2.6
	_update_camera_transform()
	await get_tree().create_timer(0.4).timeout
	_save_shot("clean_archer_outfit1.png")
	
	# 2. Archer Outfit 2 Aim
	_select_archer_outfit(2)
	m_archer.play_anim("aim")
	await get_tree().create_timer(0.4).timeout
	_save_shot("clean_archer_outfit2.png")
	
	# 3. Warrior Idle / Club Stance
	switch_monster("warrior")
	m_warrior.play_anim("idle")
	yaw = 25.0
	pitch = -6.0
	camera_distance = 2.8
	_update_camera_transform()
	await get_tree().create_timer(0.4).timeout
	_save_shot("clean_warrior.png")
	
	# 4. Shaman Chant / Staff Stance
	switch_monster("shaman")
	m_shaman.play_anim("chant")
	yaw = 25.0
	pitch = -6.0
	camera_distance = 3.0
	_update_camera_transform()
	await get_tree().create_timer(0.4).timeout
	_save_shot("clean_shaman.png")
	
	# 5. Rogue Idle / Daggers Stance
	switch_monster("rogue")
	m_rogue.play_anim("idle")
	yaw = 25.0
	pitch = -6.0
	camera_distance = 2.6
	_update_camera_transform()
	await get_tree().create_timer(0.4).timeout
	_save_shot("clean_rogue.png")
	
	# 6. Boss Chieftain Stance
	switch_monster("chieftain")
	m_chieftain.play_anim("idle")
	yaw = 25.0
	pitch = -6.0
	camera_distance = 4.2
	_update_camera_transform()
	await get_tree().create_timer(0.4).timeout
	_save_shot("clean_boss_chieftain.png")
	
	# Reset back to Archer Outfit 2
	switch_monster("archer")
	_select_archer_outfit(2)
	m_archer.play_anim("aim")
	reset_camera()
	_update_ui_state()

func _process(delta: float) -> void:
	if auto_rotate and not is_dragging:
		yaw += delta * 18.0
		yaw = wrapf(yaw, -180.0, 180.0)
		_update_camera_transform()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			is_dragging = event.pressed
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			camera_distance = clampf(camera_distance - 0.2, 1.2, 6.0)
			_update_camera_transform()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			camera_distance = clampf(camera_distance + 0.2, 1.2, 6.0)
			_update_camera_transform()
			
	elif event is InputEventMouseMotion and is_dragging:
		yaw -= event.relative.x * MOUSE_SENSITIVITY
		pitch -= event.relative.y * MOUSE_SENSITIVITY
		pitch = clampf(pitch, -60.0, 35.0)
		yaw = wrapf(yaw, -180.0, 180.0)
		_update_camera_transform()
		
	elif event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_F1: switch_monster("warrior")
			KEY_F2: switch_monster("archer")
			KEY_F3: switch_monster("shaman")
			KEY_F4: switch_monster("rogue")
			KEY_F5: switch_monster("chieftain")
			
			KEY_1: _trigger_action(0)
			KEY_2: _trigger_action(1)
			KEY_3: _trigger_action(2)
			KEY_4: _trigger_action(3)
			KEY_5: _trigger_action(4)
			KEY_6: _trigger_action(5)
			KEY_7: _trigger_action(6)
			KEY_8: _trigger_action(7)
			
			KEY_Q:
				_on_stance_btn_pressed(0)
			KEY_W:
				_on_stance_btn_pressed(1)
			KEY_E:
				_on_stance_btn_pressed(2)
				
			KEY_C, KEY_T, KEY_TAB:
				toggle_editor()
			KEY_O:
				if current_monster_node and current_monster_node.has_method("set_outfit"):
					var cur_o = current_monster_node.get("current_outfit") if "current_outfit" in current_monster_node else 1
					_select_outfit(2 if cur_o == 1 else 1)
			KEY_H: toggle_help()
			KEY_SPACE:
				auto_rotate = not auto_rotate
				chk_auto_rotate.button_pressed = auto_rotate
			KEY_R: reset_camera()

func _on_speed_changed(val: float) -> void:
	if current_monster_node and current_monster_node.has_method("set_speed"):
		current_monster_node.set_speed(val)
	lbl_speed.text = "⚡ %.1fx" % val

func _on_light_changed(val: float) -> void:
	lbl_light.text = "💡 %d%%" % int(val * 100.0)
	key_sun.light_energy = BASE_KEY_ENERGY * val
	fill_light.light_energy = BASE_FILL_ENERGY * val
	rim_light.light_energy = BASE_RIM_ENERGY * val
	bounce_light.light_energy = BASE_BOUNCE_ENERGY * val
	if world_env and world_env.environment:
		world_env.environment.ambient_light_energy = BASE_AMBIENT_ENERGY * val

func reset_camera() -> void:
	yaw = 30.0
	pitch = -6.0
	if active_monster_type == "chieftain":
		camera_distance = 4.8
		camera_pivot.position.y = 0.85
	else:
		camera_distance = 3.4
		camera_pivot.position.y = 0.62
	_update_camera_transform()

func _update_camera_transform() -> void:
	camera_pivot.rotation_degrees.y = yaw
	camera_pitch.rotation_degrees.x = pitch
	camera.position.z = camera_distance

func _update_ui_state() -> void:
	if not current_monster_node:
		return
		
	var cur = current_monster_node.current_anim
	var acts: Array = monster_actions.get(active_monster_type, [])
	var btns = [btn_act1, btn_act2, btn_act3, btn_act4, btn_act5, btn_act6, btn_act7, btn_act8]
	
	for i in range(acts.size()):
		if i < btns.size():
			var is_active = (cur == acts[i]["anim"])
			btns[i].modulate = acts[i]["color"] if is_active else Color(0.85, 0.85, 0.85)
			
	var warrior_name = "Goblin Warrior (Chùy)"
	if m_warrior and "current_outfit" in m_warrior:
		var w_label = "Đồ 1: Thô Sơ" if m_warrior.current_outfit == 1 else "Đồ 2: Chiến Binh"
		warrior_name = "Goblin Warrior [%s]" % w_label

	var archer_name = "Goblin Archer (Cung)"
	if m_archer and "current_outfit" in m_archer:
		var o_label = "Đồ 1: Thô Sơ" if m_archer.current_outfit == 1 else "Đồ 2: Ranger"
		archer_name = "Goblin Archer [%s]" % o_label
		
	var m_names = {
		"warrior": warrior_name,
		"archer": archer_name,
		"shaman": "Goblin Shaman (Pháp Sư)",
		"rogue": "Goblin Rogue (Sát Thủ)",
		"chieftain": "Mace Ogre (Boss)"
	}
	
	var cur_status = cur.to_upper()
	if active_monster_type == "warrior" and cur == "smash":
		var w_outfit = m_warrior.current_outfit if m_warrior and "current_outfit" in m_warrior else 1
		if w_outfit == 2:
			cur_status = "BỔ COMBO 1-2-3 (3 ĐÒN LIÊN HOÀN)"
	status_lbl.text = "%s  •  %s" % [m_names.get(active_monster_type, "Goblin"), cur_status]

