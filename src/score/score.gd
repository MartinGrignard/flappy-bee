@tool
class_name Score
extends Label

@export var score: int:
	get:
		return _score
	set(new_score):
		_score = new_score
		text = str(_score)

@export var level_up_score: int:
	get:
		return _level_up_score
	set(new_level_up_score):
		_level_up_score = new_level_up_score

@onready var _animation_player: AnimationPlayer = get_node("AnimationPlayer")

var _score: int = 0
var _level_up_score: int = 1

func _ready() -> void:
	reset()
	EventBus.scored.connect(increment)
	EventBus.died.connect(reset)

func increment() -> void:
	_animation_player.play("score")
	score += 1
	if score % _level_up_score == 0:
		EventBus.levelled_up.emit()

func reset() -> void:
	score = 0
