extends Node2D

@export var size: int = 7
var n: int = 0
var ends: Array[int]
var pos: Array
var hex = preload("res://scenes/hex.tscn")
enum Ingredient{Herb1, Herb2, Herb3, Shroom1, Shroom2, Shroom3, Salt1, Salt2, Salt3, Flamel}
@export var ingredient = [3,0,0,3,0,0,3,0,0,1]

signal Populated


func _ready():
	n = 1 - (3 * size) + (3 * (size * size))
	get_ends()
	def_hex()
	populate()
	Populated.emit()


	# calculates where the line breaks in the hex grid
func get_ends():
	var x: int = 1
	var y: int = -1
	var z: int = 0
	for i in 2 * size - 2:
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
	while 1:
		if y == ingredient.size():
			break
		else:
			y = 0
		for i in ingredient.size():
			if ingredient[i] != 0:
				var x = randi_range(0, n)
				if pos[x].is_empty():
					pos[x].ingredient = i
					ingredient[i] -= 1
			else:
				y += 1
	for i in n:
		pos[i].neighborhood()
