extends Node2D

func _on_Area2D_body_entered(body):
	if body.has_method("sacrify"):
		body.sacrify()
		$Particles2D.emitting = true
		#todo start anim

func _on_FinishSacrificeTimer_timeout():
	$Particles2D.emitting = false
