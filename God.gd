extends Node

signal strike

var camera

const MAX_THUNDER_BAR_SIZE = 160
const RAGE_WAIT_TIME = 5

func _ready():
	camera = get_parent().get_node("Camera")

func _process(delta):
	#var perc = min(1, (elapsed_time / RAGE_WAIT_TIME))
	var perc = 1 - $Timer.time_left / $Timer.wait_time
	camera.get_node("ThunderBar/AnimatedSprite").region_rect.size.x = MAX_THUNDER_BAR_SIZE * perc

	var shake_sum = Vector2(0, 0)
	for camera_shaker in get_node("CameraShakers").get_children():
		shake_sum += camera_shaker.shake_offset()
	camera.shake_offset = shake_sum

func begin_lightning():
	spawn_thunder()
	emit_signal("strike")
	var elapsed_time = $Timer.wait_time - $Timer.time_left
	#if elapsed_time > RAGE_WAIT_TIME:
	var wait = 0.2 + ($RageTimer.time_left / $RageTimer.wait_time) * 5
	
	$LightningTimer.wait_time = wait
	$LightningTimer.start()

func _settle():
	$LightningTimer.stop()
	$Timer.start()

func spawn_thunder():
	var LightningStrike = preload("res://LightningStrike.tscn")
	var lightning_strike = LightningStrike.instance()
	lightning_strike.set_camera(camera)
	lightning_strike.set_shaker_parent(get_node("CameraShakers"))
	add_child(lightning_strike)

func _on_LightningTimer_timeout():
	begin_lightning()

func _on_Timer_timeout():
	$RageTimer.start()
	begin_lightning()