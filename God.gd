extends Node

signal strike

func _process(delta):
	$Label.text = str($Timer.time_left)

func _settle():
	$Timer.start()

func _on_Timer_timeout():
	emit_signal("strike")
	for i in range(1):
		spawn_thunder()

func spawn_thunder():
	var LightningStrike = preload("res://LightningStrike.tscn")
	var lightningStrike = LightningStrike.instance()
	add_child(lightningStrike)