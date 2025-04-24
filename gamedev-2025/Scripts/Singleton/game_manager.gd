extends Node

# Experience
signal exp_updated(current_exp, exp_to_next)
var current_level := 1
var current_exp := 0.0
var exp_to_next_level := 5.0
var exp_growth_factor := 1.3

#Tower Attack
var tower_attack_north: int = 1
var tower_attack_east:int  = 1
var tower_attack_south:int  = 1
var tower_attack_west:int = 1

# Attack speed (lower = faster shooting)
var tower_attack_speed_north := 1.0
var tower_attack_speed_east := 1.0
var tower_attack_speed_south := 1.0
var tower_attack_speed_west := 1.0

# Upgrade UI
var upgrade_menu = null

func _ready():
	upgrade_menu = preload("res://Scenes/Menu/upgrade_menu.tscn").instantiate()
	call_deferred("_add_upgrade_menu")

func _add_upgrade_menu():
	get_tree().root.add_child(upgrade_menu)
	upgrade_menu.visible = false

func add_xp(amount: int):
	current_exp += amount
	emit_signal("exp_updated", current_exp, exp_to_next_level)
	print("Gained EXP: %d / %.1f" % [current_exp, exp_to_next_level])
	
	while current_exp >= exp_to_next_level:
		current_exp -= exp_to_next_level
		level_up()

func level_up():
	current_level += 1
	exp_to_next_level *= exp_growth_factor
	emit_signal("exp_updated", current_exp, exp_to_next_level)
	print("LEVEL UP! Now at level %d. XP needed for next level: %.1f" % [current_level, exp_to_next_level])
	pause_game_for_upgrade()

func pause_game_for_upgrade():
	get_tree().paused = true
	if upgrade_menu:
		upgrade_menu.refresh_options()
		upgrade_menu.visible = true

func reset_game_values():
	# Experience
	current_level = 1
	current_exp = 0.0
	exp_to_next_level = 5.0
	exp_growth_factor = 1.3
	#Tower Attack
	tower_attack_north = 1
	tower_attack_east  = 1
	tower_attack_south  = 1
	tower_attack_west = 1
	# Attack speed (lower = faster shooting)
	tower_attack_speed_north = 1.0	
	tower_attack_speed_east = 1.0
	tower_attack_speed_south = 1.0
	tower_attack_speed_west = 1.0
