@tool
extends EventItem
class_name DeadZone

@export var is_active: bool = true
@export var size: Vector3 = Vector3(1, .25, 1)
@export var toggle_on_off: bool = false
@export var toggle_on_off_duration: float = 2.0

@onready var toggle_on_off_timer: Timer = Timer.new()
@onready var collider: CollisionShape3D = $CollisionShape3D
@onready var mesh: MeshInstance3D = $MeshInstance3D


func _ready() -> void:
	connect("body_entered", _on_body_entered)
	is_active = true
	mesh.mesh.size = size
	collider.shape.size = size
	collider.disabled = false
	if toggle_on_off:
		add_child(toggle_on_off_timer)
		toggle_on_off_timer.connect("timeout", _on_toggle_on_off)
		toggle_on_off_timer.start(toggle_on_off_duration)
	pass


func _process(_delta) -> void:
	if Engine.is_editor_hint():
		mesh.mesh.size = size
		collider.shape.size = size


func activate() -> void:
	if !Engine.is_editor_hint():
		is_active = !is_active
		if collider:
			collider.disabled = !is_active
		if mesh:
			mesh.visible = is_active


func _on_body_entered(body: Node3D) -> void:
	if (body is Parasite) || (body is Person && body.current_state == body.person_state.INFECTED):
		EventManager.parasite_in_dead_zone.emit()


func _on_toggle_on_off() -> void:
	activate()
