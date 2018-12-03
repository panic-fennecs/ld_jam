extends KinematicBody2D

signal die()

export (int) var max_explosion_count = 30
const CORPSE_PRELOAD = preload("res://Corpse.tscn")
const EXPLOSION_PRELOAD = preload("res://Explosion.tscn")
const DEAD_BODY_PRELOAD = preload("res://DeadBody.tscn")

var explosion_countdown = 0
var explosion_default_scale
var time = 0
var default_scale = 1

func _ready():
	explosion_default_scale = $ExplosionIndicator.scale

func _physics_process(delta):
	time += delta
	$AnimatedSprite.offset.y = sin(time*5)*100
	if !is_in_explosion():
		if is_player_close():
			start_explosion()
			$AnimatedSprite.set_animation("trigger")
	else:
		var explosion_factor = explosion_countdown / float(max_explosion_count)
		$ExplosionIndicator.visible = true
		$ExplosionIndicator.scale = explosion_default_scale * explosion_factor 
		$ExplosionIndicator.self_modulate.a = explosion_factor
		explosion_countdown += 1
		if explosion_countdown >= max_explosion_count:
			damage_aoe()
			
			var explosion = EXPLOSION_PRELOAD.instance()
			explosion.set_position(position)
			get_node("/root/Main").add_child(explosion)
			explosion.emitting = true
			var timer = explosion.get_node("Timer")
			timer.connect("timeout", explosion, "queue_free")
			timer.start()
			
			var corpse = CORPSE_PRELOAD.instance()
			corpse.set_position(position)
			get_node("/root/Main").add_child(corpse)

			var dead_body = DEAD_BODY_PRELOAD.instance()
			dead_body.set_position(position)
			dead_body.get_node("AnimatedSprite").set_animation("mob2")

			get_node("/root/Main").add_child(dead_body)
			emit_signal("die")
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
