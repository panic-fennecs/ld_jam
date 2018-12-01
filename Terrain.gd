extends Node

func _ready():
	var width = 100
	var height = 100
	generateLevel(width, height)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func generateLevel(width, height):
	var position = Vector2(1000, 1000)
	var block_resource = preload("res://Block.tscn")
	var block = block_resource.instance()
	block.set_position(position)
	var terrain = get_node(".")
	terrain.add_child(block)
