extends Node2D

# Background
@onready var background_image = %Background

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func set_background(background_path):
	var texture = load(background_path)
	
	if texture:
		background_image.texture = texture
	else:
		# print("Failed to load texture from path:", background_path)
		pass
