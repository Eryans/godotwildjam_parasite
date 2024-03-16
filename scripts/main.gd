extends Node3D

@export var current_host: Person = null
@export var starting_level: int = 0

@onready var camera_control: CameraControl = $CameraControl
@onready var level_manager: LevelManager = $LevelManager

var parasite_scn: PackedScene = preload("res://scenes/parasite.tscn")
var is_gameover: bool = false
var parasite: Parasite

const SPEED = 3.5


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
	if Input.is_action_just_pressed("ui_enter") && is_gameover:
		is_gameover = false
		level_manager.load_level(level_manager.current_level)

	if current_host && !is_gameover:
		if Input.is_action_just_pressed("shoot"):
			parasite = parasite_scn.instantiate()
			parasite.connect("infect_person", _on_parasite_infect_person)
			add_child(parasite)
			# Make the parasite start a little bit higher for a better shooting angle
			parasite.global_transform.origin = current_host.parasite_mesh.global_transform.origin
			var mouse_vec: Vector3 = camera_control.shoot_ray()
			var parasite_direction = (
				(Vector3(mouse_vec.x, 1, mouse_vec.z)) - (parasite.global_transform.origin)
			)
			parasite.shoot(Vector3(parasite_direction.normalized().x * 2 ,1,parasite_direction.normalized().z * 2))
			camera_control.target = parasite
			current_host.set_dead_or_stunned()
			current_host = null
			return

		var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		var camera_forward = camera_control.transform.basis.z.normalized()
		var camera_right = camera_control.transform.basis.x.normalized()
		var direction = camera_forward * input_dir.y + camera_right * input_dir.x
		current_host.velocity.x = direction.x * SPEED
		current_host.velocity.z = direction.z * SPEED


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
	is_gameover = true
	if parasite != null:
		parasite.queue_free()
	# current_host.current_state = current_host.person_state.DEAD
	print("DEAD X_X")
