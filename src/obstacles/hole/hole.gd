@tool
extends Area2D

@export_range(64, 512) var size: int:
	get:
		return _size
	set(new_size):
		_size = new_size
		if not _collider:
			return
		_collider.shape.a.y = -_size / 2
		_collider.shape.b.y = _size / 2

@onready var _collider: CollisionShape2D = get_node("Collider")
@onready var _audio_player: AudioStreamPlayer2D = get_node("AudioPlayer")

var _size: int = 256

func _ready() -> void:
	connect("body_entered", _on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
	_audio_player.play()
	EventBus.scored.emit()
