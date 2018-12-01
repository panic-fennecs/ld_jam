extends Node2D

export (int) var speed = 10
export (int) var magnitute = 10
var camera = null

func shake_offset():
	var time_left = $Timer.time_left
	var x = sin(time_left * PI * 2 * speed) * magnitute * time_left
	return Vector2(x, 0)

func set_camera(camera):
	self.camera = camera

func _on_Timer_timeout():
	queue_free()