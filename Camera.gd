extends Camera2D

var absolute_position = Vector2(0, 0)
var shake_offset = Vector2(0, 0)
var global_state


func _ready():
	global_state = get_node("/root/GlobalState")
	absolute_position = position
	var viewport_size = get_viewport().size

func _process(delta):
	$FpsCounterLabel.text = str(Engine.get_frames_per_second()) + " FPS"
	$DeathCounterLabel.text = str(global_state.death_count) + " deaths"
	$DeathLabel.text = str(global_state.death_count + 1) + " deaths" #pls don't hate me
	absolute_position.y = get_parent().get_node("Player").position.y - get_viewport().size.y / 2
	position = absolute_position
	position += shake_offset

func offset_position(offset):
	position += offset

func _on_God_strike():
	$ShakeTimer.start()

func _on_ShakeTimer_timeout():
	position.x = 0