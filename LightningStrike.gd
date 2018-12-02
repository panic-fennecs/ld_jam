extends Node2D

export (float) var fade_in_duration = 0.5
export (float) var attack_duration = 0.3
export (float) var fade_out_duration = 0.3

var camera = null
var shaker_parent = null
var lightning_hotfix_height = 512
var position_x = 0
var lightning_width = 48

func _ready():
	$Timer.wait_time = fade_in_duration + attack_duration + fade_out_duration
	$CameraShakeTimer.wait_time = fade_in_duration
	$CollisionTimer.wait_time = fade_in_duration
	$Timer.start()
	$CameraShakeTimer.start()
	$CollisionTimer.start()
	
	var viewport_size = get_viewport().size
	position_x = randf() * viewport_size.x

	$Line.points[0].x = position_x
	$Line.points[1].x = position_x
	$Line.points[1].y = viewport_size.y

func _process(delta):
	var viewport_size = get_viewport().size
	$Line.points[0].y = camera.position.y - lightning_hotfix_height / 2
	$Line.points[1].y = camera.position.y + viewport_size.y + lightning_hotfix_height / 2
	
	var wait_time = $Timer.wait_time
	var time_left = $Timer.time_left
	var elapsed = wait_time - time_left
	var width
	
	if elapsed < fade_in_duration:
		var elapsed_normaized = elapsed / fade_in_duration
		$Line.default_color.a = 0.25
		width = elapsed_normaized * lightning_width / 4
	elif elapsed < fade_in_duration + attack_duration:
		var elapsed_normaized = (elapsed - fade_in_duration) / attack_duration
		$Line.default_color.a = 1
		width = lightning_width
	else: # fade_out
		var elapsed_normaized = (elapsed - fade_in_duration - attack_duration) / fade_out_duration
		width = lightning_width * (1 - elapsed_normaized)
	
	$Line.width = width

func set_camera(camera):
	self.camera = camera

func set_shaker_parent(shaker_parent):
	self.shaker_parent = shaker_parent

func shake_camera():
	var CameraShaker = preload("res://CameraShaker.tscn")
	var camera_shaker = CameraShaker.instance()
	camera_shaker.set_camera(camera)
	shaker_parent.add_child(camera_shaker)

func create_collision():
	var timer = Timer.new()
	timer.connect("timeout", timer, "queue_free")
	timer.wait_time = attack_duration
	
	var position = camera.position
	var size = get_viewport().size
	var area = Area2D.new()
	var shape = CollisionPolygon2D.new()
	shape.polygon.push_back(Vector2(0, 0))
	shape.polygon.push_back(Vector2(0, size.y + lightning_hotfix_height))
	shape.polygon.push_back(Vector2(lightning_width, size.y + lightning_hotfix_height))
	shape.polygon.push_back(Vector2(lightning_width, 0))
	area.position.x = position.x + position_x
	area.position.y = position.y - lightning_hotfix_height
	area.add_child(shape)
	
	area.connect("body_entered", self, "deal_damage")
	
	timer.add_child(area)
	add_child(timer)
	timer.start()

func deal_damage(body):
	print(body)

func _on_Timer_timeout():
	queue_free()

func _on_CameraShakeTimer_timeout():
	shake_camera()

func _on_CollisionTimer_timeout():
	create_collision()