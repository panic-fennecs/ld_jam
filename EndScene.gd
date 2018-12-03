extends Node2D

func _ready():
	$CharacterSprite/AnimationPlayer.play("EndScreen")

func _on_Button_pressed():
	get_tree().change_scene("res://CreditScene.tscn")