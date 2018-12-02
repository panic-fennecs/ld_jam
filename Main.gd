extends Node2D

export (PackedScene) var audioplayer

func _ready():
	var audioplayerInstance = audioplayer.instance()
	add_child(audioplayerInstance)

