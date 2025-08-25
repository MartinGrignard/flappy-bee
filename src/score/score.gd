@tool
class_name Score
extends Label

@export var score: int:
	get:
		return _score
	set(new_score):
		_score = new_score
		text = str(_score)

@onready var _animation_player: AnimationPlayer = get_node("AnimationPlayer")

var _score: int = 0

func _ready() -> void:
	reset()

func increment() -> void:
	_animation_player.play("score")
	score += 1

func reset() -> void:
	score = 0
