extends KinematicBody2D

const MAX_DASH_COUNTER = 5
const THROW_SPEED = 600

var velocity = Vector2(0, 0)
var can_jump = true
var can_dash = true
var looks_right = true
var health = 100
var dash_counter = 0
var carry = null

# Called when the node enters the scene tree for the first time.
func _ready():
	update_healthbar()
	#$CharacterSprite/AnimationPlayer.play("Move")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var dir = (Input.is_action_pressed("ui_right") as int) - (Input.is_action_pressed("ui_left") as int)
	var new_looks_right = looks_right
	if dir == -1:
		new_looks_right = false
	elif dir == 1:
		new_looks_right = true
	if new_looks_right != looks_right:
		$CharacterSprite.scale.x *= -1
		looks_right = new_looks_right
	
	if dash_counter == 0:
		# movement
		velocity.x += dir * delta * 7000

		# gravity
		velocity.y += 3000 * delta
	
		# drag
		velocity.x *= pow(0.00002, delta)
		velocity.y *= pow(0.3, delta)
	
		try_jump()
		try_dash()
	else:
		dash_counter -= 1
		if dash_counter <= 0:
			dash_counter = 0
			velocity.x = 0
	
	try_carry()

	move_and_slide(velocity)
	slide_velocity()
	
	if is_grounded():
		can_dash = true
		can_jump = true
	
func jump():
	velocity.y = -1500

func try_jump():
	if Input.is_action_just_pressed("ui_up"):
		if is_grounded():
			jump()
		elif can_jump:
			jump()
			can_jump = false

func try_dash():
	if Input.is_action_just_pressed("dash") and can_dash:
		dash_counter = MAX_DASH_COUNTER
		var dash_dir = look_direction()
		velocity.x = dash_dir * 2000
		velocity.y = 0
		can_dash = false
		for b in $DashObject.get_overlapping_bodies():
			try_damage(b)

func try_carry():
	if Input.is_action_just_pressed("carry"):
		var main = get_node("/root/Main")
		if carry:
			remove_child(carry)
			main.add_child(carry)
			carry.throw(self)
			var throwv = Vector2(look_direction() * THROW_SPEED, 0)
			carry.velocity = velocity + throwv
			velocity -= throwv
			carry = null
		else:
			for b in get_node("DashObject").get_overlapping_bodies():
				if b.name.begins_with("Corpse"):
					carry = b
					main.remove_child(b)
					add_child(b)
					carry.start_carry(self)
					break

func slide_velocity():
	for i in range(get_slide_count()):
		var c = get_slide_collision(i)
		velocity = velocity.slide(c.normal)

func collides_direction(x):
	for i in range(get_slide_count()):
		var c = get_slide_collision(i)
		if (c.normal - x).length() < 0.01:
			return true
	return false

func is_grounded():
	return collides_direction(Vector2(0, -1))

func restart():
	get_tree().change_scene("res://Main.tscn")

func die():
	print("you are dead. Too bad.")
	call_deferred("restart")

func collide_spike():
	die()

func damage_from_mob1(mob):
	damage(50)
	velocity = mob.velocity + Vector2(0, -400)

func damage(x):
	health -= x
	if health <= 0:
		health = 0
	update_healthbar()
	if health == 0:
		die()

func update_healthbar():
	get_node("/root/Main/Camera/Healthbar").text = str(health)

func look_direction():
	return (looks_right as int) * 2 - 1

func try_damage(b):
	if b.has_method("damage") and b.name != "Player" and dash_counter > 0:
		b.damage(10)

func _on_DashObject_body_entered(body):
	try_damage(body)

