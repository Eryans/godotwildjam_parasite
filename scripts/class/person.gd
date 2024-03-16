extends CharacterBody3D
class_name Person

@export var current_state: person_state = person_state.CLEAN
@export var stronger: bool = false

@onready var collider: CollisionShape3D = $CollisionShape3D
@onready var parasite_mesh = $scientist/metarig/Skeleton3D/Head_002/parasite
@onready var body_mesh = $scientist/metarig/Skeleton3D/Body_001
@onready var blouse_material: Material = body_mesh.get_surface_override_material(1)
@onready var camera_control: CameraControl = get_tree().root.get_node("Main/CameraControl")
@onready var skeleton: Skeleton3D = $scientist/metarig/Skeleton3D

enum person_state { DEAD, CLEAN, INFECTED, STUNNED }
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready():
	if stronger:
		blouse_material.albedo_color = Color(1, 0, 0)
	else:
		blouse_material.albedo_color = Color(1, 1, 1)


func _physics_process(delta):
	if current_state == person_state.DEAD:
		velocity = Vector3.ZERO
		global_transform.origin.y = 0
	if current_state == person_state.INFECTED:
		parasite_mesh.visible = true
		var look_at_direction = camera_control.shoot_ray() - global_transform.origin
		var target_rotation = atan2(look_at_direction.x, look_at_direction.z)
		if target_rotation < 0:
			target_rotation += 2 * PI

		rotation.y = lerp_angle(rotation.y, target_rotation, 1)
	else:
		parasite_mesh.visible = false
	if not is_on_floor():
		velocity.y -= gravity * delta
	move_and_slide()


func set_infected() -> void:
	current_state = person_state.INFECTED


func set_dead_or_stunned(force_death = false) -> void:
	current_state = person_state.DEAD if !stronger else person_state.STUNNED
	if current_state == person_state.DEAD || force_death:
		skeleton.physical_bones_start_simulation()
		collider.disabled = true
