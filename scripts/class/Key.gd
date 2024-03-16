extends EventItem
class_name KeyEventItem

@export var key_number:int = 0

func activate():
	PlayerGlobal.player_keys.append(key_number)
	queue_free()