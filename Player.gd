extends KinematicBody2D

var velocity = Vector2(0, 0)
var can_jump = true
var can_dash = true
var looks_right = true
var health = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var dir = (Input.is_action_pressed("ui_right") as int) - (Input.is_action_pressed("ui_left") as int)
	if dir == 1:
		looks_right = true
	elif dir == -1:
		looks_right = false
	
	# movement
	velocity.x += dir * delta * 7000
	
	# gravity
	velocity.y += 3000 * delta
	
	# drag
	velocity.x *= pow(0.00003, delta)
	velocity.y *= pow(0.3, delta)
	
	try_jump()
	try_dash()

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
		var dash_dir = (looks_right as int) * 2 - 1
		velocity.x = dash_dir * 2000
		can_dash = false

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

func die():
	print("you are dead. Too bad.")

func collide_spike():
	die()
