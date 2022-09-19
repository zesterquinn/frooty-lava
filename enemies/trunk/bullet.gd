extends KinematicBody2D

onready var _animation = $AnimatedSprite

var velocity := Vector2.ZERO
var speed := 150
var bullet_direction := -1

func _physics_process(delta: float) -> void:
	if(is_on_wall()):
		queue_free()

	velocity.x = bullet_direction * speed
	velocity = move_and_slide(velocity, Vector2.UP)

	_animation.flip_h = bullet_direction == 1

func get_current_direction(direction):
	bullet_direction = direction
