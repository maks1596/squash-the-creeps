@tool
extends Node

@export var spawn_parent: Node
@export var player: Node3D
@export var mobs: Array[PackedScene] = []
@export_range(0, 1, 1, "or_greater", "suffix:m/s") var mob_min_speed = 10
@export_range(1, 1, 1, "or_greater", "suffix:m/s") var mob_max_speed = 18
@export_range(0, 180, 1, "radians") var mob_direction_diviation := PI / 4

@onready var _spawn_location = $SpawnPath/SpawnLocation as PathFollow3D
@onready var _spawn_timer = $Timer as Timer

func start():
	pass


func stop():
	_spawn_timer.stop()


func _spawn_mob():
	var target_position = player.position
	var mob_scene = mobs.pick_random() as PackedScene
	var mob = mob_scene.instantiate() as Mob
	
	var spawn_position = _generate_spawn_position()
	var direction_diviation = _generate_direction_diviation()
	
	mob.look_at_from_position(spawn_position, target_position)
	mob.rotation.x = 0
	mob.rotate_y(direction_diviation)
	mob.velocity = _generate_velocity(mob.rotation)
	mob.squashed.connect(Score.increase)
	
	spawn_parent.add_child(mob)


func _generate_spawn_position() -> Vector3:
	_spawn_location.progress_ratio = randf()
	return _spawn_location.position


func _generate_direction_diviation() -> float:
	return randf_range(-mob_direction_diviation, mob_direction_diviation)


func _generate_velocity(current_rotation: Vector3) -> Vector3:
	var speed = randi_range(mob_min_speed, mob_max_speed)
	var speedVector = Vector3.FORWARD * speed
	return speedVector.rotated(Vector3.UP, current_rotation.y)


func _generate_direction(mob: Mob, target_position: Vector3):
	mob.look_at(target_position)
	var angle = randf_range(-mob_direction_diviation, mob_direction_diviation)
	mob.rotate_y(angle)


func _get_configuration_warnings():
	var warnings = []
	
	if not spawn_parent:
		warnings.append("`Spawn parent` should be initialized")
	
	if not player:
		warnings += "`player` should be initialized"
		
	if mob_max_speed < mob_min_speed:
		warnings.append("`Mob max speed` should be greater or equal `Mom min speed`")
	
	if not mobs:
		warnings.append("`Mobs` array should be initialized")
	elif mobs.is_empty():
		warnings.append("`Mobs` array should not be empty")
	
	return warnings
