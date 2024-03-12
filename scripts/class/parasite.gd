extends RigidBody3D
class_name Parasite

@export var force: float = 5.0

signal infect_person(person: Person)


func _ready():
	pass


func shoot(direction) -> void:
	apply_central_impulse(direction * force)


func infection(person: Person):
	if !person.is_infected:
		infect_person.emit(person)
		queue_free()
