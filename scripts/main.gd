extends Node3D

@export var current_host: Person = null
@export var starting_level: int = 0

@onready var camera_control: CameraControl = $CameraControl
@onready var level_manager: LevelManager = $LevelManager

var parasite_scn: PackedScene = preload("res://scenes/parasite.tscn")

const SPEED = 5.0


func _ready():
	EventManager.connect("level_change", _on_level_change)
	EventManager.connect("parasite_died", _on_parasite_died)
	EventManager.connect("parasite_in_dead_zone", _on_parasite_enter_deadzone)
	level_manager.load_level(starting_level)
	current_host = level_manager.get_patient_zero()
	if current_host:
		current_host.set_infected()
		camera_control.target = current_host
	pass


func _process(_delta):
	if current_host:
		if Input.is_action_just_pressed("ui_accept"):
			var parasite: Parasite = parasite_scn.instantiate()
			parasite.connect("infect_person", _on_parasite_infect_person)
			add_child(parasite)
			# Make the parasite start a little bit higher for a better shooting angle
			parasite.global_transform.origin = current_host.global_transform.origin + Vector3.UP
			var parasite_direction = (
				(camera_control.shoot_ray() + Vector3.UP) - (parasite.global_transform.origin)
			)
			parasite.shoot(parasite_direction.normalized())
			camera_control.target = parasite
			current_host.set_dead_or_stunned()
			current_host = null
			return

		var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		var direction = Vector3(input_dir.x, 0, input_dir.y).normalized()
		if direction:
			current_host.velocity.x = direction.x * SPEED
			current_host.velocity.z = direction.z * SPEED
		else:
			current_host.velocity.x = move_toward(current_host.velocity.x, 0, SPEED)
			current_host.velocity.z = move_toward(current_host.velocity.z, 0, SPEED)


func _on_parasite_infect_person(person: Person):
	person.set_infected()
	current_host = person
	camera_control.target = current_host
	pass


func _on_level_change(person: Person) -> void:
	current_host = person
	camera_control.target = current_host


func _on_parasite_died() -> void:
	gameover()


func _on_parasite_enter_deadzone() -> void:
	gameover()
	pass


func gameover() -> void:
	print("DEAD X_X")
