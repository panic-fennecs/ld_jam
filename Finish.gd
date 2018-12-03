extends Node2D

export (String) var next_level
export (Vector2) var player_spawn_position

func _ready():
	pass # Replace with function body.


func _on_Area2D_body_entered(body):
	if body.name.begins_with("Player"):
		print("finish!")