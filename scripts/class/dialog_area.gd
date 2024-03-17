extends Area3D
class_name DialogArea

@export_multiline var text: String = ""

@onready var collider:CollisionShape3D = $CollisionShape3D
@onready var is_already_seen:bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered",_on_body_entered)
	connect("body_exited",_on_body_exited)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_body_entered(body:Node3D) -> void:
	if !is_already_seen && (body is Person && body.current_state == body.person_state.INFECTED) || (body is Parasite):
		EventManager.open_dialog_box.emit(text)
		is_already_seen = true
	pass

func _on_body_exited(body:Node3D) -> void:
	if (body is Person && body.current_state == body.person_state.INFECTED) || (body is Parasite):
		EventManager.close_dialog_box.emit()
	pass