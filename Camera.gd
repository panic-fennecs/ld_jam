extends Camera2D

export (int) var speed = 10
export (int) var magnitute = 10

var absolute_position = Vector2(0, 0)

func _ready():
	absolute_position = position
	var viewport_size = get_viewport().size


func _process(delta):
	var shake_offset = shake()
	absolute_position.y = get_parent().get_node("Player").position.y - get_viewport().size.y / 2
	position = absolute_position + shake_offset
	
func shake():
	var time_left = $ShakeTimer.time_left
	var x = sin(time_left * PI * 2 * speed) * magnitute * time_left
	return Vector2(x, 0)

func _on_God_strike():
	$ShakeTimer.start()
	print("thunder")

func _on_ShakeTimer_timeout():
	position.x = 0