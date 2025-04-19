#extends "res://Scripts/Tower/towers.gd"

extends Node2D



# Shooting
var bullet = preload("res://Scenes/Tower/bullet.tscn")
var bullet_damage = 5
@onready var shoot_timer: Timer = $ShooterTimer



# Enum For Directions
enum FacingDirection { EAST, NORTH, WEST, SOUTH }
const DIRECTION_ANGLES := {
	FacingDirection.EAST: 0.0,
	FacingDirection.NORTH: 270.0,
	FacingDirection.WEST: 180.0,
	FacingDirection.SOUTH: 90.0
}

@onready var battlefield = get_tree().get_root().get_node("Battlefield")

#NorthMarker is now hardcoded, should be able to get all the markers
@onready var marker = get_parent().get_node("Marker")
var current_target: Node2D = null

# Exported variables
@export var facing_direction: FacingDirection = FacingDirection.SOUTH:
	set(value):
		facing_direction = value
		update_facing()

@export var fov_angle: float = 135.0
@export var fov_range: float = 300.0

# Node references
@onready var fov_area := $Base/FOVArea
@onready var fov_polygon := $Base/FOVArea/CollisionPolygon2D

func _ready() -> void:
	update_facing()
	generate_fov_shape()
	shoot_timer.timeout.connect(_on_ShootTimer_timeout)

## Update POV
func update_facing() -> void:
	var angle: float = DIRECTION_ANGLES[facing_direction]
	fov_area.rotation_degrees = angle

func generate_fov_shape():
	var points: Array[Vector2] = []
	var half_angle = deg_to_rad(fov_angle / 2.0)
	var segments = 20

	points.append(Vector2.ZERO) # center point

	for i in range(segments + 1):
		var angle = -half_angle + i * ((half_angle * 2.0) / segments)
		var x = cos(angle) * fov_range
		var y = sin(angle) * fov_range
		points.append(Vector2(x, y))

	fov_polygon.polygon = points

func is_in_fov(enemy: Node2D) -> bool:
	var fov_origin = $Base/FOVArea.global_position
	var to_enemy = enemy.global_position - fov_origin
	
	# Debug distance
	var distance = to_enemy.length()
	
	if distance > fov_range:
		return false
	
	var facing_vector = Vector2.RIGHT.rotated(fov_area.global_rotation)
	
	# Normalize the vector to the enemy
	var to_enemy_normalized = to_enemy.normalized()
	
	# Calculate angle (make sure we're using the right method)
	var angle_to_enemy = facing_vector.angle_to(to_enemy_normalized)
	
	return abs(rad_to_deg(angle_to_enemy)) <= fov_angle / 2.0


func find_target(enemies: Array, marker_pos: Vector2) -> Node2D:
	var candidates = []
	for enemy in enemies:
		if is_in_fov(enemy):
			candidates.append(enemy)
	if candidates.is_empty():
		return null
	candidates.sort_custom(func(a, b): return a.global_position.distance_to(marker_pos) < b.global_position.distance_to(marker_pos))
	return candidates[0]

func _process(delta):
	if battlefield == null or marker == null:
		return
	var enemies = battlefield.active_enemies
	var closest = find_target(enemies, marker.global_position)
	current_target = closest
	turn()

func turn():
	if current_target != null:
		$Base/Turret.look_at(current_target.global_position)
	
func _on_ShootTimer_timeout():
	if current_target != null and is_instance_valid(current_target):
		shoot()
		
func shoot():
	if current_target != null and is_instance_valid(current_target):
		var bullet_instance = bullet.instantiate()
		bullet_instance.global_position = $Base/Turret.global_position
		bullet_instance.target = current_target
		bullet_instance.damage = bullet_damage
		get_tree().current_scene.add_child(bullet_instance)
