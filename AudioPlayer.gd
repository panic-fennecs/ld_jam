extends AudioStreamPlayer2D

var enemyDying = preload("res://audio/bumm.ogg")
var lightningStrike = preload("res://audio/bumm.ogg")

func _ready():
	pass
	
func playLightningSound():
	setStream(lightningStrike)

func playEnemyDying():
	setStream(enemyDying)
	
func setStream(pathToFile):
	stream = pathToFile
	stream.set_loop(false)
	play()