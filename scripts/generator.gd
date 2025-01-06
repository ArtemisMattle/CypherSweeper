extends Node2D
var size: int
var n: int
var l: int
var width: int
var hight: int
@onready var background: TileMap = $background
var ends: Array[int]
var pos: Array[gridCell] = []
var hex: PackedScene = preload("res://scenes/hex.tscn")
var mode: String = "hexNormal"
@export var usage: String = "game"
var ingredientStack: Dictionary
var ingredientList: Dictionary = {}
var ingList: Dictionary = {}
var flags: Dictionary = {}
var toBeRevealed: Array[int] = []
var toBeRevealedLater: Array[int] = []
var openRevealers: Array[int] = []
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
@onready var tTimer: Timer = $turnTimer
@onready var fTimer: Timer = $flagTimer
@onready var cdTimer: Timer = $coolTimer
@onready var tTune: AudioStreamPlayer = $turnSFX
var fTool: PackedScene = preload("res://scenes/flagging.tscn")
var flagTool: Control = null
var flaggingActive: bool = true
var active: bool = true

enum sMode {normal, fast, zippy}

var beanfield:Array[int] = [];
@onready var bean = preload("res://scenes/bean.tscn")

var OF: bool = globalVariables.mod.has("OF")
var Diagonal: bool = globalVariables.mod.has("DL")

func _ready()-> void:
	#calculate coffee bean fields
	#var nbean=n/100*globalVariables.beancount;
	#for i in nbean:
		#beanfield.append(randi_range(i*n/(nbean+2),(i+1)*n/(nbean+2)));
		
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
			if Diagonal:
				var diag: Dictionary = {}
				for i: int in len(pos):
					diag[i] = diagonals(i)
				for i: int in len(pos):
					for j: int in diag[i]:
						pos[i].neighbors[j] = "Nothing0"
			for i: int in n:
				pos[i].cell.get_node("colour/button").disconnect("pressed",reveal)
				pos[i].cell.get_node("magTurner").body_entered.disconnect(magReveal.bind(i))
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
			if Diagonal:
				var diag: Dictionary = {}
				for i: int in len(pos):
					diag[i] = diagonals(i)
				for i: int in len(pos):
					for j: int in diag[i]:
						pos[i].neighbors[j] = "Nothing0"
			for i: int in n:
				pos[i].cell.get_node("colour/button").disconnect("pressed",reveal)
				pos[i].cell.get_node("magTurner").body_entered.disconnect(magReveal.bind(i))
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
	
	shapeshift()
	signalBus.modulate.connect(shapeshift)


func readyGame()-> void: # sets everything into motion for a normal round to start
	rng.seed=globalVariables.rngseed
	
	size = globalVariables.size
	n = globalVariables.n
	ingredientStack = globalVariables.ingredientStack.duplicate()
	
	for i: String in globalVariables.uncoveredIngred:
		globalVariables.uncoveredIngred[i] = 0
	globalVariables.uncovered = 0
	
	var tileCoords: Array[Vector2i] = [Vector2i(0, 0)] # background tiles
	for i: int in size+1:
		tileCoords.append(Vector2i( i+1, 0))
		tileCoords.append(Vector2i(-i-1, 0))
		tileCoords.append(Vector2i( 0, i+1))
		tileCoords.append(Vector2i( 0,-i-1))
		
		for j: int in size/2+1:
			tileCoords.append(Vector2i( j+1 , i+1))
			tileCoords.append(Vector2i(-j-1 ,-i-1))
			tileCoords.append(Vector2i(-j-1 , i+1))
			tileCoords.append(Vector2i( j+1 ,-i-1))
			
			tileCoords.append(Vector2i( size - i/2-j, i+1))
			tileCoords.append(Vector2i( size - i/2-j, -i-1))
			tileCoords.append(Vector2i( -size + i/2+j-1, i))
			tileCoords.append(Vector2i( -size + i/2+j-1, -i))
	
	background.set_cells_terrain_connect(0, tileCoords, 0, 0)
	
	l = 2 * size - 1
	'width = l * 48 + 100
	hight = l * 34 + 400
	$PanelContainer.size = Vector2i(width, hight)
	$PanelContainer.set_position(Vector2(-width/2, -hight/2))
	$PanelContainer.visible = false'
	get_viewport()
	get_ends()
	def_hex()
	
	if Diagonal:
		var diag: Dictionary = {}
		for i: int in len(pos):
			diag[i] = diagonals(i)
		for i: int in len(pos):
			for j: int in diag[i]:
				pos[i].neighbors[j] = "Nothing0"
	
	signalBus.populated.emit()
	populate()
	signalBus.deactivate.connect(deactivate)
	signalBus.getRandomUnrevealed.connect(getUnrevealedIngredient)
	signalBus.freeze.connect(freeze)

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
		cell.cell.translate(Vector2(cell.lpos*48-int(cell.line-l/2)*24-size*48+48, (cell.line-size)*36+36))
	else:
		@warning_ignore("integer_division")
		cell.cell.translate(Vector2(cell.lpos*48+int(cell.line-l/2)*24-size*48+48, (cell.line-size)*36+36))


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
		pos[i].cell.get_node("colour/button").pressed.connect(reveal.bind(i, 0))
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

