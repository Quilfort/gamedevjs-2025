extends Node2D

enum FacingDirection { EAST, NORTH, WEST, SOUTH }

func _ready() -> void:
	# Center the cube in the middle of the screen
	position = get_viewport_rect().size / 2
	set_tower_facing_directions()
	
func set_tower_facing_directions() -> void:
	$NorthSide/NorthTowerBasic.facing_direction = FacingDirection.NORTH
	$EastSide/EastTowerBasic.facing_direction = FacingDirection.EAST
	$WestSide/WestTowerBasic.facing_direction = FacingDirection.WEST
	$SouthSide/SouthTowerBasic.facing_direction = FacingDirection.SOUTH
