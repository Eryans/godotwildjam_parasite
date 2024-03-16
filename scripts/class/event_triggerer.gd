extends Area3D
class_name EventTriggerer

@export var event_items: Array[EventItem] = []


func _ready():
	monitoring = true
	pass


func _process(_delta):
	var bodies: Array[Node3D] = get_overlapping_bodies()
	for body in bodies:
		if body is Parasite:
			for item in event_items:
				item.activate()
		if body is Person && body.current_state == body.person_state.INFECTED:
			if Input.is_action_just_pressed("ui_action"):
				for item in event_items:
					item.activate()
