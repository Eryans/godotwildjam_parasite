extends SpringArm3D
class_name CameraControl

@export var camera_speed: float = 1

@onready var target: Node3D = null
@onready var camera: Camera3D = $Camera3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if target != null:
		global_transform.origin = global_transform.origin.lerp(target.global_transform.origin, camera_speed * delta)
	pass
