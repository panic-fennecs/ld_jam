extends Node2D

export (float) var fade_in_duration = 0.5
export (float) var attack_duration = 0.3
export (float) var fade_out_duration = 0.3

var camera = null
var shaker_parent = null
var lightning_hotfix_height = 512
var position_x = 0
var position_y = 0
var size_y = 0
var lightning_width = 48

func _ready():
	$Timer.wait_time = fade_in_duration + attack_duration + fade_out_duration
	$DuringAttackTimer.wait_time = fade_in_duration
	$Timer.start()
	$DuringAttackTimer.start()
	
	# TODO redundant, see set_camera
	var viewport_size = get_viewport().size
	position_x = camera.absolute_position.x + randf() * viewport_size.x

	update_line_position()

func _process(delta):
	update_line_position()
	update_line_width()

func update_line_position():
	var viewport_size = get_viewport().size
	position_y = camera.position.y - lightning_hotfix_height / 2
	size_y = viewport_size.y + lightning_hotfix_height
	$Line.points[0].x = position_x
	$Line.points[1].x = position_x
	$Line.points[0].y = position_y
	$Line.points[1].y = position_y + size_y

func update_line_width():
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

func shake_camera():
	var CameraShaker = preload("res://CameraShaker.tscn")
	var camera_shaker = CameraShaker.instance()
	camera_shaker.set_camera(camera)
	shaker_parent.add_child(camera_shaker)

func create_collision():
	var timer = Timer.new()
	timer.connect("timeout", timer, "queue_free")
	timer.wait_time = attack_duration
	
	# TODO update positions on camera movement
	var width = $Line.width
	var height = size_y
	var shape = RectangleShape2D.new()
	shape.extents.x = width
	shape.extents.y = height
	
	var collision_shape = CollisionShape2D.new()
	collision_shape.shape = shape
	collision_shape.position = Vector2(position_x - width / 2, position_y)
	
	var area = Area2D.new()
	area.add_child(collision_shape)
	area.connect("body_entered", self, "deal_damage")
	
	timer.add_child(area)
	add_child(timer)
	timer.start()

func deal_damage(body):
	if body.name == "Player":
		get_node("/root/Main/Player").damage(100)

func set_camera(camera):
	self.camera = camera

func set_shaker_parent(shaker_parent):
	self.shaker_parent = shaker_parent

func _on_Timer_timeout():
	queue_free()

func _on_DuringAttackTimer_timeout():
	lightningSound()
	shake_camera()
	create_collision()
	
func lightningSound():
	AudioPlayerScene.playLightningSound()
