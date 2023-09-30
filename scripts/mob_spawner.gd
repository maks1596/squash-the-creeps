@tool
extends Node

const MOB_DIRECTION_DIVIATION = PI / 4

var _player_position: Vector3:
	get: return player.position

@export var spawn_parent: Node3D
@export var player: Node3D
@export var mobs: Array[PackedScene] = []
@export_range(0, 1, 1, "or_greater", "suffix:m/s") var mob_min_speed = 10
@export_range(1, 1, 1, "or_greater", "suffix:m/s") var mob_max_speed = 18

func start():
	pass


func stop():
	pass


func _spawn_mob():
	var mobScene = mobs.pick_random() as PackedScene
	var mob = mobScene.instantiate() as Mob
	_generate_direction(mob, _player_position)
	_generate_speed(mob)
	spawn_parent.add_child(mob)


func _generate_speed(mob: Mob):
	var speed = randi_range(mob_min_speed, mob_max_speed)
	var speedVector = Vector3.FORWARD * speed
	mob.velocity = speedVector.rotated(Vector3.UP, mob.rotation.y)


func _generate_direction(mob: Mob, target_position: Vector3):
	mob.look_at(target_position)
	var angle = randf_range(-MOB_DIRECTION_DIVIATION, MOB_DIRECTION_DIVIATION)
	mob.rotate_y(angle)


func _get_configuration_warnings():
	var warnings = []
	
	if not spawn_parent:
		warnings += "`Spawn parent` should be initialized"
	
	if not player:
		warnings += "`player` should be initialized"
		
	if mob_max_speed < mob_min_speed:
		warnings += "`Mob max speed` should be greater or equal `Mom min speed`"
	
	if not mobs:
		warnings += "`Mobs` array should be initialized"
	elif mobs.is_empty():
		warnings += "`Mobs` array should not be empty"
	elif mobs.any(func (scene): return !(scene is Mob)):
		warnings += "All `Mobs` should be derived from `Mob` class"
	
	return warnings
