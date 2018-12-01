extends Node2D

export (float) var fade_in_duration = 0.5
export (float) var attack_duration = 0.5
export (float) var fade_out_duration = 0.5

func _ready():
	$Timer.wait_time * fade_in_duration + attack_duration + fade_out_duration + 10 # TODO does not work
	$Timer.connect("timeout", self, "queue_free");

	var viewport_size = get_viewport().size
	var x = randf() * viewport_size.x

	$Line.points[0].x = x
	$Line.points[1].x = x
	$Line.points[1].y = viewport_size.y

func _process(delta):
	var lightning_width = 64
	var wait_time = $Timer.wait_time
	var time_left = $Timer.time_left
	var elapsed = wait_time - time_left
	var width
	if elapsed < fade_in_duration:
		var elapsed_normaized = elapsed / fade_in_duration
		width = elapsed_normaized * lightning_width / 2
	elif elapsed < attack_duration:
		var elapsed_normaized = (elapsed - fade_in_duration) / attack_duration
		width = lightning_width
	else:
		var elapsed_normaized = (elapsed - fade_in_duration - attack_duration) / fade_out_duration
		width = lightning_width * (1 - elapsed_normaized)
	$Line.width = width

func _on_Timer_timeout():
	queue_free()