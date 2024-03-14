extends Area3D
class_name LevelExit

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered",_on_body_entered)
	monitoring = true
	pass # Replace with function body.


func _on_body_entered(body: Node3D) -> void:
	if body is Person:
		if body.current_state == body.person_state.INFECTED:
			EventManager.parasite_entered_exit.emit()