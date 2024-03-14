@tool
extends EventItem
class_name DeadZone

@export var is_active: bool = false
@export var size: Vector3 = Vector3(1, .25, 1)

@onready var collider: CollisionShape3D = $CollisionShape3D
@onready var mesh: MeshInstance3D = $MeshInstance3D


func _ready() -> void:
	# EventManager.connect("")
	connect("body_entered", _on_body_entered)

	pass


func _process(_delta) -> void:
	if Engine.is_editor_hint():
		mesh.mesh.size = size
		collider.shape.size = size


func activate() -> void:
	print("toggle dead zone")
	is_active = !is_active
	if collider:
		collider.disabled = is_active
	if mesh:
		mesh.visible = !is_active


func _on_body_entered(body: Node3D) -> void:
	if (
		(body is Parasite)
		|| (body is Person && body.current_state == body.person_state.INFECTED) && is_active
	):
		EventManager.parasite_in_dead_zone.emit()
