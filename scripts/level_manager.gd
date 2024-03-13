extends Node
class_name LevelManager

@onready var current_level: int = 0
@onready var starting_point: Marker3D

var player_to_spawn: PackedScene = preload("res://scenes/person.tscn")
var player_instance: Person = null


func _ready():
	EventManager.connect("parasite_entered_exit", _on_parasite_entered_exit)


func load_level(level_num: int) -> void:
	var level_path: String = "res://scenes/levels/level_{num}.tscn".format({"num": level_num})
	for child in get_children():
		# Empty level first
		child.queue_free()

	var level_to_load: PackedScene = load(level_path)
	var instance = level_to_load.instantiate()
	add_child(instance)
	instance.global_rotation.y = -60
	starting_point = instance.get_node("StartingZone")
	player_instance = player_to_spawn.instantiate()
	player_instance.is_infected = true
	add_child(player_instance)
	player_instance.global_transform.origin = starting_point.global_transform.origin
	EventManager.level_change.emit(player_instance)


func _on_parasite_entered_exit() -> void:
	if get_next_level():
		current_level += 1
		load_level(current_level)
	else:
		print("no more level")
	pass


func get_next_level() -> bool:
	var level_path = "res://scenes/levels/level_{num}.tscn".format({"num": current_level + 1})
	return FileAccess.file_exists(level_path)


func get_patient_zero() -> Person:
	return player_instance
