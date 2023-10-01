class_name Mob
extends CharacterBody3D

const GROUP = "mobs"

var _animation_speed := 1.0:
	set(value):
		_animation_speed = value
		if _animation_player: _animation_player.speed_scale = value

signal squashed 

@onready var _animation_player = $AnimationPlayer as AnimationPlayer


func _init():
	add_to_group(GROUP)


func _ready():
	_animation_speed = _animation_speed


func _physics_process(_delta):
	move_and_slide()


func set_animation_speed(speed: float):
	_animation_speed = speed


func squash():
	if is_queued_for_deletion(): return
	
	squashed.emit()
	queue_free()


func _screen_exited():
	queue_free()
