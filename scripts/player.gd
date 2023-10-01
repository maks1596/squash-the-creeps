extends CharacterBody3D

var _target_velocity = Vector3.ZERO

signal hitted

@export_range(0, 100, 1, "or_greater", "suffix:m/s") 
var speed = 14
@export_range(0, 100, 1, "or_greater", "suffix:m/s^2") 
var fail_acceleration = 75
@export_range(0, 100, 1, "or_greater", "suffix:m/s") 
var jump_impulse = 20
@export_range(0, 100, 1, "or_greater", "suffix:m/s") 
var bounce_impulse = 16

@onready var _pivot = $Pivot

func _physics_process(delta):
	var direction = _get_direction_from_input()
	
	_rotate_model(direction)
	_apply_ground_velocity(direction)
	_apply_vertical_velocity(delta)
	_apply_jump_implulse()
	_check_squash_mob()
	
	velocity = _target_velocity
	move_and_slide()


func _get_direction_from_input() -> Vector3:
	var direction = Vector3.ZERO
	
	direction.x = Input.get_axis("move_left", "move_right")
	direction.z = Input.get_axis("move_up", "move_down")
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
	
	return direction


func _rotate_model(direction: Vector3):
	if direction == Vector3.ZERO: return
	_pivot.look_at(position + direction)


func _apply_ground_velocity(direction: Vector3):
	_target_velocity.x = direction.x * speed
	_target_velocity.z = direction.z * speed


func _apply_vertical_velocity(delta: float):
	if is_on_floor(): return
	
	_target_velocity.y = _target_velocity.y - (fail_acceleration * delta)


func _apply_jump_implulse():
	if not is_on_floor(): return
	if not Input.is_action_just_pressed("jump"): return
	
	_target_velocity.y = jump_impulse


func _check_squash_mob():
	for i in range(get_slide_collision_count()):
		var collisison = get_slide_collision(i)
		var collider = collisison.get_collider()
		
		if not collider: continue
		if not collider.is_in_group(Mob.GROUP): continue
		
		if _is_collide_from_top(collisison): 
			_on_mob_squashed(collider as Mob)
		else:
			_on_player_hitted()



func _on_mob_squashed(mob: Mob):
	mob.squash()
	_target_velocity.y = bounce_impulse


func _on_player_hitted():
	hitted.emit()
	queue_free()


func _is_collide_from_top(collision: KinematicCollision3D) -> bool:
	return Vector3.UP.dot(collision.get_normal()) > 0.1
