extends Node

func _on_gui_retry_button_pressed():
	get_tree().reload_current_scene()
	Score.reset()
