extends Node3D

@onready var main_scene:Node = preload("res://scenes/main.tscn").instantiate()



func _on_play_button_pressed():
	for child in get_children():
		remove_child(child)
	get_tree().root.add_child(main_scene)
	pass # Replace with function body.
