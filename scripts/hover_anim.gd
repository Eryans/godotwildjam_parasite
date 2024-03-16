@tool
extends MeshInstance3D

var time: float = 0


func _process(delta):
	time += delta
	var va_et_vient = (sin(time * 0.2) + 1) / 2
	transform.origin.y = va_et_vient
	rotation.y += delta * 1.5
