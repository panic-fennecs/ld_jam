extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var velocity = Vector2(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var dir = (Input.is_action_pressed("ui_right") as int) - (Input.is_action_pressed("ui_left") as int)
	
	# movement
	velocity.x += dir * delta * 700
	
	# gravity
	velocity.y += 40 * delta
	
	# drag
	velocity *= pow(0.9, delta)
	
	move_and_collide(velocity * delta)