extends Area3D
class_name Hitbox

var person_parent: Person


# Called when the node enters the scene tree for the first time.
func _ready():
	person_parent = get_parent()
	connect("body_entered", _on_body_entered)
	monitoring = true
	pass  # Replace with function body.


func _on_body_entered(body: Node3D) -> void:
	if body is Parasite:
		body.infection(person_parent)
