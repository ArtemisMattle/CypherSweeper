extends PanelContainer

var sizelvl: int
var empty: int = globalVariables.n

func _on_play_pressed():
	sizelvl = $edge/menu/arcade/arcade/sizeandplay/sizeSelector.value
	if $edge/menu/arcade/arcade/population/populationModes/high/highMode.pressed:
		for i in globalVariables.ingredientStack:
			globalVariables.ingredientStack[i] = 1
		globalVariables.ingredientMult = (globalVariables.n / 9) * 0.7
	elif $edge/menu/arcade/arcade/population/populationModes/medium/mediumMode.pressed:
		globalVariables.ingredientStack["Herb1"] = 3
		globalVariables.ingredientStack["Herb2"] = 2
		globalVariables.ingredientStack["Herb3"] = 1
		globalVariables.ingredientStack["Shroom1"] = 3
		globalVariables.ingredientStack["Shroom2"] = 2
		globalVariables.ingredientStack["Shroom3"] = 1
		globalVariables.ingredientStack["Salt1"] = 3
		globalVariables.ingredientStack["Salt2"] = 2
		globalVariables.ingredientStack["Salt3"] = 1
		globalVariables.ingredientMult = (globalVariables.n / 18) * 0.5
	elif $edge/menu/arcade/arcade/population/populationModes/low/lowMode.pressed:
		globalVariables.ingredientStack["Herb1"] = 5
		globalVariables.ingredientStack["Herb2"] = 3
		globalVariables.ingredientStack["Herb3"] = 1
		globalVariables.ingredientStack["Shroom1"] = 5
		globalVariables.ingredientStack["Shroom2"] = 3
		globalVariables.ingredientStack["Shroom3"] = 1
		globalVariables.ingredientStack["Salt1"] = 5
		globalVariables.ingredientStack["Salt2"] = 3
		globalVariables.ingredientStack["Salt3"] = 1
		globalVariables.ingredientMult = (globalVariables.n / 27) * 0.4

	for i in globalVariables.ingredientStack:
		empty -= globalVariables.ingredientStack[i] * globalVariables.ingredientMult

	if $edge/menu/arcade/arcade/difficulty/difficultyModes/extreme/extremeMode.pressed:
		globalVariables.lvlUP["Nothing"] = empty * 0.75
		globalVariables.lvlUP["2"] = globalVariables.ingredientStack["Herb1"] * globalVariables.ingredientMult * 0.75
		globalVariables.lvlUP["3"] = globalVariables.ingredientStack["Herb2"] * globalVariables.ingredientMult
		globalVariables.lvlUP["4"] = globalVariables.ingredientStack["Herb3"] * globalVariables.ingredientMult
	elif $edge/menu/arcade/arcade/difficulty/difficultyModes/normal/normalMode.pressed:
		globalVariables.lvlUP["Nothing"] = empty * 0.3
		globalVariables.lvlUP["2"] = globalVariables.ingredientStack["Herb1"] * globalVariables.ingredientMult * 0.3
		globalVariables.lvlUP["3"] = globalVariables.ingredientStack["Herb2"] * globalVariables.ingredientMult * 0.75
		globalVariables.lvlUP["4"] = globalVariables.ingredientStack["Herb3"] * globalVariables.ingredientMult
	
	get_tree().change_scene_to_file("res://scenes/lvl0.tscn")

