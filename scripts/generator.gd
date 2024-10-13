extends Node2D
var size: int
var n: int
var l: int
var width: int
var hight: int
var ends: Array[int]
var pos: Array[gridCell] = []
var hex: PackedScene = preload("res://scenes/hex.tscn")
var mode: String = "hexNormal"
@export var usage: String = "game"
var ingredientStack: Dictionary
var ingredientList: Dictionary = {}
var ingList: Dictionary = {}
var toBeRevealed: Array[int] = []
var toBeRevealedLater: Array[int] = []
var openRevealers: Array[int] = []
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
@onready var tTimer: Timer = $turnTimer
@onready var fTimer: Timer = $flagTimer
@onready var tTune: AudioStreamPlayer = $turnSFX
var fTool: PackedScene = preload("res://scenes/flagging.tscn")
var flagTool: Control = null
var active: bool = true

enum sMode {normal, fast, zippy}

func _ready()-> void:
	match mode:
		"hexNormal": pass
		_: pass
	match usage:
		"game": readyGame()
		"lexNeigh":
			size = 3
			n = 19
			var c: int = 9
			l = 5
			get_ends()
			def_hex()
			for i: int in n:
				pos[i].cell.get_node("colour/button").disconnect("pressed",reveal)
				pos[i].cell.get_node("magTurner").body_entered.connect(magReveal.bind(i))
			pos[c].cell.get_node("colour/button").queue_free()
			pos[c].cell.get_node("colour/backshadow").queue_free()
			pos[c].hint.text = "C"
			pos[c].hint.visible = true
			for i: int in pos[c].neighbors:
				pos[i].cell.get_node("colour/backshadow").modulate = Color8(160, 100, 175, 150)
		"lexHint":
			size = 3
			n = 19
			var c: int = 9
			l = 5
			get_ends()
			def_hex()
			for i: int in n:
				pos[i].cell.get_node("colour/button").disconnect("pressed",reveal)
				pos[i].cell.get_node("magTurner").body_entered.connect(magReveal.bind(i))
			pos[c].cell.get_node("colour/button").queue_free()
			pos[c].cell.get_node("colour/backshadow").queue_free()
			pos[c].cell.get_node("indicator/indicatorHerb").visible = true
			pos[c].cell.get_node("indicator/indicatorShroom").visible = true
			pos[c].cell.get_node("indicator/indicatorSalt").visible = true
			pos[c].cell.get_node("indicator").visible = true
			pos[c].hint.text = "7"
			pos[c].hint.visible = true
			for i: int in pos[c].neighbors:
				pos[i].cell.get_node("colour/button").queue_free()
				pos[i].cell.get_node("colour/backshadow").queue_free()
			var iStack: Array[String] = ["Herb1", "Shroom1", "Shroom2", "Salt3"]
			for i: String in iStack:
				var x: int = pos[c].neighbors.keys().pick_random()
				while pos[x].ingredient != "Nothing0":
					x = pos[c].neighbors.keys().pick_random()
				pos[x].ingredient = i
				pos[x].sprIng.texture = load("res://assets/textures/ingredients/"+pos[x].ingredient+".png")
				pos[x].sprIng.visible = true

func readyGame()-> void: # sets everything into motion for a normal round to start
	rng.seed=globalVariables.rngseed
	
	size = globalVariables.size
	n = globalVariables.n
	ingredientStack = globalVariables.ingredientStack.duplicate()
	
	for i: String in globalVariables.uncoveredIngred:
		globalVariables.uncoveredIngred[i] = 0
	globalVariables.uncovered = 0
	
	l = 2 * size - 1
	width = l * 48 + 100
	hight = l * 34 + 400
	$PanelContainer.size = Vector2i(width, hight)
	$PanelContainer.set_position(Vector2(-width/2, -hight/2))
	$PanelContainer.visible = true
	get_viewport()
	get_ends()
	def_hex()
	signalBus.populated.emit()
	populate()
	signalBus.deactivate.connect(deactivate)
	signalBus.getRandomUnrevealed.connect(getUnrevealedIngredient)

func get_ends() -> void:# calculates where the line breaks in the hex grid
	var x: int = 1
	var y: int = -1
	var z: int = 0
	for i: int in 2 * size - 1:
		ends.append(x * size + y) 
		if i < size -1:
			z += 1
		else:
			z -= 1
		y += z
		x += 1

func positionate(cell: gridCell) -> void: # positionates the gridCells to make a hexgrid
	@warning_ignore("integer_division")
	if cell.line < l/2: # differentiates between the upper half and the lower half
		@warning_ignore("integer_division")
		cell.cell.translate(Vector2(cell.lpos*46-(cell.line-ends.size()/2)*23-(l/2)*46, (cell.line-l/2)*35))
	else:
		@warning_ignore("integer_division")
		cell.cell.translate(Vector2(cell.lpos*46+(cell.line-ends.size()/2)*23-(l/2)*46,(cell.line-l/2)*35))

