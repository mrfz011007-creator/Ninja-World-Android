extends CharacterBody3D

@export var move_speed: float = 6.0
@export var acceleration: float = 22.0
@export var jump_velocity: float = 5.5

var _gravity: float = float(ProjectSettings.get_setting("physics/3d/default_gravity"))
var _visual_root: Node3D
var _camera: Camera3D


func _ready() -> void:
	_setup_input_actions()
	_build_character()
	_build_camera()


func _physics_process(delta: float) -> void:
	var input_vector := Input.get_vector(
		"move_left", "move_right", "move_forward", "move_backward"
	)
	var move_direction := Vector3.ZERO
	if _camera != null:
		var camera_basis: Basis = _camera.global_transform.basis
		move_direction = camera_basis.x * input_vector.x + camera_basis.z * input_vector.y
	else:
		move_direction = Vector3(input_vector.x, 0.0, input_vector.y)

	move_direction.y = 0.0
	if move_direction.length_squared() > 1.0:
		move_direction = move_direction.normalized()

	if move_direction.length_squared() > 0.001:
		velocity.x = move_toward(velocity.x, move_direction.x * move_speed, acceleration * delta)
		velocity.z = move_toward(velocity.z, move_direction.z * move_speed, acceleration * delta)
		if _visual_root != null:
			_visual_root.look_at(global_position + move_direction, Vector3.UP)
	else:
		velocity.x = move_toward(velocity.x, 0.0, acceleration * delta)
		velocity.z = move_toward(velocity.z, 0.0, acceleration * delta)

	if not is_on_floor():
		velocity.y -= _gravity * delta
	elif Input.is_action_just_pressed("jump"):
		velocity.y = jump_velocity
	else:
		velocity.y = 0.0

	move_and_slide()


func _setup_input_actions() -> void:
	_add_action("move_forward", KEY_W, KEY_UP)
	_add_action("move_backward", KEY_S, KEY_DOWN)
	_add_action("move_left", KEY_A, KEY_LEFT)
	_add_action("move_right", KEY_D, KEY_RIGHT)
	_add_action("jump", KEY_SPACE, KEY_KP_0)


func _add_action(action_name: String, first_key: int, second_key: int) -> void:
	if not InputMap.has_action(action_name):
		InputMap.add_action(action_name)
	_add_key_event(action_name, first_key)
	_add_key_event(action_name, second_key)


func _add_key_event(action_name: String, key_code: int) -> void:
	for existing_event in InputMap.action_get_events(action_name):
		if existing_event is InputEventKey and existing_event.physical_keycode == key_code:
			return
	var key_event := InputEventKey.new()
	key_event.physical_keycode = key_code
	InputMap.action_add_event(action_name, key_event)


func _build_character() -> void:
	var collision := CollisionShape3D.new()
	collision.name = "CollisionShape3D"
	var capsule_shape := CapsuleShape3D.new()
	capsule_shape.radius = 0.4
	capsule_shape.height = 1.7
	collision.shape = capsule_shape
	add_child(collision)

	_visual_root = Node3D.new()
	_visual_root.name = "Visual"
	add_child(_visual_root)

	var body_mesh := MeshInstance3D.new()
	var capsule_mesh := CapsuleMesh.new()
	capsule_mesh.radius = 0.4
	capsule_mesh.height = 1.7
	var body_material := StandardMaterial3D.new()
	body_material.albedo_color = Color("#2b477a")
	body_material.roughness = 0.72
	capsule_mesh.material = body_material
	body_mesh.mesh = capsule_mesh
	_visual_root.add_child(body_mesh)

	var head := MeshInstance3D.new()
	var head_mesh := SphereMesh.new()
	head_mesh.radius = 0.25
	head_mesh.height = 0.5
	var skin := StandardMaterial3D.new()
	skin.albedo_color = Color("#e9bd96")
	head_mesh.material = skin
	head.mesh = head_mesh
	head.position.y = 0.62
	_visual_root.add_child(head)

	var headband := MeshInstance3D.new()
	var band_mesh := SphereMesh.new()
	band_mesh.radius = 0.265
	band_mesh.height = 0.12
	var band_material := StandardMaterial3D.new()
	band_material.albedo_color = Color("#9f3538")
	band_mesh.material = band_material
	headband.mesh = band_mesh
	headband.position.y = 0.7
	headband.scale = Vector3(1.0, 0.35, 1.0)
	_visual_root.add_child(headband)


func _build_camera() -> void:
	var spring_arm := SpringArm3D.new()
	spring_arm.name = "SpringArm3D"
	spring_arm.position = Vector3(0.0, 0.45, 0.0)
	spring_arm.rotation_degrees = Vector3(15.0, 0.0, 0.0)
	spring_arm.spring_length = 5.5
	add_child(spring_arm)

	_camera = Camera3D.new()
	_camera.name = "Camera3D"
	_camera.current = true
	_camera.fov = 70.0
	spring_arm.add_child(_camera)
