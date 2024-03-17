extends Button

@export var level: int = 0


func _ready():
	text = "level {num}".format({"num": level})


func _on_pressed():
	EventManager.load_selected_level.emit(level)
	pass  # Replace with function body.
