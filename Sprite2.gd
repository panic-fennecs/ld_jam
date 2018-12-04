extends Sprite

var time = 0

func _ready():
	pass # Replace with function body.

func _process(delta):
	time += delta
	set_offset(Vector2(0, sin(time*3)*10))