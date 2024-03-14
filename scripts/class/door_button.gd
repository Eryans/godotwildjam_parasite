extends Area3D
class_name DoorButton

@export var door: Door = null


func _ready():
	monitoring = true
	pass  

func _process(_delta):
	var bodies:Array[Node3D] = get_overlapping_bodies()
	for body in bodies:
		if body is Person && body.is_infected:
			if Input.is_action_just_pressed("ui_action"):
				door.toggle_door_open_state()

