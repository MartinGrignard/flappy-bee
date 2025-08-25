@tool
extends AnimatableBody2D

@export_range(64, 512) var hole_size: int:
	get:
		return _hole_size
	set(new_hole_size):
		_hole_size = new_hole_size
		_refresh()

@export_range(0, 1) var hole_position: float:
	get:
		return _hole_position
	set(new_hole_position):
		_hole_position = new_hole_position
		_refresh()

@export_range(0, 1024) var speed: float:
	get:
		return _speed
	set(new_speed):
		_speed = new_speed

@onready var _top: CollisionShape2D = get_node("Top")
@onready var _hole: Area2D = get_node("Hole")
@onready var _bottom: CollisionShape2D = get_node("Bottom")

var _hole_size: int = 256
var _hole_position: float = 0.5
var _speed: float = 32

func _ready() -> void:
	_refresh()

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	var collision_info := move_and_collide(Vector2.LEFT * _speed * delta)
	if collision_info:
		_on_out_of_bound()

func _refresh() -> void:
	if not _hole or not _top or not _bottom:
		return
	var _screen_size: int = ProjectSettings.get_setting("display/window/size/viewport_height")
	var hole_position: int = round(_hole_size / 2 + (_screen_size - _hole_size) * _hole_position)
	_hole.position.y = hole_position
	_hole.size = _hole_size
	_top.position.y = hole_position - (_hole_size + _top.shape.height) / 2
	_bottom.position.y = hole_position + (_hole_size + _bottom.shape.height) / 2

func _on_out_of_bound() -> void:
	queue_free()
