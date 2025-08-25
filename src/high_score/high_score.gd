@tool
extends Label

@export var score: int:
	get:
		return _score
	set(new_score):
		_score = new_score
		if not score:
			text = ""
		text = str(_score)

var _score: int = 0

func _ready() -> void:
	EventBus.died_with_score.connect(_update)

func _update(new_score: int) -> void:
	if new_score <= _score:
		return
	score = new_score
