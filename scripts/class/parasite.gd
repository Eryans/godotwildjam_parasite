extends Area3D
class_name Parasite

@export var speed:float = 5.0

@onready var direction:Vector3 = Vector3.ZERO

signal infect_person(person:Person)
# Called when the node enters the scene tree for the first time.
func _ready():
	monitoring = true
	connect("body_entered",_on_body_entered)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if direction:
		global_transform.origin += direction * (delta * speed)
	pass

func _on_body_entered(body:Node3D):
	if body is Person:
		if !body.is_infected:
			infect_person.emit(body)
			queue_free()