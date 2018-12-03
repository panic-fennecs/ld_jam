extends Node2D

func _ready():
	$CharacterSprite/AnimationPlayer.play("EndScreen")

func _process(delta):
	$TextNode.position.y -= delta * 30

func _on_Timer_timeout():
	get_tree().change_scene("res://Start.tscn")