func def_hex() -> void:# generates the gridcells with the position and their neigborhood
	var line: int = 0 # initiates the line counter
	for i: int in n:
		pos.append(gridCell.new()) # makes a gridCell for each position
		pos[i].cell = hex.instantiate() # instanciates a hex scene for each gridCell
		add_child(pos[i].cell)
		pos[i].line = line
		if line == 0: # calculates the position in the line
			pos[i].lpos = i
		else:
			pos[i].lpos = i-ends[line-1]-1
		if i == ends[line]: # advances the line counter
			line += 1
		positionate(pos[i])
		pos[i].initiate()
		pos[i].cell.get_node("colour/button").gui_input.connect(buttonForwarding.bind(i))
		pos[i].cell.get_node("magTurner").body_entered.connect(magReveal.bind(i))
		var y:String = "Nothing0"
		
		# to make list of the neighbors, a generic calculation of all 6 possible neighbors is used
		# due to the nature of the hexagonal grid, the upper half and the lower half have to be seperated
		# to only list the existing neighbors, if statements are used to exclude the false ones
		if pos[i].line > 0:
			@warning_ignore("integer_division")
			if pos[i].line <= ends.size()/2 && i-1 not in ends: # upper neighbors for the upper half of the grid
				if pos[i].line >= 2:
					pos[i].neighbors[ends[pos[i].line-2]+pos[i].lpos] = y
				else:
					pos[i].neighbors[-1+pos[i].lpos] = y # correction for line = 1, due to ends not having an entry at -1
			@warning_ignore("integer_division")
			if pos[i].line <= ends.size()/2 && i not in ends:
				if pos[i].line >= 2:
					pos[i].neighbors[ends[pos[i].line-2]+pos[i].lpos+1] = y
				else:
					pos[i].neighbors[pos[i].lpos] = y # correction for line = 1, due to ends not having an entry at -1
			@warning_ignore("integer_division")
			if pos[i].line > ends.size()/2: # upper neighbors for the lower half of the grid
				pos[i].neighbors[ends[pos[i].line-2]+pos[i].lpos+1] = y
				pos[i].neighbors[ends[pos[i].line-2]+pos[i].lpos+2] = y
		if i-1 not in ends && i != 0: # horrizontal neighbor to the left
			pos[i].neighbors[i-1] = y
		if i not in ends: # horrizontal neighbor to the right
			pos[i].neighbors[i+1] = y
		if pos[i].line < 2 * size - 2: 
			@warning_ignore("integer_division")
			if pos[i].line < ends.size()/2: # lower neighbors for the upper half
				pos[i].neighbors[ends[pos[i].line]+pos[i].lpos+1] = y
				pos[i].neighbors[ends[pos[i].line]+pos[i].lpos+2] = y
			@warning_ignore("integer_division")
			if pos[i].line >= ends.size()/2 && i-1 not in ends: # lower neighbors in the lower half of the grid
				pos[i].neighbors[ends[pos[i].line]+pos[i].lpos] = y
			@warning_ignore("integer_division")
			if pos[i].line >= ends.size()/2 && i not in ends:
				pos[i].neighbors[ends[pos[i].line]+pos[i].lpos+1] = y

func populate() -> void:# generates the ingredients
	while not ingredientStack.is_empty():
		for i: String in ingredientStack:# ingredientstack is defined for consistent amounts of ingredients
			if ingredientStack[i] != 0:# seeded random placement of ingredients in empty hexes
				var x: int = rng.randi_range(0, n-1)
				if pos[x].ingredient == "Nothing0":# empty cells only ;P
					pos[x].ingredient = i
					ingredientStack[i] -= 1
					ingredientList[x] = i
					pos[x].sprIng.texture = load("res://assets/textures/ingredients/"+pos[x].ingredient+".png")
			else:
				ingredientStack.erase(i)#removes empty ingredient slots for performance
	ingList = ingredientList.duplicate()
	for i: int in ingredientList:
		updateNeighbors(i)

