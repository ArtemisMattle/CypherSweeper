extends PanelContainer

var sizelvl: int


func _on_play_pressed():
	sizelvl = $edge/menu/arcade/arcade/sizeandplay/sizeSelector.value
	if $edge/menu/arcade/arcade/population/populationModes/high/highMode.pressed:
		for i in globalVariables.ingredientStack:
			globalVariables.ingredientStack[i] = 1
		globalVariables.ingredientMult = (globalVariables.n / 9) * 0.7
	elif $edge/menu/arcade/arcade/population/populationModes/medium/mediumMode.pressed:
		pass
	elif $edge/menu/arcade/arcade/population/populationModes/low/lowMode.pressed:
		pass
	
	if $edge/menu/arcade/arcade/difficulty/difficultyModes/extreme/extremeMode.pressed:
		pass
	elif $edge/menu/arcade/arcade/difficulty/difficultyModes/normal/normalMode.pressed:
		pass

