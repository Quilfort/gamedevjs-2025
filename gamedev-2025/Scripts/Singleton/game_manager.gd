extends Node

# Game Timer
var elapsed_time := 0.0

# Experience
signal exp_updated(current_exp, exp_to_next)
var current_level := 1
var current_exp := 0.0
var exp_to_next_level := 10.0
var exp_growth_factor := 1.3

#Tower Attack
var tower_attack_init: int = 0.01
var tower_attack_north: int = tower_attack_init
var tower_attack_east:int  = tower_attack_init
var tower_attack_south:int  = tower_attack_init
var tower_attack_west:int = tower_attack_init

# Attack speed (lower = faster shooting)
var tower_attack_speed_init := 1.0
var tower_attack_speed_north := tower_attack_speed_init
var tower_attack_speed_east := tower_attack_speed_init
var tower_attack_speed_south := tower_attack_speed_init
var tower_attack_speed_west := tower_attack_speed_init

# Enemy / Computer
const ENEMY_SPEED_UPGRADE_MULTIPLIER := 0.9 
var enemy_spawn_speed_init := 5.0
var enemy_spawn_speed_north := enemy_spawn_speed_init 
var enemy_spawn_speed_east := enemy_spawn_speed_init 
var enemy_spawn_speed_south := enemy_spawn_speed_init 
var enemy_spawn_speed_west := enemy_spawn_speed_init 

# Enemy Spawn Weigths
var enemy_upgrade_counts := {
	"north": 0,
	"east": 0,
	"south": 0,
	"west": 0
}

# Upgrade UI
var upgrade_menu = null

func _ready():
	upgrade_menu = preload("res://Scenes/Menu/upgrade_menu.tscn").instantiate()
	call_deferred("_add_upgrade_menu")

func _add_upgrade_menu():
	get_tree().root.add_child(upgrade_menu)
	upgrade_menu.visible = false

func pause_game_for_upgrade():
	get_tree().paused = true
	if upgrade_menu:
		upgrade_menu.refresh_options()
		upgrade_menu.visible = true

func add_xp(amount: int):
	current_exp += amount
	play_power_up_sound()
	emit_signal("exp_updated", current_exp, exp_to_next_level)
	print("Gained EXP: %d / %.1f" % [current_exp, exp_to_next_level])
	
	while current_exp >= exp_to_next_level:
		current_exp -= exp_to_next_level
		level_up()

func level_up():
	current_level += 1
	exp_to_next_level *= exp_growth_factor
	level_up_enemy()
	emit_signal("exp_updated", current_exp, exp_to_next_level)
	print("LEVEL UP! Now at level %d. XP needed for next level: %.1f" % [current_level, exp_to_next_level])
	pause_game_for_upgrade()
	
func level_up_enemy():
	var chosen = get_weighted_direction()

	match chosen:
		"north":
			enemy_spawn_speed_north *= ENEMY_SPEED_UPGRADE_MULTIPLIER
		"south":
			enemy_spawn_speed_south *= ENEMY_SPEED_UPGRADE_MULTIPLIER
		"east":
			enemy_spawn_speed_east *= ENEMY_SPEED_UPGRADE_MULTIPLIER
		"west":
			enemy_spawn_speed_west *= ENEMY_SPEED_UPGRADE_MULTIPLIER

	print("Enemy leveled up on %s side!" % chosen)
	get_tree().get_root().get_node("Battlefield").update_enemy_spawn_timers()


func get_weighted_direction() -> String:
	var weights = {}
	var total_weight := 0.0

	for dir in enemy_upgrade_counts.keys():
		var weight = 1.0 / (1 + enemy_upgrade_counts[dir])
		weights[dir] = weight
		total_weight += weight

	# Normalize + Pick Random
	var rand_val = randf() * total_weight
	var cumulative = 0.0
	for dir in weights.keys():
		cumulative += weights[dir]
		if rand_val <= cumulative:
			return dir
	
	#Fallback
	return "north"

func play_power_up_sound():
	var player = AudioStreamPlayer.new()
	player.stream = load("res://Assets/Audio/Experience/PowerUp1.wav")
	player.bus = "Master" 
	player.volume_db = -10.0
	get_tree().root.add_child(player)
	player.play()
	await get_tree().create_timer(player.stream.get_length()).timeout
	player.queue_free()

# Game Timer
func add_time(delta: float):
	elapsed_time += delta

func get_elapsed_time() -> float:
	return elapsed_time

func reset_game_timer():
	elapsed_time = 0.0

func reset_game_values():
	#Game Timer
	reset_game_timer()
	
	# Experience
	current_level = 1
	current_exp = 0.0
	exp_to_next_level = 5.0
	exp_growth_factor = 1.3
	#Tower Attack
	tower_attack_north = tower_attack_init
	tower_attack_east  = tower_attack_init
	tower_attack_south  = tower_attack_init
	tower_attack_west = tower_attack_init
	# Attack speed (lower = faster shooting)
	tower_attack_speed_north = tower_attack_speed_init
	tower_attack_speed_east = tower_attack_speed_init
	tower_attack_speed_south = tower_attack_speed_init
	tower_attack_speed_west = tower_attack_speed_init
	# Enemy / Computer
	enemy_spawn_speed_north = enemy_spawn_speed_init 
	enemy_spawn_speed_east = enemy_spawn_speed_init 
	enemy_spawn_speed_south = enemy_spawn_speed_init 
	enemy_spawn_speed_west = enemy_spawn_speed_init
	# Enemy Upgrade Counts
	enemy_upgrade_counts = {
		"north": 0,
		"east": 0,
		"south": 0,
		"west": 0
	} 
