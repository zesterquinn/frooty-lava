extends Area2D

onready var _animated_sprite = $AnimatedSprite
var current_animation := "idle"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_animated_sprite.play("idle")

func _on_fruit_pickup(body: Node) -> void:
	_animated_sprite.play("collected")

func _on_AnimatedSprite_frame_changed() -> void:
	current_animation = _animated_sprite.animation

func _on_AnimatedSprite_animation_finished() -> void:
	if(current_animation == "collected"):
		queue_free()
