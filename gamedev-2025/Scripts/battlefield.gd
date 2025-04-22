extends Node2D

@export var enemy_scene: PackedScene

var active_enemies_north: Array = []
var active_enemies_east: Array = []
var active_enemies_south: Array = []
var active_enemies_west: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func game_over():
	%NorthSpawnTimer.start()
	%SouthSpawnTimer.start()
	%EastSpawnTimer.start()
	%WestSpawnTimer.start()

func new_game():
	%StartTimer.start()


func _on_start_timer_timeout() -> void:
	%NorthSpawnTimer.start()
	%SouthSpawnTimer.start()
	%EastSpawnTimer.start()
	%WestSpawnTimer.start()


func _on_north_spawn_timer_timeout() -> void:
	var enemy = enemy_scene.instantiate()
	var enemy_location = %NorthSpawnLocation
	enemy_location.progress_ratio = randf()
	enemy.position = enemy_location.position
	
	var marker = %CentralCube/NorthSide/Marker
	enemy.target_position = marker.global_position
	
	add_child(enemy)
	active_enemies_north.append(enemy)
	enemy.connect("tree_exited", Callable(self, "_on_enemy_exited").bind(enemy))


func _on_south_spawn_timer_timeout() -> void:
	var enemy = enemy_scene.instantiate()
	var enemy_location = %SouthSpawnLocation
	enemy_location.progress_ratio = randf()
	enemy.position = enemy_location.position
	
	var marker = %CentralCube/SouthSide/Marker
	enemy.target_position = marker.global_position
	
	add_child(enemy)
	active_enemies_south.append(enemy)
	enemy.connect("tree_exited", Callable(self, "_on_enemy_exited").bind(enemy))

	
func _on_west_spawn_timer_timeout() -> void:
	var enemy = enemy_scene.instantiate()
	var enemy_location = %WestSpawnLocation
	enemy_location.progress_ratio = randf()
	enemy.position = enemy_location.position
	
	var marker = %CentralCube/WestSide/Marker
	enemy.target_position = marker.global_position
	
	add_child(enemy)
	active_enemies_west.append(enemy)
	enemy.connect("tree_exited", Callable(self, "_on_enemy_exited").bind(enemy))


func _on_east_spawn_timer_timeout() -> void:
	var enemy = enemy_scene.instantiate()
	var enemy_location = %EastSpawnLocation
	enemy_location.progress_ratio = randf()
	enemy.position = enemy_location.position
	
	var marker = %CentralCube/EastSide/Marker
	enemy.target_position = marker.global_position
	
	add_child(enemy)
	active_enemies_east.append(enemy)
	enemy.connect("tree_exited", Callable(self, "_on_enemy_exited").bind(enemy))


func _on_enemy_exited(enemy):
	active_enemies_north.erase(enemy)
	active_enemies_east.erase(enemy)
	active_enemies_south.erase(enemy)
	active_enemies_west.erase(enemy)
