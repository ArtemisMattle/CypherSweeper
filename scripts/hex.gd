extends Node2D
var pos: int
var line: int = -1
var lpos: int
var ends: Array[int]
var ingredient: int = 0
var neighborPos: Array[int]
var neighborIngr: Array[int]
signal talkToNeighbor(ownpos: int, owningr: int, neighborpos:int)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func neighborhood():
	$Label.text = str(pos)
	if pos not in ends:	#talk to neighbor to the right
		neighborPos.append(pos+1)
	if line != ends.size():	#talk to neighbors below
		if line >= ends.size()/2:	#below the middle the ends only have one neighbor below
			if pos in ends:	#talk to neighbor below left only
				neighborPos.append(ends[line]+lpos)
			elif pos - 1 in ends:	#talk to neighbor below right only
				neighborPos.append(ends[line]+lpos+1)
			else:	#talk to both neighbors below
				neighborPos.append(ends[line]+lpos)
				neighborPos.append(ends[line]+lpos+1)
		else:	#talk to both neighbors below
			neighborPos.append(ends[line]+lpos+1)
			neighborPos.append(ends[line]+lpos+2)
		pass
	else:	#no more neighbors below
		pass


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


func _on_button_pressed() -> void:
	print(neighborPos)
	print(neighborIngr)


