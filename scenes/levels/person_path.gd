extends PathFollow3D
class_name PersonPath

@export var progress_ration_speed: float = 4

@onready var person_on_path: Person = get_child(0)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if person_on_path.current_state == person_on_path.person_state.CLEAN:
		progress_ratio += delta * progress_ration_speed
	pass
