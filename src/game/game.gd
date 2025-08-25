class_name Game
extends Node2D

signal cleared()

@export var score: Score

func on_player_scored() -> void:
	print("Player scored a point!")
	if score:
		score.increment()

func on_player_died() -> void:
	print("Player died!")
	if score:
		score.reset()
	cleared.emit()
