class_name Mob
extends CharacterBody3D

func _physics_process(_delta):
	move_and_slide()


func _screen_exited():
	queue_free()
