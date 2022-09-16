extends KinematicBody2D

export var speed := 100.0
export var gravity := 1000.0

onready var _animation = $AnimatedSprite
onready var _collisionShape = $CollisionShape2D
onready var _floorChecker = $FloorChecker

var current_direction := 1
var velocity := Vector2.ZERO

func _ready() -> void:
	if(current_direction == 1):
		_animation.flip_h = true
	_floorChecker.position.x = _collisionShape.shape.get_extents().x * current_direction

func _physics_process(delta: float) -> void:
	if(is_on_wall() or not _floorChecker.is_colliding()):
		current_direction = current_direction * -1
		_animation.flip_h = not _animation.flip_h
		_floorChecker.position.x = _collisionShape.shape.get_extents().x * current_direction

	velocity.x = current_direction * speed
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)

func _on_SpikeArea_body_entered(body: Node) -> void:
	if(body.name == 'Player' and body.has_method('hit_by_enemy')):
		body.call('hit_by_enemy')
