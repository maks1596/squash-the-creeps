extends Node

signal changed(score: int)

var _score := 0

func get_score() -> int: return _score

func increase():
	var new_score = _score + 1
	_score = new_score
	changed.emit(new_score)
