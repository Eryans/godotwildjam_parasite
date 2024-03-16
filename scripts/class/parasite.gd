extends RigidBody3D
class_name Parasite

@export var force: float = 15.0
@export var parasite_lifespan: float = 5
@export var parasite_can_infect_countdown: float = .1
@export var parasite_anim_speed: int = 5

@onready var can_jump: bool = true
@onready var target: Vector3 = Vector3()
@onready var timer: Timer = Timer.new()
@onready var mesh_parent_node: Node3D = $parasite
@onready var camera_control: CameraControl = get_tree().root.get_node("Main/CameraControl")
@onready var can_infect_timer: Timer = Timer.new()
@onready var can_infect: bool = false
# @onready var GPU_particles: GPUParticles3D = $GPUParticles3D

signal infect_person(person: Person)

var time:float = 0

func _ready():
	add_child(timer)
	timer.connect("timeout", _on_timer_timeout)
	timer.start(parasite_lifespan)
	add_child(can_infect_timer)
	can_infect_timer.connect("timeout", _on_can_infect_timer_timeout)
	can_infect_timer.start(parasite_can_infect_countdown)

	pass


func _process(delta):
	time += delta
	# GPU_particles.process_material.gravity = Vector3(0, 0, -10 * clamp(linear_velocity.length(), 1, 20))
	# var sin_value = (sin(time) + 1) / 2  # Transforme le sinus de [-1, 1] à [0, 1]
	# var normalized_value = 0.25 + sin_value * 0.25  # Étend la plage de [0, 1] à [0.1, 0.35]

	# mesh_parent_node.scale = Vector3(normalized_value,normalized_value,normalized_value)

	if can_jump && Input.is_action_just_pressed("ui_accept"):
		# var parasite_direction = (camera_control.shoot_ray() + Vector3.UP) - (global_transform.origin)
		var mouse_vec: Vector3 = camera_control.shoot_ray()
		var parasite_direction = (Vector3(mouse_vec.x, 1, mouse_vec.z)) - (global_transform.origin)
		shoot(parasite_direction.normalized())
		can_jump = false

	var look_at_direction = camera_control.shoot_ray() - global_transform.origin
	var target_rotation = atan2(look_at_direction.x, look_at_direction.z)
	if target_rotation < 0:
		target_rotation += 2 * PI

	mesh_parent_node.rotation.y = lerp_angle(mesh_parent_node.rotation.y, target_rotation, 1)
	if linear_velocity.length() > 2:
		mesh_parent_node.scale.x = lerp(mesh_parent_node.scale.x, .1, delta * parasite_anim_speed)
	else:
		mesh_parent_node.scale.x = lerp(
			mesh_parent_node.scale.x, .325, delta * parasite_anim_speed
		)


func shoot(direction) -> void:
	apply_central_impulse(direction * force)


func infection(person: Person):
	if (
		(
			person.current_state == person.person_state.CLEAN
			|| person.current_state == person.person_state.STUNNED
		)
		&& can_infect
	):
		infect_person.emit(person)
		queue_free()


func _on_timer_timeout() -> void:
	EventManager.parasite_died.emit()


func _on_can_infect_timer_timeout() -> void:
	can_infect = true
