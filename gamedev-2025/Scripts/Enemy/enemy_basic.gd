extends RigidBody2D

@export var movement_speed = 20.0

func _ready():
	pass

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
