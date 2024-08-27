extends Node2D
var size: int
var l: int
var width: int
var hight: int
var ends: Array[int]
var pos: Array[gridCell] = []
var hex: PackedScene = preload("res://scenes/hex.tscn")
signal talkToNeighbor(ownpos: int, owningr: int, neighborpos:int)
var ingredientStack: Dictionary
var ingredientList: Dictionary = {}
var toBeRevealed: Array[int] = []
var openRevealers: Array[int] = []
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
@onready var tTimer: Timer = $turnTimer
@onready var tTune: AudioStreamPlayer = $turnSFX

enum sMode {normal, fast, zippy}

func _ready()-> void:
	rng.seed=globalVariables.rngseed
	
	size = globalVariables.size
	ingredientStack = globalVariables.ingredientStack.duplicate()
	
	for i: String in globalVariables.uncoveredIngred:
		globalVariables.uncoveredIngred[i] = 0
	globalVariables.uncovered = 0
	
	globalVariables.n = 1 - (3 * size) + (3 * (size * size))
	l = 2 * size - 1
	width = l * 48 + 100
	hight = l * 34 + 400
	$PanelContainer.size = Vector2i(width, hight)
	get_viewport()
	get_ends()
	def_hex()
	populate()
	signalBus.deactivate.connect(deactivate)

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
	if cell.line < ends.size()/2: # differentiates between the upper half and the lower half
		@warning_ignore("integer_division")
		cell.cell.translate(Vector2(cell.lpos*46-(cell.line-ends.size()/2)*23,cell.line*35))
	else:
		@warning_ignore("integer_division")
		cell.cell.translate(Vector2(cell.lpos*46+(cell.line-ends.size()/2)*23,cell.line*35))

func def_hex() -> void:# generates the gridcells with the position and their neigborhood
	var line: int = 0 # initiates the line counter
	for i: int in globalVariables.n:
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
		pos[i].cell.get_node("colour/button").pressed.connect(reveal.bind(i))
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
				var x: int = rng.randi_range(0, globalVariables.n-1)
				if pos[x].ingredient == "Nothing0":# empty cells only ;P
					pos[x].ingredient = i
					ingredientStack[i] -= 1
					ingredientList[x] = i
					pos[x].sprIng.texture = load("res://assets/textures/ingredients/"+pos[x].ingredient+".png")
			else:
				ingredientStack.erase(i)#removes empty ingredient slots for performance
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
		pos[i].hint.text = str(pos[i].eigenValue)
		var herb: Sprite2D = pos[i].cell.get_node("indicator/indicatorHerb")
		var shroom: Sprite2D = pos[i].cell.get_node("indicator/indicatorShroom")
		var salt: Sprite2D = pos[i].cell.get_node("indicator/indicatorSalt")
		herb.visible = "Herb" in pos[i].eigenIndicator
		shroom.visible = "Shroom" in pos[i].eigenIndicator
		salt.visible = "Salt" in pos[i].eigenIndicator

func magReveal(body: Node2D, i:int) -> void: # connects the Magnifyer to the reveal function
	if body.get_meta("enabled"):
		reveal(i)

func reveal(i:int) -> void: # reveals a gridCell
	if not pos[i].revealed: # checks if reveal is called on a revealed gridCell
		pos[i].revealed = true
		pos[i].cell.get_node("colour/button").queue_free()
		tTune.play() # plays a sound effect
		globalVariables.uncoveredIngred[pos[i].ingredient] += 1 # keeps track of uncovered ingredients (inclusive "Nothing0")
		globalVariables.uncovered += 1 # keeps track of uncovered tiles (to escape needing to sum up the dictionary)
		if globalVariables.uncovered == globalVariables.n - 1: # checks for if all but the flamel are uncovered
			signalBus.lvlFlamel.emit()
		if pos[i].ingredient == "Nothing0": # reduces workload by only looking at one half
			if globalVariables.uncovered == globalVariables.lvlUP["Nothing0"]:
				signalBus.lvlNothing.emit() # allows for undamaged uncovering of the first ingredients
		else:
			signalBus.uncoverIngr.emit(pos[i].ingredient) # sends the uncovered ingredient for damage calculation and similar
		if pos[i].eigenValue == 0: # checks for empty gridCells
			if settings.speedMode == sMode.normal: # checks for speedMode
				var revSoon: Array[int] = []
				for j: int in pos[i].neighbors:
					if not pos[j].revealed:
						revSoon.append(j)
				if not revSoon.is_empty():
					openRevealers.append(i)
					toBeRevealed.append(revSoon[randi_range(0, revSoon.size()-1)])
			else:
				for j: int in pos[i].neighbors:
					if not pos[j].revealed:
						toBeRevealed.append(j)
			tTimer.start() # starts the Timer to turn neighboring gridCells
		if pos[i].ingredient == "Nothing0":
			pos[i].hint.visible = true # shows the numeric hint if there is no ingredient
		else:
			pos[i].sprIng.visible = true # shows the ingredient otherwise
		pos[i].cell.get_node("indicator").visible = true # shows the indicators for neighboring ingredients

