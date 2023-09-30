class_name Mob
extends CharacterBody3D

const GROUP = "mobs"

signal squashed 


func _init():
	add_to_group(GROUP)


func _physics_process(_delta):
	move_and_slide()


func squash():
	squashed.emit()
	queue_free()


func _screen_exited():
	queue_free()
