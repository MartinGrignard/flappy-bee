@tool
extends Label

const SAVE_PATH: String = "user://save.bin"

@export var score: int:
	get:
		return _score
	set(new_score):
		_score = new_score
		text = str(_score)

var _score: int = 0

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	_load()
	EventBus.died_with_score.connect(_update)

func _update(new_score: int) -> void:
	if new_score <= _score:
		return
	score = new_score
	_save()

func _load() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		score = 0
		return
	var save_file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if save_file == null:
		score = 0
		return
	score = save_file.get_64()
	save_file.close()

func _save() -> void:
	var save_file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if save_file == null:
		return
	save_file.store_64(_score)
	save_file.close()
