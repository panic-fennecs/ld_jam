extends Node

signal god_strike

func _ready():
	$Timer.start();

func _process(delta):
	$Label.text = str($Timer.time_left)

func _on_timeout():
	emit_signal("god_strike")

func _settle():
	$Timer.start()