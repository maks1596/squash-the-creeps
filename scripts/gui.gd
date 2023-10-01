extends Control

const _SCORE_FORMAT = "Score: %d"

@onready var score_label = $ScoreLabel as Label

func _ready():
	Score.changed.connect(_on_score_changed)


func _on_score_changed(new_score: int):
	score_label.text = _SCORE_FORMAT % new_score
