extends Area2D

signal hit

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@export var SPEED: float = 400.0
var screen_size = Vector2.ZERO

func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide()

func _process(delta: float) -> void:
	var direction := Vector2.ZERO

	if Input.is_action_pressed("right"):
		direction.x += 1
	if Input.is_action_pressed("left"):
		direction.x -= 1
	if Input.is_action_pressed("down"):
		direction.y += 1
	if Input.is_action_pressed("up"):
		direction.y -= 1

	if direction.length() > 0:
		direction = direction.normalized()
		animated_sprite_2d.play()
	else:
		animated_sprite_2d.stop()

	position += direction * SPEED * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	if direction.x != 0:
		animated_sprite_2d.play("right")
		animated_sprite_2d.flip_h = direction.x < 0
		animated_sprite_2d.flip_v = false
	elif direction.y != 0:
		animated_sprite_2d.play("up")
		animated_sprite_2d.flip_v = direction.y > 0
		animated_sprite_2d.flip_h = false
	else:
		animated_sprite_2d.stop()


func start(new_position):
	position = new_position
	show()
	collision_shape_2d.disabled = false

func _on_body_entered(body: Node2D) -> void:
	hide()
	collision_shape_2d.set_deferred("disabled", true)
	emit_signal("hit")
