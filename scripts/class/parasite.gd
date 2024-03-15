extends RigidBody3D
class_name Parasite

@export var force: float = 15.0
@export var parasite_lifespan: float = 5
@export var parasite_can_infect_countdown: float = .1

@onready var can_jump: bool = true
@onready var target: Vector3 = Vector3()
@onready var timer: Timer = Timer.new()
@onready var camera_control: CameraControl = get_tree().root.get_node("Main/CameraControl")
@onready var can_infect_timer: Timer = Timer.new()
@onready var can_infect: bool = false

signal infect_person(person: Person)


func _ready():
	add_child(timer)
	timer.connect("timeout", _on_timer_timeout)
	timer.start(parasite_lifespan)
	add_child(can_infect_timer)
	can_infect_timer.connect("timeout", _on_can_infect_timer_timeout)
	can_infect_timer.start(parasite_can_infect_countdown)
	pass


func _process(_delta):
	if can_jump && Input.is_action_just_pressed("ui_accept"):
		var parasite_direction = (
			(camera_control.shoot_ray()) - (global_transform.origin)
		)
		shoot(parasite_direction.normalized())
		can_jump = false


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
