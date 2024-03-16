@tool
extends Node3D

@export var toggle_on_off: bool = false
@export var toggle_on_off_duration: float = 2.0

@onready var death_zone = $DeadZone


func _ready():
	death_zone.toggle_on_off = toggle_on_off
	death_zone.toggle_on_off_duration = toggle_on_off_duration

func _process(_delta):
	if Engine.is_editor_hint():
		death_zone.toggle_on_off = toggle_on_off
		death_zone.toggle_on_off_duration = toggle_on_off_duration