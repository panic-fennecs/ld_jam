extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	var position = Vector2(1, 1)
	var block_resource = preload("res://Block.tscn")
	var block = block_resource.instance()
	#block.Transform.Position = position
	#get_tree().get_root().add_child(block)
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
