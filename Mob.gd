extends KinematicBody2D

var velocity = Vector2(0, 0);
var direction = 1;
var step = 0;

const MAX_SPEED = 100;
const ACCELERATION = 10;

func _physics_process(delta):
	if step == 100:
		direction = -direction
		step=0
	step+=1
	velocity.x += direction * ACCELERATION
	velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
	velocity.y = 50;
	move_and_slide(velocity)
	# TODO redo velocity.y