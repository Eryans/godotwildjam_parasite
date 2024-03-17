extends Area3D
class_name EventTriggerer

@export var event_items: Array[EventItem] = []
@export var custom_label_text: String = ""
@export var show_when_parasite:bool = false

@onready var label: Label3D = $Label3D
@onready var activate_sfx = %activate_sfx

func _ready():
	monitoring = true
	if custom_label_text != "":
		label.text = custom_label_text
	else:
		var key = InputMap.action_get_events("ui_action")[0].as_text()
		label.text = "Press %s to interact" % key
	connect("body_entered",_on_body_entered)
	connect("body_exited",_on_body_exit)
	pass


func _process(_delta):
	var bodies: Array[Node3D] = get_overlapping_bodies()
	for body in bodies:
		if body is Parasite:
			for item in event_items:
				if activate_sfx != null:
					activate_sfx.play()
				item.activate()
		if body is Person && body.current_state == body.person_state.INFECTED:
			if Input.is_action_just_pressed("ui_action"):
				if activate_sfx != null:
					activate_sfx.play()
				for item in event_items:
					item.activate()

func _on_body_entered(body:Node3D) -> void:
	if label != null && (body is Person && body.current_state == body.person_state.INFECTED) || (body is Parasite && show_when_parasite):
		label.visible = true

func _on_body_exit(body:Node3D) -> void:
	if label != null && (body is Person && body.current_state == body.person_state.INFECTED) || (body is Parasite && show_when_parasite):
		label.visible = false
	pass