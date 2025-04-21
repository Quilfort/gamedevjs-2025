extends RigidBody2D

@export var delay_before_homing := 1.0
@export var speed := 200.0
@export var bounce_strength := 100.0

@onready var sprite = $AnimatedSprite2D
@onready var timer := $Timer

var target
var homing := false

func _ready():
	timer.wait_time = delay_before_homing
	timer.start()
	sprite.play("default")
	
	if not timer.timeout.is_connected(_on_timer_timeout):
		timer.timeout.connect(_on_timer_timeout)
	

func _on_timer_timeout():
	homing = true
	# Target can be also CentralCube
	target = get_viewport().get_visible_rect().size / 2

func _physics_process(delta):
	if homing and target:
		var direction = (target - global_position).normalized()
		position += direction * speed * delta
		rotation += 5 * delta
