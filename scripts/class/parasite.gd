extends RigidBody3D
class_name Parasite

@export var force: float = 15.0
@export var parasite_lifespan: float = 5
@export var parasite_can_infect_countdown: float = .1
@export var parasite_can_jump_countdown: float = 1.5
@export var can_direction_impulse_countdown: float = 0.75

@export var parasite_anim_speed: int = 5
@export var speed: float = 5.0

@onready var can_jump: bool = true
@onready var target: Vector3 = Vector3()
@onready var timer: Timer = Timer.new()
@onready var mesh_parent_node: Node3D = $parasite
@onready var camera_control: CameraControl = get_tree().root.get_node("Main/CameraControl")
@onready var can_infect_timer: Timer = Timer.new()
@onready var can_jump_timer: Timer = Timer.new()
@onready var can_direction_impulse_timer: Timer = Timer.new()
@onready var can_infect: bool = false
@onready var can_direction_impulse: bool = true
# @onready var GPU_particles: GPUParticles3D = $GPUParticles3D

signal infect_person(person: Person)

var time: float = 0


func _ready():
	add_child(timer)
	timer.connect("timeout", _on_timer_timeout)
	timer.start(parasite_lifespan)
	add_child(can_infect_timer)
	can_infect_timer.connect("timeout", _on_can_infect_timer_timeout)
	can_infect_timer.start(parasite_can_infect_countdown)
	add_child(can_jump_timer)
	can_infect_timer.connect("timeout", _on_can_jump_timer_timeout)
	can_infect_timer.start(parasite_can_jump_countdown)
	add_child(can_direction_impulse_timer)
	can_infect_timer.connect("timeout", _on_can_direction_impulse_timeout)
	can_infect_timer.start(can_direction_impulse_countdown)
	pass


func _physics_process(delta):
	time += delta
	if can_jump && Input.is_action_just_pressed("ui_accept"):
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
		mesh_parent_node.scale.x = lerp(mesh_parent_node.scale.x, .325, delta * parasite_anim_speed)

	if (
		(
			Input.is_action_just_pressed("ui_left")
			|| Input.is_action_just_pressed("ui_right")
			|| Input.is_action_just_pressed("ui_down")
			|| Input.is_action_just_pressed("ui_up")
		)
		&& can_direction_impulse
	):
		var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		var camera_forward = camera_control.transform.basis.z.normalized()
		var camera_right = camera_control.transform.basis.x.normalized()
		var direction = camera_forward * input_dir.y + camera_right * input_dir.x
		var final_speed = speed
		if linear_velocity.y != 0:
			final_speed = speed / 2
		apply_central_impulse(
			Vector3(
				direction.normalized().x * final_speed,
				linear_velocity.y,
				direction.normalized().z * final_speed
			)
		)
		can_direction_impulse = false


func shoot(direction) -> void:
	if transform.origin.y < 1:
		apply_central_impulse(Vector3.UP * (3 + (2 if floor(linear_velocity.y) == 0 else 0)))
	apply_central_impulse(direction * force)


func infection(person: Person) -> void:
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


func _on_can_jump_timer_timeout() -> void:
	can_jump = true


func _on_can_direction_impulse_timeout() -> void:
	can_direction_impulse = true
