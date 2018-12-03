extends Node2D

func _on_Area2D_body_entered(body):
	if body.has_method("sacrify"):
		get_node("/root/PositionSaver").checkpoint_position = get_position()
		print("checkpoint: ", get_position())
		body.sacrify()
		$FinishSacrificeTimer.start()
		$Particles2D.emitting = true
		AudioPlayerScene.play_sacrifice_sound()
		#todo start anim

func _on_FinishSacrificeTimer_timeout():
	$Particles2D.emitting = false