extends KinematicBody2D

var dead = false
export var carried = false
export var velocity = Vector2()

func _process(delta):
	if dead:
		queue_free()

func _physics_process(delta):
	if !carried:
		# gravity
		velocity.y += 3000 * delta
	
		# drag
		velocity.x *= pow(0.002, delta)
		velocity.y *= pow(0.3, delta)
	
		move_and_slide(velocity)
		slide_velocity()

func slide_velocity():
	for i in range(get_slide_count()):
		var c = get_slide_collision(i)
		velocity = velocity.slide(c.normal)

func start_carry(b):
	carried = true
	velocity = Vector2()
	position = Vector2(0, -80)

func throw(b):
	carried = false
	position = b.position

func sacrify():
	dead = true
	get_node("/root/Main/God")._settle()
	get_node("/root/Main/Player").carry = null