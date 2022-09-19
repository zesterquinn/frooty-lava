extends KinematicBody2D

export var speed := 100.0
export var gravity := 1000.0
export var _shootingRangeLength = 150

onready var _animation = $AnimatedSprite
onready var _collisionShape = $CollisionShape2D
onready var _floorChecker = $FloorChecker
onready var _shootingRange = $ShootingRange
onready var _bulletPosition = $BulletPosition

const bulletPath = preload("res://enemies/trunk/Bullet.tscn")

var current_direction := 1
var velocity := Vector2.ZERO
var can_fire := true

func _ready() -> void:
	_shootingRange.cast_to.x = -_shootingRangeLength if not _animation.flip_h else _shootingRangeLength
	if(current_direction == 1):
		_animation.flip_h = true

func _physics_process(delta: float) -> void:
	if(is_on_wall() or not _floorChecker.is_colliding()):
		current_direction = current_direction * -1
		_animation.flip_h = not _animation.flip_h
		_floorChecker.position.x = _collisionShape.shape.get_extents().x * current_direction
		_shootingRange.cast_to.x = -_shootingRangeLength if not _animation.flip_h else _shootingRangeLength

	if(_shootingRange.is_colliding()):
		velocity.x = 0
		if(can_fire):
			_animation.play("attack")
			shoot_bullet()
	else:
		velocity.x = current_direction * speed
		_animation.play("run")

	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)

func _on_SpikeArea_body_entered(body: Node) -> void:
	if(body.name == 'Player' and body.has_method('hit_by_enemy')):
		body.call('hit_by_enemy')

func shoot_bullet():
	var bullet = bulletPath.instance()

	bullet.get_current_direction(current_direction)
	bullet.position = _bulletPosition.global_position
	get_parent().add_child(bullet)
	can_fire = false
	yield(get_tree().create_timer(.55), "timeout")
	can_fire = true

