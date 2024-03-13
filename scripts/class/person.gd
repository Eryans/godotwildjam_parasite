extends CharacterBody3D
class_name Person

@export var is_infected: bool = false

@onready var mesh:MeshInstance3D = $body
@onready var material: Material = mesh.get_surface_override_material(0)
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	if is_infected:
		material.albedo_color = Color(1,0,0)


func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	move_and_slide()


func set_infected() -> void:
	is_infected = true
	material.albedo_color = Color(1,0,0)
