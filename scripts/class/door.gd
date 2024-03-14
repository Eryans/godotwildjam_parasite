extends EventItem
class_name Door

@export var is_open: bool = false

@onready var collider:CollisionShape3D = $CollisionShape3D

func _ready() -> void:
	pass


func activate() -> void:
	print("set door open")
	is_open = !is_open
	collider.disabled = is_open
	visible = !is_open
