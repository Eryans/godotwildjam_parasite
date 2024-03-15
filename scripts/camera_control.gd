extends SpringArm3D
class_name CameraControl

@export var camera_speed: float = 1

@onready var target: Node3D = null
@onready var camera: Camera3D = $CameraHolder/Camera3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if target != null:
		global_transform.origin = global_transform.origin.lerp(
			target.global_transform.origin, camera_speed * delta
		)
	var camera_rotation:float = Input.get_axis("rotate_left","rotate_right")
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
