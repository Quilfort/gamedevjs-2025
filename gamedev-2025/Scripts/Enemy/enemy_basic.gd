extends RigidBody2D

@export var exp_scene: PackedScene
@export var exp_amount := 1

#Movement
@export var movement_speed = 10.0
var target_position: Vector2

#Animation
@onready var sprite = $AnimatedSprite2D

#Movement
func _physics_process(delta):
	if target_position != null:
		var direction = (target_position - global_position).normalized()
		linear_velocity = direction * movement_speed
		update_animation(direction)

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

func die():
	for i in exp_amount:
		var exp_item = exp_scene.instantiate()
		exp_item.global_position = global_position
		get_parent().add_child(exp_item)

	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
