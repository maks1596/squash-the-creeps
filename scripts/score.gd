extends Node

signal changed(score: int)

var _score := 0:
	set(value):
		_score = value
		changed.emit(value)


func get_score() -> int: return _score


func increase(): _score += 1


func reset(): _score = 0
