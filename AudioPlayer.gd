extends AudioStreamPlayer

var enemyDying = preload("res://audio/bumm.ogg")
var lightningStrike = preload("res://audio/bumm.ogg")
var dash = preload("res://audio/dash.ogg")
var die = preload("res://audio/die.ogg")
var jump = preload("res://audio/jump.ogg")
var doublejump = preload("res://audio/double_jump.ogg")
var game_over = preload("res://audio/game_over.ogg")
var sacrifice = preload("res://audio/sacrifice.ogg")
var background = preload("res://audio/background_music.ogg")

var players = []

func _ready():
	var music_player = AudioStreamPlayer.new()
	background.set_loop(true)
	music_player.stream = background
	music_player.volume_db = -12
	add_child(music_player)
	music_player.play()

func _physics_process(delta):
	for p in players:
		if not p.is_playing():
			players.erase(p)
			p.queue_free()
			break

func playStream(pathToFile):
	var player = AudioStreamPlayer.new()
	pathToFile.set_loop(false)
	player.stream = pathToFile
	add_child(player)
	player.play()

	players.append(player)

func playLightningSound():
	playStream(lightningStrike)

func playEnemyDyingSound():
	playStream(enemyDying)
	
func play_dash_sound():
	playStream(dash)

func play_dying_sound():
	playStream(die)

func play_jump_sound():
	playStream(jump)

func play_doublejump_sound():
	playStream(doublejump)

func play_game_over_sound():
	playStream(game_over)

func play_sacrifice_sound():
	playStream(sacrifice)
