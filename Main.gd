extends Node2D

export (PackedScene) var audioplayer

const LEVEL0 = preload("res://level_0.tscn")
const LEVEL1 = preload("res://Terrain.tscn")
const LEVEL2 = preload("res://level_2.tscn")
const ENDSCREEN = preload("res://EndScene.tscn")

func _ready():
	var audioplayerInstance = audioplayer.instance()
	add_child(audioplayerInstance)

	if GlobalState.level == 0:
		var level = LEVEL0.instance()
		add_child(level)
	elif GlobalState.level == 1:
		var level = LEVEL1.instance()
		add_child(level)
	elif GlobalState.level == 2:
		var level = LEVEL2.instance()
		add_child(level)
	elif GlobalState.level == 3:
		var end_screen = ENDSCREEN.instance()
		add_child(end_screen)