extends Node3D

@export var current_host: Person = null

@onready var camera: Camera3D = $Camera3D

var parasite_scn: PackedScene = preload("res://scenes/parasite.tscn")

const SPEED = 5.0


# Called when the node enters the scene tree for the first time.
func _ready():
	if current_host:
		current_host.set_infected()
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if current_host:
		if Input.is_action_just_pressed("ui_accept"):
			var parasite: Parasite = parasite_scn.instantiate()
			parasite.connect("infect_person", _on_parasite_infect_person)
			add_child(parasite)
			parasite.global_transform.origin = current_host.global_transform.origin
			var parasite_direction = shoot_ray().position - parasite.global_transform.origin
			parasite.shoot(parasite_direction.normalized())
			current_host = null
			return

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		var direction = (
			(current_host.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		)
		if direction:
			current_host.velocity.x = direction.x * SPEED
			current_host.velocity.z = direction.z * SPEED
		else:
			current_host.velocity.x = move_toward(current_host.velocity.x, 0, SPEED)
			current_host.velocity.z = move_toward(current_host.velocity.z, 0, SPEED)


func shoot_ray() -> Dictionary:
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var ray_length: int = 1000
	var from: Vector3 = camera.project_ray_origin(mouse_pos)
	var to: Vector3 = from + camera.project_ray_normal(mouse_pos) * ray_length
	var space: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var ray_query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.new()
	ray_query.from = from
	ray_query.to = to
	return space.intersect_ray(ray_query)


func _on_parasite_infect_person(person:Person):
	person.set_infected()
	current_host = person
	pass