func diagonals(p: int) -> Array[int]:
	var n: Array[int] = []
	var m: Array[int] = []
	for i: int in pos[p].neighbors:
		var nei: Array = Array(pos[i].neighbors.keys())
		for j: int in nei:
			if j == p or pos[p].neighbors.has(j):
				continue
			if pos[i].neighbors[j] == "Nothing0":
				if m.has(j):
					n.append(j)
				m.append(j)
	return n

func populate() -> void:# generates the ingredients
	var x: int = rng.randi_range(0, n-1)
	pos[x].ingredient = "Flamel5"
	ingredientList[x] = "Flamel5"
	pos[x].sprIng.texture = load("res://assets/textures/ingredients/Flamel5.png")
	while not ingredientStack.is_empty():
		for i: String in ingredientStack:# ingredientstack is defined for consistent amounts of ingredients
			if ingredientStack[i] != 0:# seeded random placement of ingredients in empty hexes
				x = rng.randi_range(0, n-1)
				if pos[x].ingredient == "Nothing0":# empty cells only ;P
					if globalVariables.mod.has("OF"):
						pos[x].ingredient = "Flamel5"
						ingredientStack[i] -= 1
						ingredientList[x] = "Flamel5"
						pos[x].sprIng.texture = load("res://assets/textures/ingredients/Flamel5.png")
					else:
						pos[x].ingredient = i
						ingredientStack[i] -= 1
						ingredientList[x] = i
						pos[x].sprIng.texture = load("res://assets/textures/ingredients/"+pos[x].ingredient+".png")
			else:
				ingredientStack.erase(i)#removes empty ingredient slots for performance
	ingList = ingredientList.duplicate()
	for y: String in globalVariables.specials:
		var i: int = 0
		while i < globalVariables.specials[y]:
			x = rng.randi_range(0, n-1)
			if pos[x].ingredient == "Flamel5":
				continue
			pos[x].special = y
			i += 1
	for i: int in ingredientList:
		updateNeighbors(i)

func updateNeighbors(gCell: int) -> void: # takes in a a gridCell position and tells all neighbors about it's ingredient
	for i: int in pos[gCell].neighbors:
		pos[i].neighbors[gCell] = pos[gCell].ingredient
		pos[i].eigenValue = 0
		pos[i].eigenIndicator = []
		for j: int in pos[i].neighbors:
			if globalVariables.mod.has("OF"):
				pos[i].eigenValue += pos[j].ingredient.to_int() / 5
			else:
				pos[i].eigenValue += pos[j].ingredient.right(1).to_int()
				pos[i].eigenIndicator.append(pos[j].ingredient.left(-1))
		if pos[i].eigenValue > 0:
			var lie: Array[int] = [0]
			if globalVariables.mod.has("BS"):
				lie = [-1,1]
			pos[i].hint.text = str(pos[i].eigenValue + lie.pick_random())
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
	if event is InputEventMouseButton:
		match event.button_index:
			#MOUSE_BUTTON_LEFT:
			#	if event.is_pressed():
			#		reveal(i, 0)
			MOUSE_BUTTON_RIGHT:
				if event.is_released():
					flag(i)

func flag(i: int) -> void: # flaggs cells
	if not active:
		return
	active = false
	var flag: Sprite2D = pos[i].cell.get_node("flag")
	if pos[i].flagged == "":
		if OF:
			flag.texture = load("res://assets/textures/ingredients/flags/Flamel.png")
			pos[i].flagged = "Flamel"
			flags[i] = {"flag": "Flamel", "visible": true, "right": pos[i].ingredient == "Flamel"}
			active = true
			return
		flagTool = fTool.instantiate()
		add_child(flagTool)
		flagTool.set_position(pos[i].cell.position)
		signalBus.flagging.connect(flagFinish.bind(i))
	else:
		pos[i].flagged = ""
		if flags[i]["right"]:
			flags[i]["visible"] = false
		else:
			flags.erase(i)
		flag.texture = null
		active = true

func flagFinish(flag: String, i: int) -> void:
	pos[i].flagged = flag
	pos[i].cell.get_node("flag").texture = load("res://assets/textures/ingredients/flags/" + flag + ".png")
	fTimer.start()
	signalBus.flagging.disconnect(flagFinish)
	flagTool.queue_free()
	var preExist: bool = flags.has(i)
	flags[i] = {"flag": flag, "visible": true, "right": pos[i].ingredient == flag}
	if not preExist:
		if flags[i]["right"]:
			globalVariables.xp[flag.left(-1)] += globalVariables.xpFlagBoon

