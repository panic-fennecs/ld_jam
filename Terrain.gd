extends Node

var regularBlockWidth = 64 #Faktor fuer Skalierung der Position zum Block
var blockArray = []

export (int) var width = 20
export (int) var height = 20
export (int) var planeHeight = 3
export (int) var minPlaneWidth = 3
export (int) var maxPlaneWidth = 8

var block_resource = preload("res://Block.tscn")
var terrain

func _ready():
	terrain = get_node(".")
	#generateLevelFrame()
	#generateLevelContent()

func generateLevelFrame():
	
	for i in range(0, width):
		instantiateBlock(Vector2((i * regularBlockWidth), regularBlockWidth / 2))
	
	for i in range(0, height):
		instantiateBlock(Vector2(regularBlockWidth / 2, i * regularBlockWidth))
	
func generateLevelContent():
	randomize()
	var blockCount = randi()%8+1 # zwischen 1 und 7
	generatePlanes(blockCount)
	generateSpikes(blockArray[1])
	
func generatePlanes(blockCount):
	for i in range(0, blockCount):
		var position = Vector2((randi() % width + 1) * regularBlockWidth, planeHeight * regularBlockWidth)
		planeHeight += 3
		instantiatePlane(position)
	
	
func generateSpikes(blockPlane):
	pass
	
func instantiatePlane(position):
	var maximumNumber = randi() % maxPlaneWidth + 1 + minPlaneWidth
	var i = 0
	while i < maximumNumber and (position.x / regularBlockWidth + i) < width:
		instantiateBlock(Vector2(position.x + (i * regularBlockWidth), position.y))	
		i += 1
	
func instantiateBlock(position):
	var block = block_resource.instance()
	block.set_position(position)
	terrain.add_child(block)
	blockArray.append(block)