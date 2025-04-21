extends CharacterBody2D

@export var speed: float = 400.0
@export var damage: int = 1

var target: Node2D = null

func _ready():
	if target:
		look_at(target.global_position)

func _physics_process(delta):
	if target and is_instance_valid(target):
		var direction = (target.global_position - global_position).normalized()
		velocity = direction * speed
		var collision = move_and_collide(velocity * delta)
		if collision:
			var body = collision.get_collider()
			if body.has_method("hit"):
				body.hit(damage)
				queue_free()
	else:
		queue_free()
