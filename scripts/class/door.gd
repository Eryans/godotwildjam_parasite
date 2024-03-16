extends EventItem
class_name Door

@export var is_open: bool = false
@export var use_key: bool = false
@export var key: int = 0

@onready var collider: CollisionShape3D = $CollisionShape3D
@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var interaction_area: Area3D = $DoorInteractionZone


func _ready() -> void:
	pass


func activate() -> void:
	print("set door open")
	is_open = !is_open
	collider.disabled = is_open
	mesh.visible = !is_open


func _process(_delta):
	var bodies: Array[Node3D] = interaction_area.get_overlapping_bodies()
	for body in bodies:
		if body is Person && body.current_state == body.person_state.INFECTED:
			if Input.is_action_just_pressed("ui_action"):
				var key_index = PlayerGlobal.player_keys.find(key)
				if key_index != -1:
					activate()
					PlayerGlobal.player_keys.pop_at(key_index)
