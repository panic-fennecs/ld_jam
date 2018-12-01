extends KinematicBody2D

var velocity = Vector2(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var dir = (Input.is_action_pressed("ui_right") as int) - (Input.is_action_pressed("ui_left") as int)
	
	# movement
	velocity.x += dir * delta * 1000
	
	# gravity
	velocity.y += 120 * delta
	
	# drag
	velocity *= pow(0.9, delta)

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