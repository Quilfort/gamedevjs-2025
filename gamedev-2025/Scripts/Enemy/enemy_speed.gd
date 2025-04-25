extends RigidBody2D

signal reached_goal

# EXP
@export var exp_scene: PackedScene
@export var exp_amount := 1

#Health
@export var max_health := 2
@onready var health_bar = %HealthBar
var current_health := max_health

#Movement
@export var movement_speed = 40.0
var target_position: Vector2

#Animation
@onready var sprite = $AnimatedSprite2D

func _ready():
	set_health()

func set_health():
	current_health = max_health
	health_bar.max_value = max_health
	health_bar.value = current_health

# Movement
func _physics_process(_delta):
	if target_position != null:
		var direction = (target_position - global_position).normalized()
		linear_velocity = direction * movement_speed
		update_animation(direction)

		# Check if reached target
		if global_position.distance_to(target_position) < 10:
			linear_velocity = Vector2.ZERO
			emit_signal("reached_goal")
			queue_free()

#Animation
func update_animation(direction: Vector2):
	if direction.length() == 0:
		sprite.play("default")
		return

	# Prioritize vertical movement if it's stronger
	if abs(direction.y) > abs(direction.x):
		if direction.y > 0:
			sprite.play("down")
		else:
			sprite.play("up")
	else:
		if direction.x > 0:
			sprite.play("right")
		else:
			sprite.play("left")

func hit(damage: int):
	current_health -= damage
	health_bar.value = current_health
	if current_health <= 0:
		die()

func die():
	for i in exp_amount:
		var exp_item = exp_scene.instantiate()
		exp_item.global_position = global_position
		get_parent().add_child(exp_item)

	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
