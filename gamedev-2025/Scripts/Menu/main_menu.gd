extends Node2D

@onready var accept_sfx: AudioStreamPlayer = $Audio/AcceptSFX
@onready var exit_sfx: AudioStreamPlayer = $Audio/ExitSFX
@onready var background_music: AudioStreamPlayer = $Audio/BackgroundMusic

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	background_music.play()


func _on_start_button_pressed() -> void:
	accept_sfx.play()
	get_tree().change_scene_to_file("res://Scenes/battlefield.tscn")


func _on_exit_button_pressed() -> void:
		#Add ConfirmationModal
	exit_sfx.play()
	await exit_sfx.finished
	get_tree().quit()
