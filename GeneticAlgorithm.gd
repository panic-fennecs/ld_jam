extends Node

const POPULATION_SIZE = 100
const GENE_SIZE = 500

var population = []
var current_string = 0

class Gene:
	var dir = 0;
	var jump = false
	var dash = false
	func _init():
		dir = randi()%3-1
		jump = bool(randi()%2)
		dash = bool(randi()%2)
		

func _ready():
	for i in range(POPULATION_SIZE):
		var gene_string = []
		for j in range(GENE_SIZE):
			gene_string.append(Gene.new())
		
		population.append(gene_string)