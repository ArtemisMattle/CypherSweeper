extends Node2D

@export var size: int = 7
var n: int = 0
var l: int
var width: int
var hight: int
var ends: Array[int]
var pos: Array
var hex = preload("res://scenes/hex.tscn")
signal talkToNeighbor(ownpos: int, owningr: int, neighborpos:int)
@export var ingredientMult: float = 1
@export var ingredientStack: Dictionary = {
	"Herb1" = 3,
	"Herb2" = 0,
	"Herb3" = 0,
	"Shroom1" = 3,
	"Shroom2" = 0,
	"Shroom3" = 0,
	"Salt1" = 3,
	"Salt2" = 0,
	"Salt3" = 0,
	"Flamel" = 1,
}



func _ready():
	n = 1 - (3 * size) + (3 * (size * size))
	l = 2 * size - 1
	width = l * 48 + 100
	hight = l * 35 + 150
	$PanelContainer.size = Vector2i(width, hight)
	get_viewport()
	get_ends()
	signalBus.talkToNeighbor.connect(connector)
	def_hex()
	populate()
	signalBus.populated.emit()
	signalBus.turnNeighbor.connect(turner)

func get_ends():# calculates where the line breaks in the hex grid
	var x: int = 1
	var y: int = -1
	var z: int = 0
	for i in 2 * size - 1:
		ends.append(x * size + y) 
		if i < size -1:
			z += 1
		else:
			z -= 1
		y += z
		x += 1

func def_hex():
	for i in n:
		pos.append(hex.instantiate())
		add_child(pos[i])
		pos[i].pos = i
		pos[i].ends = ends
		pos[i].positionate()

func populate():
	var y: int = 0
	for i in ingredientStack.keys():
		if i != "Flamel":
			ingredientStack[i] = int(ingredientStack[i] * ingredientMult)
	while 1:
		if y == ingredientStack.size():
			break
		else:
			y = 0
		for i in ingredientStack.keys():
			if ingredientStack[i] != 0:
				var x = randi_range(0, n-1)
				if pos[x].is_empty():
					pos[x].ingredient = i
					ingredientStack[i] -= 1
			else:
				y += 1
	for i in n:
		pass
		pos[i].neighborhood()

func connector(ownpos: int, owningr: String, neighborpos: int):
	pos[neighborpos].talk_to_neighbor(ownpos, owningr)

func turner(neighborpos: int):
	pos[neighborpos].turn()
