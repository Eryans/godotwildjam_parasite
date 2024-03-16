extends EventItem
class_name Door

@export var is_open: bool = false
@export var use_key: bool = false
@export var key: int = 0

@onready var collider: CollisionShape3D = $CollisionShape3D
@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var interaction_area: Area3D = $DoorInteractionZone
@onready var sprite_3D: Sprite3D = $Sprite3D

@onready var has_key_texture = load("res://assets/materials/Textures/has_key.png")
@onready var has_not_key_texture = load("res://assets/materials/Textures/has_not_key.png")
@onready var terminal_icon = load("res://assets/materials/Textures/terminal_icon.png")


func _ready() -> void:
	interaction_area.connect("body_entered", _on_body_entered)
	interaction_area.connect("body_exited", _on_body_exit)
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


func _on_body_entered(_body:Node3D) -> void:
	if !is_open:
		if use_key:
			var key_index = PlayerGlobal.player_keys.find(key)
			if key_index != -1:
				sprite_3D.texture = has_key_texture
			else :
				sprite_3D.texture = has_not_key_texture
		else:
			sprite_3D.texture = terminal_icon
		sprite_3D.visible = true


func _on_body_exit(_body:Node3D) -> void:
	sprite_3D.visible = false
	pass
