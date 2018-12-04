extends KinematicBody2D

enum State {FALLING, MOVING, CHARGE}

var velocity = Vector2(0, 0)
var target_velocity = 0
var charge_cooldown = 0
var state = State["MOVING"]
var dead = false;
var damaged_in_this_charge = false
var time = 0

const MAX_SPEED = 100;
const ACCELERATION = 40;
const CAST_RANGE = 300;
const CHARGE_VELOCITY = 500;
const CHARGE_COOLDOWN = 100;
const DAMAGE = 50;
const DAMAGE_DISTANCE = 70;
const CORPSE_PRELOAD = preload("res://Corpse.tscn")
const DEAD_BODY_PRELOAD = preload("res://DeadBody.tscn")

func _process_moving():
	if target_velocity > 0:
		if not _right_bot_sensor_colliding():
			target_velocity = -MAX_SPEED
		if is_right_colliding():
			target_velocity = -MAX_SPEED
		if _right_spikes_colliding():
			target_velocity = -MAX_SPEED
	elif target_velocity < 0:
		if not _left_bot_sensor_colliding():
			target_velocity = MAX_SPEED
		if is_left_colliding():
			target_velocity = MAX_SPEED
		if _left_spikes_colliding():
			target_velocity = MAX_SPEED
	else:
		target_velocity = MAX_SPEED
	if target_velocity < 0:
		$PlayerRayCast.cast_to.x = -CAST_RANGE
	else:
		$PlayerRayCast.cast_to.x = CAST_RANGE

	# check charge
	var collider = $PlayerRayCast.get_collider()
	if collider and collider.name == "Player" and charge_cooldown == 0:
		state = State["CHARGE"]
		charge_cooldown = CHARGE_COOLDOWN
		if target_velocity > 0:
			target_velocity = CHARGE_VELOCITY
		else:
			target_velocity = -CHARGE_VELOCITY

	if charge_cooldown > 0:
		charge_cooldown -= 1

func _process_falling():
	target_velocity = 0

func _process_charge():
	var collider = $PlayerRayCast.get_collider()


	if collider and collider.name == "Player":
		var diff = collider.position - position
		if diff.length() < DAMAGE_DISTANCE and not damaged_in_this_charge:
			collider.damage_from_mob1(self)
			damaged_in_this_charge = true
	else:
		if (target_velocity > 0 and is_right_colliding()) or (target_velocity < 0 and is_left_colliding()):
			state = State["MOVING"]
	
	if target_velocity > 0:
		if _right_spikes_colliding_charge():
			state = State["MOVING"]
			target_velocity = -MAX_SPEED
	if target_velocity < 0:
		if _left_spikes_colliding_charge():
			state = State["MOVING"]
			target_velocity = MAX_SPEED

	if state == State["MOVING"]:
		damaged_in_this_charge = false

func _calculate_state():
	if is_grounded():
		if state == State["FALLING"]:
			state = State["MOVING"]
	else:
		state = State["FALLING"];

func die():
	var corpse = CORPSE_PRELOAD.instance()
	corpse.set_position(position)
	get_node("/root/Main").add_child(corpse)
	
	var dead_body = DEAD_BODY_PRELOAD.instance()
	dead_body.set_position(position + Vector2(0, -25))
	dead_body.get_node("AnimatedSprite").set_animation("mob1")
	get_node("/root/Main").add_child(dead_body)
	
	queue_free()

func _physics_process(delta):
	time += delta
	if dead:
		die()
		return
	else:
		set_sprite()

	_calculate_state()

	if state == State["MOVING"]:
		_process_moving()
	elif state == State["FALLING"]:
		_process_falling()
	elif state == State["CHARGE"]:
		_process_charge()

	_adjust_velocity(delta)

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

func _left_spikes_colliding():
	return _collides_spikes($SpikeSensorLeft)

func _right_spikes_colliding():
	return _collides_spikes($SpikeSensorRight)

func _right_spikes_colliding_charge():
	return _collides_spikes($SpikeSensorRightCharge)

func _left_spikes_colliding_charge():
	return _collides_spikes($SpikeSensorLeftCharge)
	
func _collides_spikes(sensor):
	var areas = sensor.get_overlapping_areas()
	for a in areas:
		if a.name.begins_with("Spike"):
			return true
	return false

func is_grounded():
	#return collides_direction(Vector2(0, -1))
	var bodies = $SensorBot.get_overlapping_bodies()
	for b in bodies:
		if b.name.begins_with("Block"):
			return true
		
	return false

func is_left_colliding():
	var bodies = $SL.get_overlapping_bodies()
	for b in bodies:
		if b.name.begins_with("Block"):
			return true
		
	return false

func is_right_colliding():
	var bodies = $SR.get_overlapping_bodies()
	for b in bodies:
		if b.name.begins_with("Block"):
			return true
		
	return false

func collides_direction(x):
	for i in range(get_slide_count()):
		var c = get_slide_collision(i)
		if (c.normal - x).length() < 0.01:
			return true
	return false

func _adjust_velocity(delta):
	var update = target_velocity - velocity.x
	update = clamp(update, -ACCELERATION, ACCELERATION)
	velocity.x += update

	velocity.y += 3000 * delta
	velocity.y *= pow(0.3, delta)

func damage(damage):
	if state != State["CHARGE"]:
		dead = true

func collide_spike():
	dead = true

func set_sprite():
	if target_velocity < 0:
		$AnimatedSprite.flip_h = true
	elif target_velocity > 0:
		$AnimatedSprite.flip_h = false

	if state == State["CHARGE"]:
		$AnimatedSprite.set_animation("charge")
	else:
		$AnimatedSprite.set_animation("walk")

		$AnimatedSprite.offset.y = sin(time*5)*100