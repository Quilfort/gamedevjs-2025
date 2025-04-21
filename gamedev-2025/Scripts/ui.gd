extends Control

func _ready():
	_update_progress_bar()
	GameManager.exp_updated.connect(_on_exp_updated)
	
func _on_exp_updated(current_exp, exp_to_next_level):
	%TextureProgressBar.max_value = exp_to_next_level
	%TextureProgressBar.value = current_exp

func _update_progress_bar():
	%TextureProgressBar.max_value = GameManager.exp_to_next_level
	%TextureProgressBar.value = GameManager.current_exp
