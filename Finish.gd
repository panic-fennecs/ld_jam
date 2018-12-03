extends Node2D

export (String) var next_level
export (Vector2) var player_spawn_position

var finished = false

func _on_Area2D_body_entered(body):
	if body.name.begins_with("Player"):
		finish()

func _physics_process(delta):
	if finished and Input.is_action_pressed("ui_up"):
		var terrain_name = get_node("..").name

		var global_state = get_node("/root/GlobalState")

		var main = get_node("/root/Main")
		var old_terrain = main.get_node(terrain_name)

		var new_scene = load(next_level)
		main.add_child(new_scene.instance())

		global_state.checkpoint_position = player_spawn_position
		finished = false

		get_tree().reload_current_scene()

		main.remove_child(old_terrain)

func finish():
	get_node("/root/Main/Camera/ContinueLabel").visible = true
	finished = true