func _on_flag_timer_timeout() -> void:
	active = true

func magReveal(body: Node2D, i:int) -> void: # connects the Magnifyer to the reveal function
	if body.get_parent().get_parent().get_meta("enabled"):
		match body.get_meta("mode"):
			1:
				reveal(i, 2)
			2:
				if pos[i].flagged != "":
					reveal(i, 2)
			3:
				if pos[i].ingredient == "Nothing0":
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
			elif pos[i].flagged == "Flamel":
				pass
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
		#if randi_range(0,100)<=globalVariables.beanCount:
			#print_debug("BEAN!")
			#var newbean=bean.instantiate()
			#add_child(newbean)
			#
			
			
		if globalVariables.uncovered == n - 1: # checks for if all but the flamel are uncovered
			signalBus.lvlFlamel.emit()
		
		if pos[i].ingredient == "Nothing0": # reduces workload by only looking at relevant cells
			if globalVariables.mod.has("OF"):
				if globalVariables.uncovered == globalVariables.empty-1:
					signalBus.lvlFlamel.emit()
			elif globalVariables.uncovered == globalVariables.lvlNothing:
				signalBus.lvlNothing.emit() # allows for undamaged uncovering of the first ingredients
		else:
			ingList.erase(i)
			signalBus.uncoverIngr.emit(pos[i].ingredient, not ingList.values().has(pos[i].ingredient)) # sends the uncovered ingredient for damage calculation and similar
		
		if pos[i].special == "coffee":
			pos[i].cell.get_node("colour/button").texture_normal = null
			pos[i].cell.get_node("colour/button").texture_focused = null
			pos[i].cell.get_node("colour/button").texture_hover = null
			pos[i].cell.get_node("flag").texture = load("res://assets/textures/ingredients/Coffeebean02.png")
			pos[i].cell.get_node("colour/button").disconnect("gui_input", buttonForwarding)
			pos[i].cell.get_node("colour/button").disconnect("pressed", reveal)
			signalBus.expresso.emit(pos[i].cell.get_node("colour/button").pressed)
			pos[i].cell.get_node("colour/button").pressed.connect(del.bind(i))
		else:
			pos[i].cell.get_node("colour/button").queue_free()
		pos[i].cell.get_node("colour/backshadow").queue_free()
		tTune.play() # plays a sound effect
		
		
		
		# chain revealing / cascading stuff
		if m != 2:
			if pos[i].eigenValue == 0: # checks for empty gridCells
				var revealer: Array[int] = []
				if settings.speedMode == sMode.normal: # checks for speedMode
					var revSoon: Array[int] = []
					for j: int in pos[i].neighbors:
						if not pos[j].revealed:
							revSoon.append(j)
					if not revSoon.is_empty():
						openRevealers.append(i)
						revealer.append(revSoon[randi_range(0, revSoon.size()-1)])
				else:
					for j: int in pos[i].neighbors:
						if not pos[j].revealed:
							revealer.append(j)
				match m:
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

func del(i: int) -> void:
	pos[i].cell.get_node("flag").texture = null
	pos[i].cell.get_node("colour/button").queue_free()

func deactivate(r: bool) -> void: # deactivates all interactivity with the map
	active = r
	for i: int in n:
		if not pos[i].revealed:
			if r:
				pos[i].cell.get_node("colour/button").set("mouse_filter", 1)
			else:
				pos[i].cell.get_node("colour/button").set("mouse_filter", 2)

func getUnrevealedIngredient() -> void: # emits a signal with a position and an ingredient
	var p: int
	
	for i: int in 100: # trys to find an unflagged ingredient
		p = ingList.keys().pick_random()
		if pos[p].flagged == "":
			break
	if globalVariables.hintFlagging:
		pos[p].flagged = pos[p].ingredient
		pos[p].cell.get_node("flag").texture = load("res://assets/textures/ingredients/flags/" + pos[p].ingredient + ".png")
		flags[p] = {"flag": flag, "visible": true, "right": true}
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

func shapeshift() -> void: # changes the colours
	for i: int in len(pos):
		pos[i].cell.get_node("hex").modulate = globalVariables.colours[2]
		pos[i].cell.get_node("colour").modulate = globalVariables.colours[1]
	if $background.visible:
		$background.modulate = globalVariables.colours[0]

func freeze() -> void: #sets active false and starts a cooldown to reactivate4
	print("ice")
	cdTimer.start()
	active = false

func mariahCarey() -> void:
	print("baby")
	active = true

class gridCell: # Data type for the grid cells
	var neighbors: Dictionary = {} # {int "position", String "Ingredient"} position and ingredient of neighbors
	var ingredient: String = "Nothing0" # ingredient saved as string because toString() budget ran out
	var special: String = "" # string for special things like coffee beans
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
	




