extends KinematicBody2D

enum State {FALLING, MOVING}

var velocity = Vector2(0, 0);
var target_velocity = 0;

var state = State.MOVING;
var left_counter = 0

const MAX_SPEED = 100;
const ACCELERATION = 10;

func _process_moving():
	if target_velocity > 0:
		if not _right_bot_sensor_colliding():
			target_velocity = -MAX_SPEED
		if is_right_colliding():
			target_velocity = -MAX_SPEED
	elif target_velocity < 0:
		if not _left_bot_sensor_colliding():
			target_velocity = MAX_SPEED
		if is_left_colliding():
			target_velocity = MAX_SPEED
	else:
		target_velocity = MAX_SPEED

func _process_falling():
	target_velocity = 0

func _calculate_state():
	if is_grounded():
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
	
	if is_left_colliding():
		left_counter += 1
		print("left_counter: ", left_counter)

	_apply_velocity(delta)

func _apply_velocity(delta):
	move_and_slide(velocity)
	slide_velocity()

func slide_velocity():
	for i in range(get_slide_count()):
		var c = get_slide_collision(i)
		velocity = velocity.slide(c.normal)

func _turn():
	target_velocity = -target_velocity

func _right_bot_sensor_colliding():
	var bodies = $SensorRightBot.get_overlapping_bodies()
	return bodies.size() != 0

func _left_bot_sensor_colliding():
	var bodies = $SensorLeftBot.get_overlapping_bodies()
	return bodies.size() != 0

func is_grounded():
	return collides_direction(Vector2(0, -1))

func is_left_colliding():
	return collides_direction(Vector2(1, 0))

func is_right_colliding():
	return collides_direction(Vector2(-1, 0))

func collides_direction(x):
	for i in range(get_slide_count()):
		var c = get_slide_collision(i)
		if (c.normal - x).length() < 0.01:
			return true
	return false

func _adjust_velocity():
	var update = target_velocity - velocity.x
	update = clamp(update, -ACCELERATION, ACCELERATION)
	velocity.x += update
	velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)

	velocity.y = 50

func sacrify():
	print("sacrify")