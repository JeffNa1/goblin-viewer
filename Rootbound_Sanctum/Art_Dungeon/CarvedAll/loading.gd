extends CanvasLayer

var bar: ProgressBar
var message: Label
var pulse: Label
var failed := false
var elapsed := 0.0

func _ready() -> void:
	layer = 100
	var backdrop = ColorRect.new()
	backdrop.color = Color("102721")
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(backdrop)
	var center = CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	backdrop.add_child(center)
	var stack = VBoxContainer.new()
	stack.custom_minimum_size.x = 640
	stack.add_theme_constant_override("separation", 22)
	center.add_child(stack)
	var title = Label.new()
	title.text = "ROOTBOUND SANCTUM"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 38)
	title.add_theme_color_override("font_color", Color("d6bd87"))
	stack.add_child(title)
	pulse = Label.new()
	pulse.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	pulse.add_theme_color_override("font_color", Color("90c5a4"))
	stack.add_child(pulse)
	bar = ProgressBar.new()
	bar.custom_minimum_size.y = 24
	bar.value = 0
	stack.add_child(bar)
	message = Label.new()
	message.text = "Preparing the sanctuary"
	message.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	stack.add_child(message)
	var note = Label.new()
	note.text = "The full scene appears only after every chamber is ready."
	note.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	note.add_theme_color_override("font_color", Color("87a292"))
	stack.add_child(note)

func update_progress(done: float, total: int, text: String) -> void:
	bar.value = clampf(done / float(total) * 100.0, 0, 100)
	message.text = text

func fail(text: String) -> void:
	failed = true
	message.text = "Unable to open the sanctuary: " + text
	message.add_theme_color_override("font_color", Color("f2ae91"))

func _process(delta: float) -> void:
	elapsed += delta
	pulse.text = "~  ROOTS REMEMBER  " + ".".repeat(int(elapsed * 3) % 4) + "  ~"
