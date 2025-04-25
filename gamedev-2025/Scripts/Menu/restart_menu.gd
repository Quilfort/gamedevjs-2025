extends Node2D

#Background Image
var background_image_path = "res://Assets/Menu/background_restart_menu.png"

#Audio
@onready var accept_sfx: AudioStreamPlayer = $Audio/AcceptSFX
@onready var exit_sfx: AudioStreamPlayer = $Audio/ExitSFX
@onready var background_music: AudioStreamPlayer = $Audio/BackgroundMusic

#Label
@onready var restart_menu_label: RichTextLabel = $Control/RestartMenuLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%MenuBackground.set_background(background_image_path)
	background_music.play()
	show_message() 

func show_message():
	var final_time = get_final_time()
	var message = ""
	
	if final_time:
		restart_menu_label.text = "Game over! Your time is " + get_final_time() + "\n\nRestart?"
	else:
		restart_menu_label.text = "Game over!\n\nRestart?"
		
func get_final_time():
	var seconds = int(GameManager.get_elapsed_time()) % 60
	var minutes = int(GameManager.get_elapsed_time()) / 60
	var final_time = "%02d:%02d" % [minutes, seconds]
	return final_time

func _on_restart_button_pressed() -> void:
	accept_sfx.play()
	GameManager.reset_game_values()
	get_tree().change_scene_to_file("res://Scenes/battlefield.tscn")

func _on_exit_button_pressed() -> void:
	#Add ConfirmationModal
	exit_sfx.play()
	await exit_sfx.finished
	get_tree().quit()
