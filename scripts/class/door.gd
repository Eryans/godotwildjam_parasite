extends StaticBody3D
class_name Door

@export var is_open: bool = false

@onready var collider:CollisionShape3D = $CollisionShape3D

func _ready() -> void:
	pass


func toggle_door_open_state() -> void:
	print("set door open")
	is_open = !is_open
	collider.disabled = is_open
	visible = !is_open
