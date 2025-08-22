@tool
extends RigidBody2D

@export_range(16, 256) var height: int:
	get:
		return _height
	set(new_height):
		_height = new_height
		if _collider:
			_collider.shape.size.y = new_height - 2
			_collider.position.y = -(new_height - 2) / 2
		if _texture:
			_texture.size.y = _height * 2
			_texture.position.y = -_height * 2

@onready var _collider: CollisionShape2D = get_node("Collider")
@onready var _texture: NinePatchRect = get_node("Visual/Scaler/Texture")

var _height: float = 64
