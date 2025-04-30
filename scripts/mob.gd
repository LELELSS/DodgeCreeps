extends RigidBody2D

@export var min_speed = 150.00
@export var max_speed = 300.00
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	randomize()
	var sprite = $AnimatedSprite2D  # Adjust this path as needed
	var mob_types = sprite.sprite_frames.get_animation_names()
	sprite.animation = mob_types[randi() % mob_types.size()]
	sprite.play()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
