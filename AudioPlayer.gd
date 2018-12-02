extends AudioStreamPlayer2D

var enemyDying = preload("res://audio/bumm.ogg")
var lightningStrike = preload("res://audio/bumm.ogg")
var dash = preload("res://audio/dash.ogg")
var die = preload("res://audio/die.ogg")
var jump = preload("res://audio/jump.ogg")
var doublejump = preload("res://audio/double_jump.ogg")
var game_over = preload("res://audio/game_over.ogg")
var sacrifice = preload("res://audio/sacrifice.ogg")

func _ready():
	pass
	
func setStream(pathToFile):
	stream = pathToFile
	stream.set_loop(false)
	play()
	
func playLightningSound():
	setStream(lightningStrike)

func playEnemyDyingSound():
	setStream(enemyDying)
	
func play_dash_sound():
	setStream(dash)

func play_dying_sound():
	setStream(die)

func play_jump_sound():
	setStream(jump)
	
func play_doublejump_sound():
	setStream(doublejump)
	
func play_game_over_sound():
	setStream(game_over)
	
func play_sacrifice_sound():
	setStream(sacrifice)
