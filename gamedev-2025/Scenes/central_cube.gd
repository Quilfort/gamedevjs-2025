extends Node2D

func _ready() -> void:
	# Center the cube in the middle of the screen
	position = get_viewport_rect().size / 2
