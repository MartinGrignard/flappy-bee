class_name Player
extends CharacterBody2D

signal scored()
signal died()

@export var gravity_acceleration: float
@export_group("Jump")
@export var jump_velocity: float
@export var jump_cooldown: float

@onready var _visual: AnimatedSprite2D = get_node("Visual")
@onready var _collider: CollisionShape2D = get_node("Collider")
@onready var _jump_audio_player: AudioStreamPlayer2D = get_node("JumpAudioPlayer")
@onready var _jump_cooldown_timer: Timer = get_node("JumpCooldown")
@onready var _die_audio_player: AudioStreamPlayer2D = get_node("DieAudioPlayer")
@onready var _animation_player: AnimationPlayer = get_node("AnimationPlayer")

var _is_blinking: bool = false
var _has_started: bool = false

func _ready() -> void:
	die()

func _physics_process(delta: float) -> void:
	var collision_info := _move(delta)
	if collision_info:
		die()

func _process(delta: float) -> void:
	var speed: float = min(velocity.y, 512) / 512
	var angle: float = speed * 60
	_visual.rotation_degrees = angle
	_collider.rotation_degrees = 90 + angle

func _move(delta: float) -> KinematicCollision2D:
	if _is_blinking:
		velocity = Vector2.ZERO
		return
	var acceleration = gravity_acceleration
	velocity.x = 0
	velocity.y += delta * acceleration
	if Input.is_action_just_pressed("Jump") and _jump_cooldown_timer.is_stopped():
		velocity.y -= jump_velocity
		_jump_audio_player.play()
		_visual.play("jump")
		_jump_cooldown_timer.start(jump_cooldown)
	move_and_slide()
	return get_last_slide_collision()

func die() -> void:
	EventBus.died.emit()
	if _has_started:
		_die_audio_player.play()
		_has_started = true
	position = Vector2(ProjectSettings.get_setting("display/window/size/viewport_width") / 2, ProjectSettings.get_setting("display/window/size/viewport_height") / 2)
	_is_blinking = true
	_animation_player.play("blink")
	await _animation_player.animation_finished
	_is_blinking = false
	
