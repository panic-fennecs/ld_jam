extends KinematicBody2D

enum State {FALLING, MOVING}

var velocity = Vector2(0, 0);
var target_velocity = 0;

var state = State.MOVING;

const MAX_SPEED = 100;
const ACCELERATION = 10;

func _process_moving():
	if target_velocity > 0:
		if not _right_bot_sensor_colliding():
			target_velocity = -MAX_SPEED
		if _right_sensor_colliding():
			target_velocity = -MAX_SPEED
	elif target_velocity < 0:
		if not _left_bot_sensor_colliding():
			target_velocity = MAX_SPEED
		if _left_sensor_colliding():
			target_velocity = MAX_SPEED
	else:
		target_velocity = MAX_SPEED

func _process_falling():
	target_velocity = 0

func _calculate_state():
	if _bot_sensor_colliding():
		if state == State["FALLING"]:
			state = State["MOVING"]
	else:
		state = State["FALLING"];

func _physics_process(delta):
	_calculate_state()

	if state == State["MOVING"]:
		_process_moving()
	if state == State["FALLING"]:
		_process_falling()

	_adjust_velocity()

	_apply_velocity(delta)

func _apply_velocity(delta):
	var original_vel = velocity
	var motion = velocity * delta
	var c = move_and_collide(motion)

	while c:
		if c.remainder.length() == 0:
			return

		var n = c.normal

		velocity = velocity.slide(n)
		motion = velocity.normalized() * c.remainder.dot(velocity.normalized())

		# check that the resulting velocity is not opposite to the original velocity, which would mean moving backward.
		if original_vel.dot(velocity) > 0:
			c = move_and_collide(motion)
		else:
			c = null

func _turn():
	target_velocity = -target_velocity

func _right_bot_sensor_colliding():
	var bodies = $SensorRightBot.get_overlapping_bodies()
	return bodies.size() != 0

func _left_bot_sensor_colliding():
	var bodies = $SensorLeftBot.get_overlapping_bodies()
	return bodies.size() != 0
	
func _bot_sensor_colliding():
	var bodies = $SensorBot.get_overlapping_bodies()
	return bodies.size() != 0

func _left_sensor_colliding():
	var bodies = $SensorLeft.get_overlapping_bodies()
	return bodies.size() != 0

func _right_sensor_colliding():
	var bodies = $SensorRight.get_overlapping_bodies()
	return bodies.size() != 0

func _adjust_velocity():
	var update = target_velocity - velocity.x
	update = clamp(update, -ACCELERATION, ACCELERATION)
	velocity.x += update
	velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)

	velocity.y = 50

func sacrify():
	print("sacrify")