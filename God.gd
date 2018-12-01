extends Node

signal strike

var camera

func _ready():
	camera = get_parent().get_node("Camera")

func _process(delta):
	camera.get_node("ThunderCounterLabel").text = str(ceil($Timer.time_left * 10) / 10) + " s"
	
	var shake_sum = Vector2(0, 0)
	for camera_shaker in get_node("CameraShakers").get_children():
		shake_sum += camera_shaker.shake_offset()
	camera.shake_offset = shake_sum

func _settle():
	$Timer.start()

func _on_Timer_timeout():
	emit_signal("strike")
	spawn_thunder()

func spawn_thunder():
	var LightningStrike = preload("res://LightningStrike.tscn")
	var lightning_strike = LightningStrike.instance()
	lightning_strike.set_camera(camera)
	lightning_strike.set_shaker_parent(get_node("CameraShakers"))
	add_child(lightning_strike)