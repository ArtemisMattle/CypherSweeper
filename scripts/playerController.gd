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
		"Shroom1":
			xp["Shroom"] += 1
			if globalVariables.level["Shroom"] < 1:
				globalVariables.sanity -= damage[1]
		"Salt1":
			xp["Salt"] += 1
			if globalVariables.level["Salt"] < 1:
				globalVariables.sanity -= damage[1]
		"Herb2":
			xp["Herb"] += 2
			if globalVariables.level["Herb"] < 2:
				globalVariables.sanity -= damage[2]
		"Shroom2":
			xp["Shroom"] += 2
			if globalVariables.level["Shroom"] < 2:
				globalVariables.sanity -= damage[2]
		"Salt2":
			xp["Salt"] += 2
			if globalVariables.level["Salt"] < 2:
				globalVariables.sanity -= damage[2]
		"Herb3":
			xp["Herb"] += 3
			if globalVariables.level["Herb"] < 3:
				globalVariables.sanity -= damage[3]
		"Shroom3":
			xp["Shroom"] += 3
			if globalVariables.level["Shroom"] < 3:
				globalVariables.sanity -= damage[3]
		"Salt3":
			xp["Salt"] += 3
			if globalVariables.level["Salt"] < 3:
				globalVariables.sanity -= damage[3]
		"Flamel":
			if globalVariables.level["Herb"] < 3 or globalVariables.level["Shroom"] < 3 or globalVariables.level["Salt"] < 3:
				globalVariables.sanity -= damage[6]
	if globalVariables.level["Shroom"] < 1:
		xp["Shroom"] += randi_range(0, 7) / 4
	if globalVariables.level["Salt"] < 1:
		xp["Salt"] += randi_range(0, 7) / 4
	if xp["Herb"] >= globalVariables.lvlUP[str(globalVariables.level["Herb"]+1)]:
		globalVariables.level["Herb"] += 1
		lvlUp("Herb")
	if xp["Shroom"] >= globalVariables.lvlUP[str(globalVariables.level["Shroom"]+1)]:
		globalVariables.level["Shroom"] += 1
		lvlUp("Shroom")
	if xp["Salt"] >= globalVariables.lvlUP[str(globalVariables.level["Salt"]+1)]:
		globalVariables.level["Salt"] += 1
		lvlUp("Salt")

func lvlUp(ingredient: String):
	pass
