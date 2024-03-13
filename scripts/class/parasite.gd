extends RigidBody3D
class_name Parasite

@export var force: float = 5.0
@export var parasite_lifespan: float = 5

@onready var can_jump: bool = true
@onready var target: Vector3 = Vector3()
@onready var timer: Timer = Timer.new()
@onready var camera_control: CameraControl = get_tree().root.get_node("Main/CameraControl")
signal infect_person(person: Person)


func _ready():
	add_child(timer)
	timer.connect("timeout", _on_timer_timeout)
	timer.start(parasite_lifespan)
	pass


func _process(_delta):
	if can_jump && Input.is_action_just_pressed("ui_accept"):
		var parasite_direction = (
			(camera_control.shoot_ray() + Vector3.UP) - (global_transform.origin)
		)
		shoot(parasite_direction.normalized())
		can_jump = false


func shoot(direction) -> void:
	apply_central_impulse(direction * force)


func infection(person: Person):
	if !person.is_infected:
		infect_person.emit(person)
		queue_free()


func _on_timer_timeout() -> void:
	EventManager.parasite_died.emit()
