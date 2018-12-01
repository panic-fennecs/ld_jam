extends Node

signal strike

func _process(delta):
	$Label.text = str($Timer.time_left)


func _settle():
	$Timer.start()

func _on_Timer_timeout():
	emit_signal("strike")