func updateNeighbors(gCell: int) -> void: # takes in a a gridCell position and tells all neighbors about it's ingredient
	for i: int in pos[gCell].neighbors:
		pos[i].neighbors[gCell] = pos[gCell].ingredient
		pos[i].eigenValue = 0
		pos[i].eigenIndicator = []
		for j: int in pos[i].neighbors:
			pos[i].eigenValue += pos[j].ingredient.right(1).to_int()
			pos[i].eigenIndicator.append(pos[j].ingredient.left(-1))
		if pos[i].eigenValue > 0:
			pos[i].hint.text = str(pos[i].eigenValue)
		else: 
			pos[i].hint.text = " "
		var herb: Sprite2D = pos[i].cell.get_node("indicator/indicatorHerb")
		var shroom: Sprite2D = pos[i].cell.get_node("indicator/indicatorShroom")
		var salt: Sprite2D = pos[i].cell.get_node("indicator/indicatorSalt")
		herb.visible = "Herb" in pos[i].eigenIndicator
		shroom.visible = "Shroom" in pos[i].eigenIndicator
		salt.visible = "Salt" in pos[i].eigenIndicator

func moveIngredient(opos: int)-> bool: # tries to move an ingredient to a random empty space, returns if it was successful
	var x: int = rng.randi_range(0, n-1)
	if pos[opos].neighbors.has(x):
		return false
	if pos[x].ingredient == "Nothing0":# empty cells only ;P
		if not pos[x].revealed:
			pos[x].ingredient = pos[opos].ingredient
			ingredientList[x] = pos[opos].ingredient
			pos[opos].ingredient = "Nothing0"
			pos[opos].sprIng.texture = null
			pos[x].sprIng.texture = load("res://assets/textures/ingredients/"+pos[x].ingredient+".png")
			ingredientList.erase(opos)
			ingList.erase(opos)
			updateNeighbors(x)
			updateNeighbors(opos)
			return true
		else:
			return false
	else:
		return false

func buttonForwarding(event: InputEvent, i: int) -> void: # differentiates between left and rightclick on the hex buttons
	if event is InputEventMouseButton and event.is_released():
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				reveal(i, 0)
			MOUSE_BUTTON_RIGHT:
				active = false
				flag(i)

func flag(i: int) -> void: # flaggs cells
	var flag: Sprite2D = pos[i].cell.get_node("flag")
	if pos[i].flagged == "":
		flagTool = fTool.instantiate()
		add_child(flagTool)
		flagTool.set_position(pos[i].cell.position)
		signalBus.flagging.connect(flagFinish.bind(i))
	else:
		pos[i].flagged = ""
		flag.texture = null
		active = true

func flagFinish(flag: String, i: int) -> void:
	pos[i].flagged = flag
	pos[i].cell.get_node("flag").texture = load("res://assets/textures/ingredients/flags/" + flag + ".png")
	fTimer.start()
	signalBus.flagging.disconnect(flagFinish)
	flagTool.queue_free()

func _on_flag_timer_timeout() -> void:
	fTimer.stop()
	active = true

func magReveal(body: Node2D, i:int) -> void: # connects the Magnifyer to the reveal function
	if body.get_meta("enabled"):
		reveal(i, 2)

func reveal(i : int, m : int) -> void: # reveals a gridCell
	if not active:
		return
	if usage != "game": # ensures no utility usage of this script leads to bugs
		return
	# m: mode changes a few specifics, 0 is the default (click), 1 is for timed revealing, 2 is for the magnifyer
	if not pos[i].revealed: # checks if reveal is called on a revealed gridCell
		if pos[i].flagged != "":
			if pos[i].flagged == "Neutral":
				return
			elif pos[i].flagged == "Flamel":
				if globalVariables.uncovered < n - 1:
					return
			elif pos[i].flagged.left(-1) == "Numbered":
				if pos[i].flagged.to_int() <= globalVariables.minLvl():
					pos[i].cell.get_node("flag").texture = null
				else:
					return
			elif globalVariables.level[pos[i].flagged.left(-1)] >= pos[i].flagged.to_int():
				pos[i].cell.get_node("flag").texture = null
			else:
				return
		
		if m == 0: # stuff that happens only with manual reveal
			if globalVariables.buff["shield"] > 0: # checks if there is an active shield buff
				var neigh: bool = true
				for j: int in getNeighNeighbors(i):
					if pos[j].revealed:
						neigh = false
						break
				if neigh:
					globalVariables.buff["shield"] -= 1 # reduces the shield buff
					for j: int in pos[i].neighbors:
						if pos[j].ingredient != "Nothing0":
							var x: int = 0
							while not moveIngredient(j):
								x += 1
								if x > 1000: break
					if pos[i].ingredient != "Nothing0":
						var x: int = 0
						while not moveIngredient(i):
							x += 1
							if x > 1000: break
		
		# stuff that happens with every reveal
		
		# variable manipulation
		pos[i].revealed = true
		globalVariables.uncoveredIngred[pos[i].ingredient] += 1 # keeps track of uncovered ingredients (inclusive "Nothing0")
		globalVariables.uncovered += 1 # keeps track of uncovered tiles (to escape needing to sum up the dictionary)
		
		if globalVariables.uncovered == n - 1: # checks for if all but the flamel are uncovered
			signalBus.lvlFlamel.emit()
		
		if pos[i].ingredient == "Nothing0": # reduces workload by only looking at relevant cells
			if globalVariables.uncovered == globalVariables.lvlUP["Nothing0"]:
				signalBus.lvlNothing.emit() # allows for undamaged uncovering of the first ingredients
		else:
			ingList.erase(i)
			signalBus.uncoverIngr.emit(pos[i].ingredient, not ingList.values().has(pos[i].ingredient)) # sends the uncovered ingredient for damage calculation and similar
		
		pos[i].cell.get_node("colour/button").queue_free()
		pos[i].cell.get_node("colour/backshadow").queue_free()
		tTune.play() # plays a sound effect
		
		
		
		
		# chain revealing / cascading stuff
		if pos[i].eigenValue == 0: # checks for empty gridCells
			var revealer: Array[int] = []
			if settings.speedMode == sMode.normal: # checks for speedMode
				var revSoon: Array[int] = []
				for j: int in pos[i].neighbors:
					if not pos[j].revealed:
						revSoon.append(j)
				if not revSoon.is_empty():
					if m != 2:
						openRevealers.append(i)
					revealer.append(revSoon[randi_range(0, revSoon.size()-1)])
			else:
				for j: int in pos[i].neighbors:
					if not pos[j].revealed:
						revealer.append(j)
			match mode:
				0: toBeRevealed.append_array(revealer)
				1: 
					if settings.speedMode == sMode.zippy:
						toBeRevealed.append_array(revealer)
					else:
						toBeRevealedLater.append_array(revealer)
				_: pass
			tTimer.start() # starts the Timer to turn neighboring gridCells
		
		if pos[i].ingredient == "Nothing0":
			pos[i].hint.visible = true # shows the numeric hint if there is no ingredient
		else:
			pos[i].sprIng.visible = true # shows the ingredient otherwise
		pos[i].cell.get_node("indicator").visible = true # shows the indicators for neighboring ingredients

