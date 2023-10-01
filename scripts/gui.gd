extends Control

const _SCORE_FORMAT = "Score: %d"

signal retry_button_pressed

@onready var _score_label = $ScoreLabel as Label
@onready var _retry_fade = $RetryFade as Control

func _ready():
	_on_score_changed(Score.get_score())
	Score.changed.connect(_on_score_changed)
	
	_retry_fade.hide()
	set_process_unhandled_input(false)


func _unhandled_input(event):
	if event.is_action_pressed("retry"):
		retry_button_pressed.emit()


func show_retry_fade():
	_retry_fade.show()
	set_process_unhandled_input(true)


func _on_score_changed(new_score: int):
	_score_label.text = _SCORE_FORMAT % new_score
