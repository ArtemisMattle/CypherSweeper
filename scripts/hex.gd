extends Node2D
var pos: int
var line: int = -1
var lpos: int
var ends: Array[int]
var ingredient: String = "Nothing"
var neighborPos: Array[int]
var neighborIngr: Array[String]
var eigenValue: int
var turned: bool = false



# Called when the node enters the scene tree for the first time.
func _ready():
	signalBus.populated.connect(_on_populated)

func neighborhood():
	if pos not in ends:	#talk to neighbor to the right
		neighborPos.append(pos+1)
	if line != ends.size()-1:	#talk to neighbors below
		if line >= ends.size()/2:	#below the middle the ends only have one neighbor below
			if pos in ends:	#talk to neighbor below left only
				neighborPos.append(ends[line]+lpos)
			elif line == ends.size()-1: #no neihbors below
				pass
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
	for i in neighborPos:
		signalBus.talkToNeighbor.emit(pos, ingredient, i)

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
	var r: bool = ingredient == "Nothing"
	return r

func _on_button_pressed() -> void:
	print(neighborPos)
	print(neighborIngr)
	turn()

func talk_to_neighbor(ownpos: int, owningr: String) -> void:
	if ownpos not in neighborPos:
		neighborPos.append(ownpos)
	neighborIngr.append(owningr)
	match owningr:
		"Nothing":
			pass
		"Herb1":
			eigenValue += 1
			$colourMask/colourHerb.visible = true
		"Shroom1":
			eigenValue += 1
			$colourMask/colourShroom.visible = true
		"Salt1":
			eigenValue += 1
			$colourMask/colourSalt.visible = true
		"Herb2":
			eigenValue += 2
			$colourMask/colourHerb.visible = true
		"Shroom2":
			eigenValue += 2
			$colourMask/colourShroom.visible = true
		"Salt2":
			eigenValue += 2
			$colourMask/colourSalt.visible = true
		"Herb3":
			eigenValue += 3
			$colourMask/colourHerb.visible = true
		"Shroom3":
			eigenValue += 3
			$colourMask/colourShroom.visible = true
		"Salt3":
			eigenValue += 3
			$colourMask/colourSalt.visible = true
		"Flamel":
			eigenValue += 5

func _on_populated():
	if eigenValue != 0:
		$Label.text = str(eigenValue)

func turn():
	if not turned:
		turned = true
		if eigenValue == 0:
			#for i in neighborPos:
			#	signalBus.turnNeighbor.emit(i)
			$Timer.start()
		$Button.queue_free()
		$Label.visible = true
		$colourMask.visible = true
		print("turned"+ str(pos))

func _on_timer_timeout() -> void:
	if neighborPos.size() > 0:
		signalBus.turnNeighbor.emit(neighborPos[0])
		neighborPos.remove_at(0)
		$Timer.start()
