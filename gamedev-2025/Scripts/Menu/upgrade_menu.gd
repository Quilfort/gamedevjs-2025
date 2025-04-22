extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	refresh_options()

func refresh_options():
	%LabelHeader.text = "Choose a Power-up for Level %d" % GameManager.current_level


func _on_upgrade_power_north_pressed() -> void:
	GameManager.tower_attack_north += 1
	finish_upgrade()

func _on_upgrade_power_east_pressed() -> void:
	GameManager.tower_attack_east += 1
	finish_upgrade()


func _on_upgrade_power_south_pressed() -> void:
	GameManager.tower_attack_south += 1
	finish_upgrade()


func _on_upgrade_power_west_pressed() -> void:
	GameManager.tower_attack_west += 1
	finish_upgrade()

func finish_upgrade():
	GameManager.upgrade_menu.visible = false
	get_tree().paused = false
