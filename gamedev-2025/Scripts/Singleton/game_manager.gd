extends Node

# Experience
signal exp_updated(current_exp, exp_to_next)
var current_level := 1
var current_exp := 0
var exp_to_next_level := 15.0
var exp_growth_factor := 1.3

#Tower Attack
var tower_attack_north: int = 1
var tower_attack_east:int  = 1
var tower_attack_south:int  = 1
var tower_attack_west:int = 1

func add_xp(amount: int):
	current_exp += amount
	emit_signal("exp_updated", current_exp, exp_to_next_level)
	print("Gained EXP: %d / %d" % [current_exp, exp_to_next_level])
	
	while current_exp >= exp_to_next_level:
		current_exp -= exp_to_next_level
		level_up()

func level_up():
	current_level += 1
	exp_to_next_level *= exp_growth_factor
	emit_signal("exp_updated", current_exp, exp_to_next_level)
	print("LEVEL UP! Now at level %d. XP needed for next level: %.1f" % [current_level, exp_to_next_level])
