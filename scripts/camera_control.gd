extends SpringArm3D
class_name CameraControl

@export var camera_speed: float = 1
@export var max_distance = 3.0

@onready var target: Node3D = null
@onready var camera: Camera3D = $CameraHolder/Camera3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if target != null:
		global_transform.origin = target.global_transform.origin


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if target != null:
		var mouse_camera_offset = -(target.global_transform.origin - shoot_ray())
		var clamped_offset
		if target is Person:
			clamped_offset = mouse_camera_offset.clamp(
				Vector3(-max_distance, -max_distance, -max_distance),
				Vector3(max_distance, max_distance, max_distance)
			)
		else:
			clamped_offset = Vector3.ZERO
		global_transform.origin = global_transform.origin.lerp(
			target.global_transform.origin + clamped_offset, camera_speed * delta
		)

	var camera_rotation: float = Input.get_axis("rotate_left", "rotate_right")
	if camera_rotation != 0:
		rotate_y(camera_rotation * delta)
	pass


func shoot_ray() -> Vector3:
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var ray_length: int = 1000
	var from: Vector3 = camera.project_ray_origin(mouse_pos)
	var to: Vector3 = from + camera.project_ray_normal(mouse_pos) * ray_length
	var space: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var ray_query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.new()
	ray_query.from = from
	ray_query.to = to
	ray_query.collision_mask = 3
	var result: Dictionary = space.intersect_ray(ray_query)
	if result.has("position"):
		return result.position
	return Vector3()
