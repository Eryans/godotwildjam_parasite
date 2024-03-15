extends CharacterBody3D
class_name Person

@export var current_state: person_state = person_state.CLEAN
@export var stronger: bool = false

@onready var mesh: MeshInstance3D = $body
@onready var parasite_mesh = $scientist/Head_002/parasite
@onready var material: Material = mesh.get_surface_override_material(0)
@onready var is_dead: bool = false
@onready var camera_control: CameraControl = get_tree().root.get_node("Main/CameraControl")

enum person_state { DEAD, CLEAN, INFECTED, STUNNED }
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	if current_state == person_state.INFECTED:
		material.albedo_color = Color(1, 0, 0)
	if stronger:
		scale *= 1.4


func _physics_process(delta):
	if current_state == person_state.INFECTED:
		var look_at_direction = camera_control.shoot_ray() - global_transform.origin
		var target_rotation = atan2(look_at_direction.x, look_at_direction.z)
		if target_rotation < 0:
			target_rotation += 2 * PI

		rotation.y = lerp_angle(rotation.y, target_rotation, 1)
	if not is_on_floor():
		velocity.y -= gravity * delta
	move_and_slide()


func set_infected() -> void:
	current_state = person_state.INFECTED
	material.albedo_color = Color(1, 0, 0)
	parasite_mesh.visible = true


func set_dead_or_stunned() -> void:
	current_state = person_state.DEAD if !stronger else person_state.STUNNED
	is_dead = true
	parasite_mesh.visible = false
