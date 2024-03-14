extends CharacterBody3D
class_name Person

@export var is_infected: bool = false

@onready var mesh: MeshInstance3D = $body
@onready var material: Material = mesh.get_surface_override_material(0)
@onready var is_dead: bool = false
@onready var camera_control: CameraControl = get_tree().root.get_node("Main/CameraControl")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready():
	if is_infected:
		material.albedo_color = Color(1, 0, 0)


func _physics_process(delta):
	if !is_dead && is_infected:
		var look_at_direction = camera_control.shoot_ray() - global_transform.origin
		var target_rotation = atan2(look_at_direction.x, look_at_direction.z)
		if target_rotation < 0:
			target_rotation += 2 * PI

		mesh.rotation.y = lerp_angle(mesh.rotation.y, target_rotation, 1)
	if not is_on_floor():
		velocity.y -= gravity * delta
	move_and_slide()


func set_infected() -> void:
	is_infected = true
	material.albedo_color = Color(1, 0, 0)


func set_dead() -> void:
	is_dead = true
