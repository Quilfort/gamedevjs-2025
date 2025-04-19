extends Node2D

@export var enemy_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func game_over():
	%NorthSpawnTimer.start()

func new_game():
	%StartTimer.start()


func _on_start_timer_timeout() -> void:
	%NorthSpawnTimer.start()


func _on_north_spawn_timer_timeout() -> void:
	var enemy = enemy_scene.instantiate()
	var enemy_location = %NorthSpawnLocation
	enemy_location.progress_ratio = randf()
	enemy.position = enemy_location.position
	
	var marker = %CentralCube/NorthSide/NorthMarker
	enemy.target_position = marker.global_position
	
	
	add_child(enemy)
