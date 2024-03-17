extends Node3D

@onready var main_scene:Node = preload("res://scenes/main.tscn").instantiate()
@onready var level_container = %LevelContainer

func _ready():
	EventManager.connect("load_selected_level", _on_load_selected_level)

func _on_play_button_pressed() -> void:
	for child in get_children():
		remove_child(child)
	get_tree().root.add_child(main_scene)

func _on_button_load_level_pressed() -> void:
	level_container.visible = !level_container.visible

func _on_load_selected_level(level:int) -> void:
	for child in get_children():
		remove_child(child)
	main_scene.starting_level = level
	get_tree().root.add_child(main_scene)

func _on_quit_button_pressed():
	get_tree().quit()