@tool
extends Node2D

const Obstacle := preload("res://obstacles/obstacles_pair/obstacles_pair.tscn")

@export_range(0, 1024) var speed: float:
	get:
		return _speed
	set(new_speed):
		_speed = new_speed

@export_range(0, 1024) var spacing: float:
	get:
		return _spacing
	set(new_spacing):
		_spacing = new_spacing

@export_range(64, 512) var hole_size: int:
	get:
		return _hole_size
	set(new_hole_size):
		_hole_size = new_hole_size

var cooldown_time: float:
	get:
		return _spacing / _speed

@onready var _spawn_cooldown: Timer = get_node("SpawnCooldown")

var _speed: float = 32
var _spacing: float = 256
var _spread: float = 0.5
var _hole_size: int = 256
var _rng := RandomNumberGenerator.new()
var _last_position: float = 0.5

func _ready() -> void:
	_spawn_cooldown.connect("timeout", spawn)
	spawn()

func spawn() -> void:
	var parent = get_parent()
	if not parent:
		return
	var obstacle := Obstacle.instantiate()
	obstacle.speed = _speed
	obstacle.hole_size = _hole_size
	var min_position: float = max(_last_position - _spread / 2, 0.0)
	var max_position: float = min(_last_position + _spread /  2, 1.0)
	obstacle.hole_position = min_position + (max_position - min_position) * _rng.randf()
	EventBus.died.connect(obstacle.queue_free)
	add_child(obstacle)
	if Engine.is_editor_hint():
		return
	_spawn_cooldown.start(cooldown_time)
