extends CharacterBody3D

var _target_velocity = Vector3.ZERO

@export_range(0, 100, 1, "or_greater", "suffix:m/s") 
var speed = 14
@export_range(0, 100, 1, "or_greater", "suffix:m/s^2") 
var fail_acceleration = 75

@onready var _pivot = $Pivot

func _physics_process(delta):
	var direction = _get_direction_from_input()
	
	_rotate_model(direction)
	_apply_ground_velocity(direction)
	_apply_vertical_Velocity(delta)
	
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


func _apply_vertical_Velocity(delta: float):
	if is_on_floor(): return
	_target_velocity.y = _target_velocity.y - (fail_acceleration * delta)