func _on_turn_timer_timeout() -> void: # reveals empty gridCells after time passed, look at func reveal
	tTimer.wait_time = 0.05 + randf_range(0.03, 0.08)
	var toBeRevealedLater: Array[int] = []
	for i: int in toBeRevealed:
		if not pos[i].revealed:
			pos[i].revealed = true
			pos[i].cell.get_node("colour/button").queue_free()
			tTune.play()
			globalVariables.uncoveredIngred[pos[i].ingredient] += 1
			globalVariables.uncovered += 1
			if globalVariables.uncovered == globalVariables.n - 1:
				signalBus.lvlFlamel.emit()
			if pos[i].ingredient == "Nothing0":
				if globalVariables.uncovered == globalVariables.lvlUP["Nothing0"]:
					signalBus.lvlNothing.emit()
			else:
				signalBus.uncoverIngr.emit(pos[i].ingredient)
			if pos[i].eigenValue == 0:
				match settings.speedMode:
					sMode.normal: # adds one unrevealed neighbor at random to be revealed later
						var revSoon: Array[int] = []
						for j: int in pos[i].neighbors:
							if not pos[j].revealed:
								revSoon.append(j)
						if not revSoon.is_empty():
							openRevealers.append(i)
							toBeRevealedLater.append(revSoon[randi_range(0, revSoon.size()-1)])
					sMode.fast: # adds all unrevealed neighbors to be revealed later
						tTimer.wait_time -= 0.05
						for j: int in pos[i].neighbors:
							if not pos[j].revealed:
								toBeRevealedLater.append(j)
					sMode.zippy: # adds all unrevealed neighbors to be revealed, like now
						for j: int in pos[i].neighbors:
							if not pos[j].revealed:
								toBeRevealed.append(j)
			if pos[i].ingredient == "Nothing0":
				pos[i].hint.visible = true # shows the numeric hint if there is no ingredient
			else:
				pos[i].sprIng.visible = true # shows the ingredient otherwise
			pos[i].cell.get_node("indicator").visible = true # shows the indicators for neighboring ingredients
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
	for i: int in globalVariables.n:
		if not pos[i].revealed:
			if r:
				pos[i].cell.get_node("colour/button").set("mouse_filter", 1)
			else:
				pos[i].cell.get_node("colour/button").set("mouse_filter", 2)

class gridCell: # Data type for the grid cells
	var neighbors: Dictionary = {} # {int "position", String "Ingredient"} position and ingredient of neighbors
	var ingredient: String = "Nothing0" # ingredient saved as string because toString() budget ran out
	var line: int = -1 # vertical position
	var lpos: int = -1 # horizontal position
	var eigenValue: int = 0 # sum of surrounding ingredient levels
	var eigenIndicator: Array[String] = []
	var revealed: bool = false # is true once it's revealed
	var cell: Node2D = null # the scene for the gridCell
	#cell must have: root node called "cell", children label "hint", button "colour/button", sprite2d "ingredient"
	#sprite2d "indicator" with sprite2ds "indicatorHerb", "indicatorShroom" and "indicatorSalt" and area2d "magTurner"
	
	var sprIng: Sprite2D = null
	var hint: Label = null
	
	func initiate() -> void:
		hint = cell.get_node("hint")
		sprIng = cell.get_node("ingredient")
	
	func _to_string() -> String:
		return ingredient + " x: " + str(line) + " y: " + str(lpos) + " value: " + str(eigenValue)
	


