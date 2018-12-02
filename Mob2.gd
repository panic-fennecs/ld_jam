extends KinematicBody2D

const MAX_EXPLOSION_COUNT = 100
const CORPSE_PRELOAD = preload("res://Corpse.tscn")

var explosion_countdown = 0

func _physics_process(delta):
	if !is_in_explosion():
		if is_player_close():
			start_explosion()
	else:
		explosion_countdown += 1
		if explosion_countdown >= MAX_EXPLOSION_COUNT:
			damage_aoe()
			var corpse = CORPSE_PRELOAD.instance()
			corpse.set_position(position)
			get_node("/root/Main").add_child(corpse)
			queue_free()
			

func damage_aoe():
	for b in $Area.get_overlapping_bodies():
		if b.name == "Player":
			b.damage(100)

func is_player_close():
	for b in $Area.get_overlapping_bodies():
		if b.name == "Player":
			return true
	return false

func start_explosion():
	explosion_countdown = 1

func is_in_explosion():
	return explosion_countdown > 0