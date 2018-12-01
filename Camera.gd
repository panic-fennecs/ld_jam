extends Camera2D

var absolute_position = Vector2(0, 0)
var shake_offset = Vector2(0, 0)

func _ready():
	absolute_position = position
	var viewport_size = get_viewport().size

func _process(delta):
	$FpsCounterLabel.text = str(Engine.get_frames_per_second()) + " FPS"
	
	absolute_position.y = get_parent().get_node("Player").position.y - get_viewport().size.y / 2
	position = absolute_position
	position += shake_offset

func offset_position(offset):
	position += offset

func _on_God_strike():
	$ShakeTimer.start()
	print("thunder")

func _on_ShakeTimer_timeout():
	position.x = 0