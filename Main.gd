extends Node2D

export (PackedScene) var audioplayer

const LEVEL0 = preload("res://level_0.tscn")
const LEVEL1 = preload("res://Terrain.tscn")
const LEVEL2 = preload("res://level_2.tscn")

var level

func _ready():
	var audioplayerInstance = audioplayer.instance()
	add_child(audioplayerInstance)

	if GlobalState.level == 0:
		level = LEVEL0.instance()
		add_child(level)
	elif GlobalState.level == 1:
		level = LEVEL1.instance()
		add_child(level)
	elif GlobalState.level == 2:
		level = LEVEL2.instance()
		add_child(level)
	elif GlobalState.level == 3:
		get_tree().change_scene("res://EndScene.tscn")