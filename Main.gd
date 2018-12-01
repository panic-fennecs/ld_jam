extends Node2D

func _process(delta):
	$FpsCounter.text = str(Engine.get_frames_per_second()) + " FPS"