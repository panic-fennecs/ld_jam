extends Camera2D

export (int) var speed = 10
export (int) var magnitute = 10

var absolute_position = Vector2(0, 0)

func _ready():
	absolute_position = position

func _process(delta):
	shake()

func shake():
	var time_left = $ShakeTimer.time_left
	var x = sin(time_left * PI * 2 * speed) * magnitute * time_left
	position.x = absolute_position.x + x

func _on_God_strike():
	$ShakeTimer.start()

func _on_ShakeTimer_timeout():
	position.x = 0