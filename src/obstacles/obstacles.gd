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

@export_range(0, 1.0) var spread: float:
	get:
		return _spread
	set(new_spread):
		_spread = new_spread

var cooldown_time: float:
	get:
		return _spacing / _speed

@onready var _spawn_cooldown: Timer = get_node("SpawnCooldown")

var _speed: float = 32
var _spacing: float = 256
var _spread: float = 0.5
var _hole_size: int = 256
var _spread_multiplier: float = 1.0
var _hole_size_multiplier: float = 1.0
var _rng := RandomNumberGenerator.new()
var _last_position: float = 0.5
var _obstacles: Array[Node2D] = []

func _ready() -> void:
	_spawn_cooldown.timeout.connect(spawn)
	EventBus.died.connect(_reset)
	EventBus.levelled_up.connect(_increase_difficulty)
	spawn()

func spawn() -> void:
	var obstacle := Obstacle.instantiate()
	obstacle.speed = _speed
	obstacle.hole_size = _hole_size * _hole_size_multiplier
	var min_position: float = max(_last_position - _spread * _spread_multiplier / 2, 0.0)
	var max_position: float = min(_last_position + _spread * _spread_multiplier /  2, 1.0)
	obstacle.hole_position = min_position + (max_position - min_position) * _rng.randf()
	_obstacles.append(obstacle)
	obstacle.removed.connect(_pop_obstacle)
	add_child(obstacle)
	if Engine.is_editor_hint():
		return
	_spawn_cooldown.start(cooldown_time)

func _pop_obstacle() -> void:
	_obstacles.pop_front()

func _increase_difficulty() -> void:
	_hole_size_multiplier *= 0.95
	_spread_multiplier *= 1.1
	for obstacle in _obstacles:
		obstacle.speed = _speed

func _reset() -> void:
	_hole_size_multiplier = 1.0
	_spread_multiplier = 1.0
