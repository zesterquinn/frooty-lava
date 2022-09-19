extends KinematicBody2D

export var speed := 150.0
export var gravity := 1000.0
export var jump_strength := 300.0

onready var _animated_sprite = $AnimatedSprite
onready var _collision = $CollisionShape2D

var velocity := Vector2.ZERO
var is_hit := false

func _process(_delta: float) -> void:
	play_animation()

func _physics_process(delta: float) -> void:
	var horizontal_direction := Input.get_axis("move_left", "move_right")

	velocity.x = horizontal_direction * speed
	velocity.y += gravity * delta

	var is_jumping := is_on_floor() and Input.is_action_just_pressed("jump")

	if is_jumping:
		velocity.y = -jump_strength

	if(!is_hit):
		velocity = move_and_slide(velocity, Vector2.UP)

func hit_by_enemy() -> void:
	if(is_hit):
		return

	var knockback := 1000.0

	is_hit = true

	if(_animated_sprite.flip_h == false):
		knockback = -knockback

	velocity.x =  lerp(velocity.x, knockback, 1)
	velocity.y = lerp(velocity.y, -900.0, .6)
	velocity = move_and_slide(velocity, Vector2.UP)

	yield(get_tree().create_timer(0.2), "timeout")

	is_hit = false

func play_animation() -> void:
	if(is_hit):
		_animated_sprite.play("hit")
		return

	if(velocity.x != 0):
		_animated_sprite.flip_h = velocity.x < 0
		_animated_sprite.play("run")
	else:
		_animated_sprite.play("idle")

	if(velocity.y != 0):
		_animated_sprite.play("jump")

	if(velocity.y > 0):
		_animated_sprite.play("fall")
