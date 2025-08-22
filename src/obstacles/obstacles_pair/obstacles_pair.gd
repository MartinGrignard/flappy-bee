@tool
extends Node2D

const Obstacle := preload("res://obstacles/obstacle/obstacle.gd")

@export_range(0, 1) var height: float:
	get:
		return _height
	set(new_height):
		_height = new_height
		_refresh()
		
@export_range(64, 256) var hole_size: int:
	get:
		return _hole_size
	set(new_hole_size):
		_hole_size = new_hole_size
		_refresh()

@onready var _top: Obstacle = get_node("Top")
@onready var _hole: Area2D = get_node("Hole")
@onready var _collider: CollisionShape2D = get_node("Hole/Collider")
@onready var _bottom: Obstacle = get_node("Bottom")

var _height: float = 0.5
var _hole_size: int = 64

func _refresh() -> void:
	var min_height: int = 64 + _hole_size / 2
	var max_height: int = _bottom.position.y - 64 - _hole_size / 2
	var center_height = round(min_height + (max_height - min_height) * _height)
	# Refresh collider.
	_collider.shape.a.y = _hole_size / 2
	_collider.shape.b.y = -_hole_size / 2
	# Refresh hole.
	_hole.position.y = center_height
	# Refresh top.
	_top.height = center_height - _hole_size / 2
	# Refresh bottom.
	_bottom.height = _bottom.position.y - center_height - _hole_size / 2
