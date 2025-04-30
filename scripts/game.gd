extends Node

@onready var score_timer: Timer = $ScoreTimer
@onready var hud: CanvasLayer = $HUD
@export var mob_scene: PackedScene
@onready var start_timer: Timer = $StartTimer
@onready var mob_timer: Timer = $MobTimer
@onready var player: Area2D = $Player
@onready var start_position: Marker2D = $StartPosition
@onready var music: AudioStreamPlayer2D = $Music
@onready var death_sound: AudioStreamPlayer2D = $DeathSound

var score = 0

func _ready() -> void:
	randomize()
	
func new_game() -> void:
	score = 0 
	hud.update_score(score)
	get_tree().call_group("mobs", "queue_free")
	player.start(start_position.position)
	start_timer.start()
	music.play()
	hud.show_message("Get Ready...")
	await start_timer.timeout
	score_timer.start()
	mob_timer.start()

func game_over() -> void:
	score_timer.stop()
	mob_timer.stop()
	hud.show_game_over() 
	music.stop()
	death_sound.play()

func _on_mob_timer_timeout() -> void:
	var mob_spawn_location = $MobPath/MobSpawn
	mob_spawn_location.progress_ratio = randf()


	var mob = mob_scene.instantiate()
	add_child(mob)

	mob.position = mob_spawn_location.position

	var direction = mob_spawn_location.rotation + PI / 2
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	var velocity = Vector2(randf_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = velocity.rotated(direction)


func _on_score_timer_timeout() -> void:
	score += 1
	hud.update_score(score)
	
