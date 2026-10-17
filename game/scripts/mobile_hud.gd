extends CanvasLayer

const BUTTON_SIZE := Vector2(68.0, 68.0)


func _ready() -> void:
	_build_hud()


func _build_hud() -> void:
	var root := Control.new()
	root.name = "HUDRoot"
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(root)

	var title := Label.new()
	title.text = "NINJA WORLD  |  PROTOTYPE"
	title.position = Vector2(24.0, 18.0)
	title.size = Vector2(620.0, 42.0)
	title.add_theme_font_size_override("font_size", 24)
	title.add_theme_color_override("font_color", Color("#ffffff"))
	root.add_child(title)

	var subtitle := Label.new()
	subtitle.text = "Explore the Hidden Grove"
	subtitle.position = Vector2(26.0, 57.0)
	subtitle.size = Vector2(400.0, 28.0)
	subtitle.add_theme_font_size_override("font_size", 16)
	subtitle.add_theme_color_override("font_color", Color("#edf4ff"))
	root.add_child(subtitle)

	_add_action_button(root, "▲", "move_forward", 0.12, 0.74)
	_add_action_button(root, "▼", "move_backward", 0.12, 0.92)
	_add_action_button(root, "◀", "move_left", 0.055, 0.83)
	_add_action_button(root, "▶", "move_right", 0.185, 0.83)
	_add_action_button(root, "JUMP", "jump", 0.9, 0.84, Vector2(88.0, 76.0), 18)


func _add_action_button(
	parent: Control,
	label_text: String,
	action_name: String,
	anchor_x: float,
	anchor_y: float,
	button_size: Vector2 = BUTTON_SIZE,
	font_size: int = 24
) -> void:
	var button := Button.new()
	button.text = label_text
	button.custom_minimum_size = button_size
	button.anchor_left = anchor_x
	button.anchor_right = anchor_x
	button.anchor_top = anchor_y
	button.anchor_bottom = anchor_y
	button.offset_left = -button_size.x * 0.5
	button.offset_right = button_size.x * 0.5
	button.offset_top = -button_size.y * 0.5
	button.offset_bottom = button_size.y * 0.5
	button.focus_mode = Control.FOCUS_NONE
	button.add_theme_font_size_override("font_size", font_size)
	button.add_theme_color_override("font_color", Color("#ffffff"))
	button.add_theme_color_override("font_pressed_color", Color("#e4f0ff"))
	button.modulate = Color(0.85, 0.9, 1.0, 0.88)
	button.button_down.connect(_press_action.bind(action_name))
	button.button_up.connect(_release_action.bind(action_name))
	parent.add_child(button)


func _press_action(action_name: String) -> void:
	Input.action_press(action_name)


func _release_action(action_name: String) -> void:
	Input.action_release(action_name)


func _exit_tree() -> void:
	for action_name in ["move_forward", "move_backward", "move_left", "move_right", "jump"]:
		Input.action_release(action_name)