func _on_turn_timer_timeout() -> void: # reveals empty gridCells after time passed, look at func reveal
	tTimer.wait_time = 0.05 + randf_range(0.03, 0.07)
	for i: int in toBeRevealed:
		reveal(i, 1)
	toBeRevealed.clear()
	toBeRevealed.append_array(toBeRevealedLater)
	for i: int in openRevealers:
		var revSoon: Array[int] = []
		for j: int in pos[i].neighbors:
			if not pos[j].revealed:
				revSoon.append(j)
		if not revSoon.is_empty():
			toBeRevealed.append(revSoon[randi_range(0, revSoon.size()-1)])
		else:
			openRevealers.erase(i)

func deactivate(r: bool) -> void: # deactivates all interactivity with the map
	active = r
	for i: int in n:
		if not pos[i].revealed:
			if r:
				pos[i].cell.get_node("colour/button").set("mouse_filter", 1)
			else:
				pos[i].cell.get_node("colour/button").set("mouse_filter", 2)

func getUnrevealedIngredient() -> void: # emits a signal with a position and an ingredient
	var p: int = ingList.keys().pick_random()
	signalBus.returnUnrevealed.emit(pos[p].ingredient, pos[p].cell.global_position)

func getNeighNeighbors(i: int) -> Array[int]: # returns all unique neighbors of the neighbors of a cell
	var nNeighbors: Array[int] = []
	for x: int in pos[i].neighbors:
		for y: int in pos[x].neighbors:
			if y == i:
				pass
			elif nNeighbors.has(y):
				pass
			else:
				nNeighbors.append(y)
	return nNeighbors

class gridCell: # Data type for the grid cells
	var neighbors: Dictionary = {} # {int "position", String "Ingredient"} position and ingredient of neighbors
	var ingredient: String = "Nothing0" # ingredient saved as string because toString() budget ran out
	var line: int = -1 # vertical position
	var lpos: int = -1 # horizontal position
	var eigenValue: int = 0 # sum of surrounding ingredient levels
	var eigenIndicator: Array[String] = []
	var revealed: bool = false # is true once it's revealed
	var cell: Node2D = null # the scene for the gridCell
	var flagged: String = "" # stores the ingredient name of the flag
	#cell must have: root node called "cell", children label "hint", button "colour/button", sprite2d "ingredient"
	#sprite2d "indicator" with sprite2ds "indicatorHerb", "indicatorShroom" and "indicatorSalt" and area2d "magTurner"
	
	var sprIng: Sprite2D = null
	var hint: Label = null
	
	func initiate() -> void:
		hint = cell.get_node("hint")
		sprIng = cell.get_node("ingredient")
	
	func _to_string() -> String:
		return ingredient + " x: " + str(line) + " y: " + str(lpos) + " value: " + str(eigenValue)
	




