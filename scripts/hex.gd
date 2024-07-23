extends Node2D
var pos: int
var line: int = -1
var lpos: int
var ends: Array[int]
var ingredient: int = -1


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func neighborhood():
	$Label.text = str(ingredient)
	if pos not in ends:	#talk to neighbor to the right
		pass
	if line != ends.size():	#talk to neighbors below
		if line >= ends.size()/2:
			if pos in ends:	#talk to neighbor below left only
				pass
			elif pos - 1 in ends:	#talk to neighbor below right only
				pass
		else:	#talk to both neighbors below
			pass
		pass
	else:	#no more neighbors below
		print("yes")


func positionate():
	lpos = pos
	for i in ends.size():
		if pos > ends[i]:
			line = i
	if line >= 0:
		lpos -= ends[line]+1
	line += 1
	if line < ends.size()/2:
		$".".translate(Vector2(lpos*46-(line-ends.size()/2)*23,line*35))
	else:
		$".".translate(Vector2(lpos*46+(line-ends.size()/2)*23,line*35))

func is_empty() -> bool:
	var r: bool = ingredient == -1
	return r
