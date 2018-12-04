extends Camera2D

var absolute_position = Vector2(0, 0)
var shake_offset = Vector2(0, 0)
var global_state
var current_position
var background_image = "res://resources/background_hell.png"
var god_image = "res://resources/god.png"

func _ready():
	global_state = get_node("/root/GlobalState")
	absolute_position = position
	var viewport_size = get_viewport().size
	current_position = get_parent().get_node("Player").position

func _physics_process(delta):
	$Node2D/FpsCounterLabel.text = str(Engine.get_frames_per_second()) + " FPS"
	$Node2D/DeathCounterLabel.text = str(global_state.death_count) + " deaths"
	$Labels/DeathLabel.text = str(global_state.death_count) + " deaths"
	absolute_position.y = get_parent().get_node("Player").position.y - get_viewport().size.y / 2
	absolute_position.x = get_parent().get_node("Player").position.x - get_viewport().size.x / 2

	var acc = absolute_position - current_position
	if acc.length() < 500:
		current_position += acc * 0.2
	else:
		current_position += acc

	if GlobalState.level != 3:
		position = current_position
		position += shake_offset

func offset_position(offset):
	position += offset

func _on_God_strike():
	$ShakeTimer.start()

func _on_ShakeTimer_timeout():
	position.x = 0
	