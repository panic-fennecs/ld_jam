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
	velocity.x += dir * delta * 3000
	
	# gravity
	velocity.y += 500 * delta
	
	# drag
	velocity.x *= pow(0.5, delta)
	velocity.y *= pow(0.9, delta)
	
	# jump
	if Input.is_action_just_pressed("ui_up") and can_jump:
		velocity.y = -500
		can_jump = false
	
	if Input.is_action_just_pressed("dash") and can_dash:
		var dash_dir = (looks_right as int) * 2 - 1
		velocity.x = dash_dir * 2000
		can_dash = false

	var original_vel = velocity
	var motion = velocity * delta
	var c = move_and_collide(motion)
	
	while c:
		can_dash = true
		can_jump = true

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

func die():
	print("you are dead. Too bad.")

func collide_spike():
	die()