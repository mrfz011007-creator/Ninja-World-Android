extends SceneTree

func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var packed_scene := load("res://scenes/main.tscn") as PackedScene
	if packed_scene == null:
		push_error("FAIL: Could not load the main scene.")
		quit(1)
		return

	var world := packed_scene.instantiate() as Node3D
	if world == null:
		push_error("FAIL: Main scene root is not a Node3D.")
		quit(1)
		return
	root.add_child(world)
	await process_frame

	var trees := world.find_children("Tree_*", "Node3D", true, false)
	if trees.size() != 20:
		push_error("FAIL: Expected 20 trees, found %d." % trees.size())
		quit(1)
		return

	for tree_node in trees:
		var trunk_body := tree_node.get_node_or_null("TrunkCollision") as StaticBody3D
		if trunk_body == null:
			push_error("FAIL: %s has no trunk physics body." % tree_node.name)
			quit(1)
			return

		var trunk_shapes := trunk_body.find_children("*", "CollisionShape3D", true, false)
		if trunk_shapes.size() != 1:
			push_error("FAIL: %s must have exactly one trunk collision shape." % tree_node.name)
			quit(1)
			return

		var trunk_shape := (trunk_shapes[0] as CollisionShape3D).shape as CylinderShape3D
		if trunk_shape == null:
			push_error("FAIL: %s trunk collider is not cylindrical." % tree_node.name)
			quit(1)
			return
		if not is_equal_approx(trunk_shape.radius, 0.28) or not is_equal_approx(trunk_shape.height, 1.8):
			push_error("FAIL: %s trunk collider dimensions do not match the trunk." % tree_node.name)
			quit(1)
			return

	var gate_body_count := 0
	var static_bodies := world.find_children("*", "StaticBody3D", true, false)
	for body_node in static_bodies:
		var body := body_node as StaticBody3D
		if body.get_parent() != world or body.name == "Ground":
			continue

		gate_body_count += 1
		var collision_nodes := body.find_children("*", "CollisionShape3D", false, false)
		var mesh_nodes := body.find_children("*", "MeshInstance3D", false, false)
		if collision_nodes.size() != 1 or mesh_nodes.size() != 1:
			push_error("FAIL: Each gate piece must have one mesh and one collider.")
			quit(1)
			return

		var gate_shape := (collision_nodes[0] as CollisionShape3D).shape as BoxShape3D
		var gate_mesh := (mesh_nodes[0] as MeshInstance3D).mesh as BoxMesh
		if gate_shape == null or gate_mesh == null:
			push_error("FAIL: Gate mesh and collider must both be boxes.")
			quit(1)
			return
		if not gate_shape.size.is_equal_approx(gate_mesh.size):
			push_error("FAIL: Gate collider dimensions differ from its visible mesh.")
			quit(1)
			return

	if gate_body_count != 3:
		push_error("FAIL: Expected 3 collidable gate pieces, found %d." % gate_body_count)
		quit(1)
		return

	var tree_probe_ok: bool = await _probe_collision(
		world, "TreeCollisionProbe", Vector3(-8.0, 1.0, -4.0),
		Vector3(0.0, 0.0, -5.0), "tree"
	)
	if not tree_probe_ok:
		quit(1)
		return

	var gate_probe_ok: bool = await _probe_collision(
		world, "GateCollisionProbe", Vector3(0.0, 1.0, -11.0),
		Vector3(3.0, 0.0, 0.0), "gate"
	)
	if not gate_probe_ok:
		quit(1)
		return

	print("PASS: all 20 trees have trunk colliders, all 3 gate pieces match their colliders, and physics probes hit a tree and gate post.")
	quit(0)


func _probe_collision(
	world: Node3D,
	probe_name: String,
	start_position: Vector3,
	motion: Vector3,
	expected_kind: String
) -> bool:
	var probe := CharacterBody3D.new()
	probe.name = probe_name
	var shape_node := CollisionShape3D.new()
	var capsule := CapsuleShape3D.new()
	capsule.radius = 0.4
	capsule.height = 1.7
	shape_node.shape = capsule
	probe.add_child(shape_node)
	world.add_child(probe)
	probe.global_position = start_position
	await physics_frame

	var hit := probe.move_and_collide(motion)
	if hit == null:
		push_error("FAIL: Physics probe did not collide with a %s." % expected_kind)
		probe.queue_free()
		return false

	var collider := hit.get_collider() as Node
	if collider == null:
		push_error("FAIL: Physics probe returned no collider node.")
		probe.queue_free()
		return false

	if expected_kind == "tree" and collider.name != "TrunkCollision":
		push_error("FAIL: Tree probe hit %s instead of the trunk." % collider.name)
		probe.queue_free()
		return false
	if expected_kind == "gate" and (collider.get_parent() != world or collider.name == "Ground"):
		push_error("FAIL: Gate probe hit %s instead of a gate piece." % collider.name)
		probe.queue_free()
		return false

	probe.queue_free()
	await process_frame
	return true
