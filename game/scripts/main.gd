extends Node3D

const PLAYER_CONTROLLER = preload("res://scripts/player_controller.gd")
const MOBILE_HUD = preload("res://scripts/mobile_hud.gd")

func _ready() -> void:
	_build_environment()
	_build_ground()
	_build_path()
	_build_forest()
	_build_gate()
	_spawn_player()
	_spawn_hud()


func _build_environment() -> void:
	var world_environment := WorldEnvironment.new()
	var environment := Environment.new()
	environment.background_mode = Environment.BG_COLOR
	environment.background_color = Color("#8fb9d6")
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.ambient_light_color = Color("#c7d6e8")
	environment.ambient_light_energy = 0.8
	world_environment.environment = environment
	add_child(world_environment)

	var sun := DirectionalLight3D.new()
	sun.name = "Sun"
	sun.rotation_degrees = Vector3(-52.0, -28.0, 0.0)
	sun.light_energy = 1.1
	sun.shadow_enabled = true
	add_child(sun)


func _build_ground() -> void:
	var ground := StaticBody3D.new()
	ground.name = "Ground"
	add_child(ground)

	var ground_mesh := MeshInstance3D.new()
	var plane := PlaneMesh.new()
	plane.size = Vector2(120.0, 120.0)
	var grass := StandardMaterial3D.new()
	grass.albedo_color = Color("#4b7849")
	grass.roughness = 1.0
	plane.material = grass
	ground_mesh.mesh = plane
	ground.add_child(ground_mesh)

	var ground_collision := CollisionShape3D.new()
	var ground_shape := BoxShape3D.new()
	ground_shape.size = Vector3(120.0, 0.3, 120.0)
	ground_collision.shape = ground_shape
	ground_collision.position.y = -0.15
	ground.add_child(ground_collision)


func _build_path() -> void:
	var path := MeshInstance3D.new()
	path.name = "ForestPath"
	var path_mesh := PlaneMesh.new()
	path_mesh.size = Vector2(5.0, 90.0)
	var path_material := StandardMaterial3D.new()
	path_material.albedo_color = Color("#bca37c")
	path_material.roughness = 1.0
	path_mesh.material = path_material
	path.mesh = path_mesh
	path.position = Vector3(0.0, 0.015, -7.0)
	add_child(path)


func _build_forest() -> void:
	var tree_positions: Array[Vector2] = [
		Vector2(-8.0, -7.0), Vector2(-11.0, -12.0),
		Vector2(-7.0, -18.0), Vector2(-13.0, -23.0),
		Vector2(-9.0, -30.0), Vector2(-14.0, -37.0),
		Vector2(8.0, -8.0), Vector2(12.0, -13.0),
		Vector2(8.0, -19.0), Vector2(14.0, -25.0),
		Vector2(10.0, -32.0), Vector2(15.0, -39.0),
		Vector2(-10.0, 5.0), Vector2(10.0, 7.0),
		Vector2(-16.0, -4.0), Vector2(18.0, -5.0),
		Vector2(-21.0, -17.0), Vector2(22.0, -19.0),
		Vector2(-20.0, -33.0), Vector2(22.0, -35.0)
	]
	for index in range(tree_positions.size()):
		var p := tree_positions[index]
		_create_tree(Vector3(p.x, 0.0, p.y), index)


func _create_tree(world_position: Vector3, variant: int) -> void:
	var tree := Node3D.new()
	tree.name = "Tree_%02d" % variant
	tree.position = world_position
	add_child(tree)

	# The trunk needs a physics body; the visual mesh alone does not block the player.
	var trunk_body := StaticBody3D.new()
	trunk_body.name = "TrunkCollision"
	tree.add_child(trunk_body)
	var trunk_collision := CollisionShape3D.new()
	var trunk_shape := CylinderShape3D.new()
	trunk_shape.radius = 0.28
	trunk_shape.height = 1.8
	trunk_collision.shape = trunk_shape
	trunk_collision.position.y = 0.9
	trunk_body.add_child(trunk_collision)

	var bark := StandardMaterial3D.new()
	bark.albedo_color = Color("#65452e")
	bark.roughness = 1.0
	var trunk := MeshInstance3D.new()
	var trunk_mesh := CylinderMesh.new()
	trunk_mesh.top_radius = 0.18
	trunk_mesh.bottom_radius = 0.28
	trunk_mesh.height = 1.8
	trunk_mesh.material = bark
	trunk.mesh = trunk_mesh
	trunk.position.y = 0.9
	tree.add_child(trunk)

	var greens: Array[Color] = [
		Color("#24583a"), Color("#2f6a42"), Color("#367447")
	]
	var leaves_material := StandardMaterial3D.new()
	leaves_material.albedo_color = greens[variant % greens.size()]
	leaves_material.roughness = 1.0
	var leaves := MeshInstance3D.new()
	var leaves_mesh := SphereMesh.new()
	leaves_mesh.radius = 0.95
	leaves_mesh.height = 1.9
	leaves_mesh.material = leaves_material
	leaves.mesh = leaves_mesh
	leaves.position.y = 2.0
	leaves.scale = Vector3(1.0, 1.15, 1.0)
	tree.add_child(leaves)


func _build_gate() -> void:
	_create_box(Vector3(-2.1, 1.4, -11.0), Vector3(0.3, 2.8, 0.35), Color("#68452d"))
	_create_box(Vector3(2.1, 1.4, -11.0), Vector3(0.3, 2.8, 0.35), Color("#68452d"))
	_create_box(Vector3(0.0, 2.75, -11.0), Vector3(4.8, 0.35, 0.5), Color("#874f31"))

	var sign := Label3D.new()
	sign.name = "GateSign"
	sign.text = "HIDDEN GROVE"
	sign.font_size = 42
	sign.outline_size = 8
	sign.position = Vector3(0.0, 3.5, -11.0)
	sign.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	add_child(sign)


func _create_box(world_position: Vector3, box_size: Vector3, color: Color) -> void:
	# Use the same dimensions for the visible gate piece and its collider.
	var body := StaticBody3D.new()
	body.position = world_position
	add_child(body)

	var box_instance := MeshInstance3D.new()
	var box_mesh := BoxMesh.new()
	box_mesh.size = box_size
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 0.9
	box_mesh.material = material
	box_instance.mesh = box_mesh
	body.add_child(box_instance)

	var collision := CollisionShape3D.new()
	var collision_shape := BoxShape3D.new()
	collision_shape.size = box_size
	collision.shape = collision_shape
	body.add_child(collision)


func _spawn_player() -> void:
	var player := CharacterBody3D.new()
	player.name = "Player"
	player.position = Vector3(0.0, 0.85, 4.0)
	player.set_script(PLAYER_CONTROLLER)
	add_child(player)


func _spawn_hud() -> void:
	var hud := CanvasLayer.new()
	hud.name = "MobileHUD"
	hud.set_script(MOBILE_HUD)
	add_child(hud)
