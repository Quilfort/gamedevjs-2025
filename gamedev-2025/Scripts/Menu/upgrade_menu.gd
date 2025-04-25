extends CanvasLayer

const SPEED_UPGRADE_MULTIPLIER := 0.833
const MIN_ATTACK_SPEED := 0.1


#Sound
@onready var level_up: AudioStreamPlayer = $Audio/LevelUp

#Texture
var attack_texture = preload("res://UI/Buttons/Arrow.png")
var speed_texture = preload("res://UI/Buttons/Hourglass.png")

var power_ups :=[
	"attack",
	"speed",
]

var option_north = null
var option_east = null
var option_south = null
var option_west = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	refresh_options()

func refresh_options():
	%LabelHeader.text = "Choose a Power-up for Level %d" % GameManager.current_level
	set_option("north")
	set_option("east")
	set_option("south")
	set_option("west")
	set_button_text()
	set_button_texture()

func set_option(direction: String):
	var choice = power_ups.pick_random()
	match direction:
		"north":
			option_north = choice
		"east":
			option_east = choice
		"south":
			option_south = choice
		"west":
			option_west = choice

func set_button_text():
	%UpgradePowerNorthText.text = option_north
	%UpgradePowerEastText.text = option_east
	%UpgradePowerSouthText.text = option_south
	%UpgradePowerWestText.text = option_west

func set_button_texture():
	_set_texture(%UpgradePowerNorthImage, option_north)
	_set_texture(%UpgradePowerEastImage, option_east)
	_set_texture(%UpgradePowerSouthImage, option_south)
	_set_texture(%UpgradePowerWestImage, option_west)

func _set_texture(texture_rect: TextureRect, option: String) -> void:
	texture_rect.texture = attack_texture if option == "attack" else speed_texture
		
func _on_upgrade_power_north_pressed() -> void:
	apply_upgrade("north", option_north)
	finish_upgrade()

func _on_upgrade_power_east_pressed() -> void:
	apply_upgrade("east", option_east)
	finish_upgrade()

func _on_upgrade_power_south_pressed() -> void:
	apply_upgrade("south", option_south)
	finish_upgrade()

func _on_upgrade_power_west_pressed() -> void:
	print(option_west)
	apply_upgrade("west", option_west)
	finish_upgrade()

func apply_upgrade(direction: String, upgrade_type: String) -> void:
	match upgrade_type:
		"attack":
			match direction:
				"north": GameManager.tower_attack_north += 0.5
				"east": GameManager.tower_attack_east += 0.5
				"south": GameManager.tower_attack_south += 0.5
				"west": GameManager.tower_attack_west += 0.5
		"speed":
			match direction:
				"north": GameManager.tower_attack_speed_north = apply_speed_upgrade(GameManager.tower_attack_speed_north)
				"east": GameManager.tower_attack_speed_east = apply_speed_upgrade(GameManager.tower_attack_speed_east)
				"south": GameManager.tower_attack_speed_south = apply_speed_upgrade(GameManager.tower_attack_speed_south)
				"west": GameManager.tower_attack_speed_west = apply_speed_upgrade(GameManager.tower_attack_speed_west)

func apply_speed_upgrade(current_speed: float) -> float:
	return max(current_speed * SPEED_UPGRADE_MULTIPLIER, MIN_ATTACK_SPEED)

func play_upgrade_sound():
	level_up.play()
	


func finish_upgrade():
	#debug_log()
	reset_options()
	GameManager.upgrade_menu.visible = false
	get_tree().paused = false

func reset_options():
	option_north = null
	option_east = null
	option_south = null
	option_west = null

func debug_log():
	print("=== UPGRADE STATS ===")
	print("North: Attack =", GameManager.tower_attack_north, "Speed =", GameManager.tower_attack_speed_north)
	print("East:  Attack =", GameManager.tower_attack_east,  "Speed =", GameManager.tower_attack_speed_east)
	print("South: Attack =", GameManager.tower_attack_south, "Speed =", GameManager.tower_attack_speed_south)
	print("West:  Attack =", GameManager.tower_attack_west,  "Speed =", GameManager.tower_attack_speed_west)
	print("=====================")
	print("=== ENEMY UPGRADE STATS ===")
	print("North: Attack =", GameManager.enemy_spawn_speed_north)
	print("East:  Attack =", GameManager.enemy_spawn_speed_east)
	print("South: Attack =", GameManager.enemy_spawn_speed_south)
	print("West:  Attack =", GameManager.enemy_spawn_speed_west)
	print("=====================")
