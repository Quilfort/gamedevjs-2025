extends Node2D

enum FacingDirection { EAST, NORTH, WEST, SOUTH }

# Angle map for the enum
const DIRECTION_ANGLES := {
	FacingDirection.EAST: 0.0,
	FacingDirection.NORTH: 270.0,
	FacingDirection.WEST: 180.0,
	FacingDirection.SOUTH: 90.0
}

# Exported variables
@export var facing_direction: FacingDirection = FacingDirection.SOUTH:
	set(value):
		facing_direction = value
		_update_facing()

@export var fov_angle: float = 90.0
@export var fov_range: float = 200.0

# Node references
@onready var fov_area := $Base/FOVArea
@onready var fov_polygon := $Base/FOVArea/CollisionPolygon2D

func _ready() -> void:
	_update_facing()
	generate_fov_shape()

func _update_facing() -> void:
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

func _physics_process(delta: float) -> void:
	turn()

func turn():
	var enemy_position = get_global_mouse_position()
