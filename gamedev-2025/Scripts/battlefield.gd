extends Node2D


#Audio
@onready var background_music: AudioStreamPlayer = $Audio/BackgroundMusic
@onready var game_over_music: AudioStreamPlayer = $Audio/GameOverMusic

#Enemy Instances
@export var enemy_scene: PackedScene
@export var enemy_speed_scene: PackedScene
@export var enemy_speed_strong: PackedScene

#GameTimer
@onready var game_timer_label: RichTextLabel = $GameTimer/GameTimerLabel


var active_enemies_north: Array = []
var active_enemies_east: Array = []
var active_enemies_south: Array = []
var active_enemies_west: Array = []

func _ready() -> void:
	new_game()

func _process(delta: float) -> void:
	if not get_tree().paused:
		GameManager.add_time(delta)
		update_timer_display()

func game_over():
	%NorthSpawnTimer.start()
	%SouthSpawnTimer.start()
	%EastSpawnTimer.start()
	%WestSpawnTimer.start()

func new_game():
	GameManager.reset_game_timer()
	GameManager.reset_game_values()
	%StartTimer.start()


func _on_start_timer_timeout() -> void:
	set_spawn_timers()
	%NorthSpawnTimer.start()
	%SouthSpawnTimer.start()
	%EastSpawnTimer.start()
	%WestSpawnTimer.start()


func _on_north_spawn_timer_timeout() -> void:
	var enemy_to_spawn = choose_enemy()
	var enemy_location = %NorthSpawnLocation
	enemy_location.progress_ratio = randf()
	enemy_to_spawn.position = enemy_location.position

	var marker = %CentralCube/NorthSide/Marker
	enemy_to_spawn.target_position = marker.global_position

	enemy_to_spawn.connect("reached_goal", Callable(self, "_on_enemy_reached_goal"))
	add_child(enemy_to_spawn)
	active_enemies_north.append(enemy_to_spawn)
	enemy_to_spawn.connect("tree_exited", Callable(self, "_on_enemy_exited").bind(enemy_to_spawn))


func _on_south_spawn_timer_timeout() -> void:
	var enemy_to_spawn = choose_enemy()
	var enemy_location = %SouthSpawnLocation
	enemy_location.progress_ratio = randf()
	enemy_to_spawn.position = enemy_location.position

	var marker = %CentralCube/SouthSide/Marker
	enemy_to_spawn.target_position = marker.global_position

	enemy_to_spawn.connect("reached_goal", Callable(self, "_on_enemy_reached_goal"))
	add_child(enemy_to_spawn)
	active_enemies_south.append(enemy_to_spawn)
	enemy_to_spawn.connect("tree_exited", Callable(self, "_on_enemy_exited").bind(enemy_to_spawn))


func _on_west_spawn_timer_timeout() -> void:
	var enemy_to_spawn = choose_enemy()
	var enemy_location = %WestSpawnLocation
	enemy_location.progress_ratio = randf()
	enemy_to_spawn.position = enemy_location.position

	var marker = %CentralCube/WestSide/Marker
	enemy_to_spawn.target_position = marker.global_position

	enemy_to_spawn.connect("reached_goal", Callable(self, "_on_enemy_reached_goal"))
	add_child(enemy_to_spawn)
	active_enemies_west.append(enemy_to_spawn)
	enemy_to_spawn.connect("tree_exited", Callable(self, "_on_enemy_exited").bind(enemy_to_spawn))


func _on_east_spawn_timer_timeout() -> void:
	var enemy_to_spawn = choose_enemy()
	var enemy_location = %EastSpawnLocation
	enemy_location.progress_ratio = randf()
	enemy_to_spawn.position = enemy_location.position

	var marker = %CentralCube/EastSide/Marker
	enemy_to_spawn.target_position = marker.global_position

	enemy_to_spawn.connect("reached_goal", Callable(self, "_on_enemy_reached_goal"))
	add_child(enemy_to_spawn)
	active_enemies_east.append(enemy_to_spawn)
	enemy_to_spawn.connect("tree_exited", Callable(self, "_on_enemy_exited").bind(enemy_to_spawn))


func choose_enemy() -> Node2D:
	var time = GameManager.get_elapsed_time()

	if time < 60:
		# Early: Only basic enemies
		return enemy_scene.instantiate()
	elif time < 120:
		# Mid: 50% normal, 50% speed
		if randf() < 0.5:
			return enemy_speed_scene.instantiate()
		else:
			return enemy_scene.instantiate()
	elif time < 210:
		# Mid: 35% normal, 40% speed, 25% strong
		var roll = randf()
		if roll < 0.35:
			return enemy_scene.instantiate()  
		elif roll < 0.75:
			return enemy_speed_scene.instantiate() 
		else:
			return enemy_speed_strong.instantiate() 
	else:
		# Late: 20% normal, 40% speed, 40% strong
		var roll = randf()
		if roll < 0.2:
			return enemy_scene.instantiate() 
		elif roll < 0.6:
			return enemy_speed_scene.instantiate()  
		else:
			return enemy_speed_strong.instantiate()


func _on_enemy_exited(enemy):
	active_enemies_north.erase(enemy)
	active_enemies_east.erase(enemy)
	active_enemies_south.erase(enemy)
	active_enemies_west.erase(enemy)

func update_enemy_spawn_timers():
	set_spawn_timers()

func set_spawn_timers():
	%NorthSpawnTimer.wait_time = GameManager.enemy_spawn_speed_north
	%SouthSpawnTimer.wait_time = GameManager.enemy_spawn_speed_south
	%EastSpawnTimer.wait_time = GameManager.enemy_spawn_speed_east
	%WestSpawnTimer.wait_time = GameManager.enemy_spawn_speed_west


# Game Over
func _on_enemy_reached_goal():
	%NorthSpawnTimer.stop()
	%SouthSpawnTimer.stop()
	%EastSpawnTimer.stop()
	%WestSpawnTimer.stop()

	for group in [active_enemies_north, active_enemies_south, active_enemies_east, active_enemies_west]:
		for e in group:
			if is_instance_valid(e):
				e.queue_free()
	game_over_music.play()
	await game_over_music.finished
	get_tree().change_scene_to_file("res://Scenes/Menu/restart_menu.tscn")
	
# Update Game Timer
func update_timer_display():
	var seconds = int(GameManager.get_elapsed_time()) % 60
	var minutes = int(GameManager.get_elapsed_time()) / 60
	game_timer_label.text = "%02d:%02d" % [minutes, seconds]
