extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_restart_button_pressed() -> void:
	GameManager.reset_game_values()
	get_tree().change_scene_to_file("res://Scenes/battlefield.tscn")

func _on_exit_button_pressed() -> void:
	#Add ConfirmationModal
	get_tree().quit()
