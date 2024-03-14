extends EventItem
class_name DeadZone

@export var is_active: bool = false

@onready var collider: CollisionShape3D = $CollisionShape3D


func _ready() -> void:
	# EventManager.connect("")
	connect("body_entered", _on_body_entered)
	pass


func activate() -> void:
	print("set door open")
	is_active = !is_active
	collider.disabled = is_active
	visible = !is_active


func _on_body_entered(body: Node3D) -> void:
	if (body is Parasite) || (body is Person && body.current_state == body.person_state.INFECTED) && is_active:
		EventManager.parasite_in_dead_zone.emit()
