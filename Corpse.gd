extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var dead = false

export var carried = false
export var velocity = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
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
	position = Vector2()

func throw(b):
	carried = false
	position = b.position

func sacrify():
	dead = true
	var x = get_node("/root/Main")
	var god = x.get_node("God")
	god._settle()