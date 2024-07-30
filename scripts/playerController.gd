extends Node

var damage: Array[int] = [1, 7, 13, 21, 30, 50, 101]
var xp: Dictionary = {"Herb" = 0, "Shroom" = 0, "Salt" = 0}

func _ready():
	signalBus.lvlNothing.connect(lvl1)
	signalBus.uncoverIngr.connect(uncover)

func lvl1():
	globalVariables.level["Herb"] = 1

func uncover(ingredient: String):
	match ingredient:
		"Herb1":
			xp["Herb"] += 1
			if globalVariables.level["Herb"] < 1:
				globalVariables.sanity -= damage[1]
				signalBus.upsane.emit()
		"Shroom1":
			xp["Shroom"] += 1
			if globalVariables.level["Shroom"] < 1:
				globalVariables.sanity -= damage[1]
				signalBus.upsane.emit()
		"Salt1":
			xp["Salt"] += 1
			if globalVariables.level["Salt"] < 1:
				globalVariables.sanity -= damage[1]
				signalBus.upsane.emit()
		"Herb2":
			xp["Herb"] += 2
			if globalVariables.level["Herb"] < 2:
				globalVariables.sanity -= damage[2]
				signalBus.upsane.emit()
		"Shroom2":
			xp["Shroom"] += 2
			if globalVariables.level["Shroom"] < 2:
				globalVariables.sanity -= damage[2]
				signalBus.upsane.emit()
		"Salt2":
			xp["Salt"] += 2
			if globalVariables.level["Salt"] < 2:
				globalVariables.sanity -= damage[2]
				signalBus.upsane.emit()
		"Herb3":
			xp["Herb"] += 3
			if globalVariables.level["Herb"] < 3:
				globalVariables.sanity -= damage[3]
				signalBus.upsane.emit()
		"Shroom3":
			xp["Shroom"] += 3
			if globalVariables.level["Shroom"] < 3:
				globalVariables.sanity -= damage[3]
				signalBus.upsane.emit()
		"Salt3":
			xp["Salt"] += 3
			if globalVariables.level["Salt"] < 3:
				globalVariables.sanity -= damage[3]
				signalBus.upsane.emit()
		"Flamel":
			if globalVariables.level["Herb"] < 3 or globalVariables.level["Shroom"] < 3 or globalVariables.level["Salt"] < 3:
				globalVariables.sanity -= damage[6]
				signalBus.upsane.emit()
	if globalVariables.level["Shroom"] < 1:
		xp["Shroom"] += randi_range(0, 7) / 4
	if globalVariables.level["Salt"] < 1:
		xp["Salt"] += randi_range(0, 7) / 4
	if xp["Herb"] >= globalVariables.lvlUP[str(globalVariables.level["Herb"]+1)]:
		globalVariables.level["Herb"] += 1
		lvlUpHerb()
	if xp["Shroom"] >= globalVariables.lvlUP[str(globalVariables.level["Shroom"]+1)]:
		globalVariables.level["Shroom"] += 1
		lvlUpShroom()
	if xp["Salt"] >= globalVariables.lvlUP[str(globalVariables.level["Salt"]+1)]:
		globalVariables.level["Salt"] += 1
		lvlUpSalt()

func lvlUpHerb():
	$playerInfo/edge/HBoxContainer/VBoxContainer/herb/herb.texture = load("res://assets/textures/ingredients/Herb"+str(globalVariables.level["Herb"])+".png")
	$playerInfo/edge/HBoxContainer/VBoxContainer/herb/number.text = str(globalVariables.level["Herb"])

func lvlUpShroom():
	$playerInfo/edge/HBoxContainer/VBoxContainer/shroom/shroom.texture = load("res://assets/textures/ingredients/Shroom"+str(globalVariables.level["Shroom"])+".png")
	$playerInfo/edge/HBoxContainer/VBoxContainer/shroom/number.text = str(globalVariables.level["Shroom"])

func lvlUpSalt():
	$playerInfo/edge/HBoxContainer/VBoxContainer2/salt/salt.texture = load("res://assets/textures/ingredients/Salt"+str(globalVariables.level["Salt"])+".png")
	$playerInfo/edge/HBoxContainer/VBoxContainer2/salt/number.text = str(globalVariables.level["Salt"])
	
func lvlUpShadow():
	$playerInfo/edge/HBoxContainer/VBoxContainer2/shadow/shadow.texture = load("res://assets/textures/ingredients/Herb"+str(globalVariables.level["Shadow"])+".png")
	$playerInfo/edge/HBoxContainer/VBoxContainer2/shadow/number.text = str(globalVariables.level["Shadow"])
