extends Node2D

export (String) var next_level
export (Vector2) var player_spawn_position

var finished = false

func _on_Area2D_body_entered(body):
	if body.name.begins_with("Player"):
		finish()

func _physics_process(delta):
	if finished and Input.is_action_pressed("ui_up"):
		if next_level == null:
			print("show endscreen")
			pass
		else:
			var terrain_name = get_node("..").name

			var main = get_node("/root/Main")
			var old_terrain = main.get_node(terrain_name)

			var new_scene = load(next_level)
			main.add_child(new_scene.instance())

			var global_state = get_node("/root/GlobalState")
			global_state.checkpoint_position = player_spawn_position

			get_tree().reload_current_scene()
			global_state.death_count = 0
			main.remove_child(old_terrain)

		finished = false

func finish():
	get_node("/root/Main/Camera/ContinueLabel").visible = true
	var death_label = get_node("/root/Main/Camera/DeathLabel")
	var global_state = get_node("/root/GlobalState")
	death_label.visible = true
	finished = true
	AudioPlayerScene.play_game_over_sound()