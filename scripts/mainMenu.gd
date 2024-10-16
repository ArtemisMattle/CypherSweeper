extends Node2D


func _ready() -> void:
	$background/edge/menu/settings/settings/language/languageSelector.get_popup().get_viewport().transparent_bg = true

func _on_play_story_pressed() -> void:
	match $background/edge/menu/mainbuttons/playStory.text:
		"Play Story":
			closeTitle()
			closeCredits()
			closeSetting()
			closeArcade()
			openLvlSelect()
			$background/edge/menu/mainbuttons/playStory.text="Exit"
		"Exit":
			openTitle()
			closeCredits()
			closeSetting()
			closeLvlSelect()
		
	#get_tree().change_scene_to_file("res://scenes/lvl0.tscn")

func _on_settings_pressed() -> void:
	match $background/edge/menu/mainbuttons/Settings.text:
		"Settings":
			$background/edge/menu/mainbuttons/Settings.text = "Exit"
			closeTitle()
			closeCredits()
			closeLvlSelect()
			closeArcade()
			openSetting()
		"Exit":
			closeSetting()
			openTitle()

func _on_credits_pressed() -> void:
	match $background/edge/menu/mainbuttons/Credits.text:
		"Credits":
			$background/edge/menu/mainbuttons/Credits.text = "Exit"
			closeTitle()
			closeSetting()
			closeLvlSelect()
			closeArcade()
			openCredits()
		"Exit":
			closeCredits()
			openTitle()

func _on_play_arcade_pressed():
	match $background/edge/menu/mainbuttons/playArcade.text:
		"Play Arcade":
			$background/edge/menu/mainbuttons/playArcade.text = "Exit"
			closeTitle()
			closeSetting()
			closeLvlSelect()
			closeCredits()
			openArcade()
		"Exit":
			closeArcade()
			openTitle()

func closeTitle():
	$background/edge/menu/title.visible = false

func openTitle():
	$background/edge/menu/title.visible = true

func closeLvlSelect():
	$background/edge/menu/levelSelect.visible=false
	$background/edge/menu/mainbuttons/playStory.text="Play Story"

func openLvlSelect():
	$background/edge/menu/levelSelect.visible=true

func closeSetting():
	$background/edge/menu/settings.visible = false
	$background/edge/menu/mainbuttons/Settings.text = "Settings"

func openSetting():
	$background/edge/menu/settings.visible = true

func closeCredits():
	$background/edge/menu/credits.visible = false
	$background/edge/menu/mainbuttons/Credits.text = "Credits"

func openCredits():
	$background/edge/menu/credits.visible = true

func closeArcade():
	$background/edge/menu/mainbuttons/playArcade.text = "Play Arcade"
	$background/edge/menu/arcade.visible = false

func openArcade():
	$background/edge/menu/arcade.visible = true

func _on_colourblind_mode_toggled(toggled_on):
	settings.colourblindMode = toggled_on

enum sMode {normal, fast, zippy}
func _on_zippy_mode_pressed() -> void:
	settings.speedMode = sMode.zippy

func _on_fast_mode_pressed() -> void:
	settings.speedMode = sMode.fast

func _on_normal_mode_pressed() -> void:
	settings.speedMode = sMode.normal

var empty: int

func _lvl1() -> void:
	_startLvl((1))
func _lvl2() -> void:
	_startLvl((2))
func _lvl3() -> void:
	_startLvl((3))
func _lvl4() -> void:
	_startLvl((4))
func _lvl5() -> void:
	_startLvl((5))
func _lvl6() -> void:
	_startLvl((6))
func _lvl7() -> void:
	_startLvl(7)
func _lvl8() -> void:
	_startLvl(8)
func _lvl9() -> void:
	_startLvl(9)
func _startLvl(level) -> void:
	match level:
		1:
			for i in globalVariables.ingredientStack:
				globalVariables.ingredientStack[i]=0
			globalVariables.ingredientStack["Herb1"]=3
			globalVariables.ingredientStack["Flamel"]=1

			globalVariables.size=4
		2:
			for i in globalVariables.ingredientStack:
				globalVariables.ingredientStack[i]=0
			globalVariables.ingredientStack["Herb1"]=6
			globalVariables.ingredientStack["Herb2"]=1
			globalVariables.ingredientStack["Flamel"]=1
			globalVariables.size=5
		3:
			for i in globalVariables.ingredientStack:
				globalVariables.ingredientStack[i]=0
			globalVariables.ingredientStack["Herb1"]=6
			globalVariables.ingredientStack["Herb2"]=2
			globalVariables.ingredientStack["Shroom1"]=3
			globalVariables.ingredientStack["Flamel"]=1
			globalVariables.size=6
		4:
			for i in globalVariables.ingredientStack:
				globalVariables.ingredientStack[i]=0
			globalVariables.ingredientStack["Herb1"]=6
			globalVariables.ingredientStack["Herb2"]=4
			globalVariables.ingredientStack["Herb3"]=1
			globalVariables.ingredientStack["Shroom1"]=5
			globalVariables.ingredientStack["Flamel"]=1
			globalVariables.size=6
		5:
			for i in globalVariables.ingredientStack:
				globalVariables.ingredientStack[i]=0
			globalVariables.ingredientStack["Herb1"]=6
			globalVariables.ingredientStack["Herb2"]=4
			globalVariables.ingredientStack["Herb3"]=1
			globalVariables.ingredientStack["Shroom1"]=5
			globalVariables.ingredientStack["Salt1"]=3
			globalVariables.ingredientStack["Flamel"]=1
			globalVariables.size=7
		6:
			for i in globalVariables.ingredientStack:
				globalVariables.ingredientStack[i]=0
			globalVariables.ingredientStack["Herb1"]=6
			globalVariables.ingredientStack["Herb2"]=4
			globalVariables.ingredientStack["Herb3"]=1
			globalVariables.ingredientStack["Shroom1"]=5
			globalVariables.ingredientStack["Shroom2"]=2
			globalVariables.ingredientStack["Salt1"]=5
			globalVariables.ingredientStack["Salt2"]=2
			globalVariables.ingredientStack["Flamel"]=1
			globalVariables.size=8
		7:
			for i in globalVariables.ingredientStack:
				globalVariables.ingredientStack[i]=0
			globalVariables.ingredientMult=1
			globalVariables.ingredientStack["Herb1"]=10
			globalVariables.ingredientStack["Herb2"]=2
			globalVariables.ingredientStack["Herb3"]=1
			globalVariables.ingredientStack["Shroom1"]=10
			globalVariables.ingredientStack["Shroom2"]=2
			globalVariables.ingredientStack["Shroom3"]=1
			globalVariables.ingredientStack["Salt1"]=6
			globalVariables.ingredientStack["Salt2"]=2
			globalVariables.ingredientStack["Salt3"]=0
			globalVariables.ingredientStack["Flamel"]=1
			globalVariables.size=10
		8:
			for i in globalVariables.ingredientStack:
				globalVariables.ingredientStack[i]=0
			globalVariables.ingredientMult=1
			globalVariables.ingredientStack["Herb1"]=16
			globalVariables.ingredientStack["Herb2"]=3
			globalVariables.ingredientStack["Herb3"]=1
			globalVariables.ingredientStack["Shroom1"]=16
			globalVariables.ingredientStack["Shroom2"]=3
			globalVariables.ingredientStack["Shroom3"]=1
			globalVariables.ingredientStack["Salt1"]=16
			globalVariables.ingredientStack["Salt2"]=3
			globalVariables.ingredientStack["Salt3"]=1
			globalVariables.ingredientStack["Flamel"]=1
			globalVariables.size=13
		9:
			for i in globalVariables.ingredientStack:
				globalVariables.ingredientStack[i]=0
			globalVariables.ingredientMult=2
			globalVariables.ingredientStack["Herb1"]=13
			globalVariables.ingredientStack["Herb2"]=5
			globalVariables.ingredientStack["Herb3"]=1
			globalVariables.ingredientStack["Shroom1"]=13
			globalVariables.ingredientStack["Shroom2"]=5
			globalVariables.ingredientStack["Shroom3"]=1
			globalVariables.ingredientStack["Salt1"]=13
			globalVariables.ingredientStack["Salt2"]=5
			globalVariables.ingredientStack["Salt3"]=1
			globalVariables.ingredientStack["Flamel"]=1
			globalVariables.size=15
		_: 
			pass
	
	globalVariables.n = 1 - (3 * globalVariables.size) + (3 * (globalVariables.size * globalVariables.size))
	empty=globalVariables.n
	for i in globalVariables.ingredientStack:
		empty -= globalVariables.ingredientStack[i] * globalVariables.ingredientMult
		
	globalVariables.lvlUP["Nothing"] = int(empty * 0.1)
	globalVariables.lvlUP["1"] = int(empty * 0.1)
	globalVariables.lvlUP["2"] = int(globalVariables.ingredientStack["Herb1"] * globalVariables.ingredientMult * 0.3)
	globalVariables.lvlUP["3"] = int(globalVariables.ingredientStack["Herb2"] * globalVariables.ingredientMult * 0.75)
	globalVariables.lvlUP["4"] = int(globalVariables.ingredientStack["Herb3"] * globalVariables.ingredientMult)
	print(globalVariables.lvlUP)
	get_tree().change_scene_to_file("res://scenes/lvl0.tscn")

func _on_arcade_pressed():
	globalVariables.scoreMult = 1
	globalVariables.size = $background/edge/menu/arcade/arcade/sizeandplay/sizeSelector.value
	globalVariables.n = 1 - (3 * globalVariables.size) + (3 * (globalVariables.size * globalVariables.size))
	globalVariables.sanity = 100
	signalBus.upsane.emit()
	for i in globalVariables.level:
		globalVariables.level[i] = 0
	empty = globalVariables.n
	var startIngr = ["Herb", "Shroom", "Salt"]
	globalVariables.lvl1 = startIngr.pick_random()
	
	if $background/edge/menu/arcade/arcade/population/populationModes/high/highMode.button_pressed:
		for i in globalVariables.ingredientStack:
			globalVariables.ingredientStack[i] = 1
		globalVariables.ingredientMult = (globalVariables.n / 9) * 0.5
	elif $background/edge/menu/arcade/arcade/population/populationModes/medium/mediumMode.button_pressed:
		globalVariables.ingredientStack["Herb1"] = 3
		globalVariables.ingredientStack["Herb2"] = 2
		globalVariables.ingredientStack["Herb3"] = 1
		globalVariables.ingredientStack["Shroom1"] = 3
		globalVariables.ingredientStack["Shroom2"] = 2
		globalVariables.ingredientStack["Shroom3"] = 1
		globalVariables.ingredientStack["Salt1"] = 3
		globalVariables.ingredientStack["Salt2"] = 2
		globalVariables.ingredientStack["Salt3"] = 1
		globalVariables.ingredientStack["Flamel"] = 1
		globalVariables.ingredientMult = (globalVariables.n / 18) * 0.35
	elif $background/edge/menu/arcade/arcade/population/populationModes/low/lowMode.button_pressed:
		globalVariables.ingredientStack["Herb1"] = 5
		globalVariables.ingredientStack["Herb2"] = 3
		globalVariables.ingredientStack["Herb3"] = 1
		globalVariables.ingredientStack["Shroom1"] = 5
		globalVariables.ingredientStack["Shroom2"] = 3
		globalVariables.ingredientStack["Shroom3"] = 1
		globalVariables.ingredientStack["Salt1"] = 5
		globalVariables.ingredientStack["Salt2"] = 3
		globalVariables.ingredientStack["Salt3"] = 1
		globalVariables.ingredientStack["Flamel"] = 1
		globalVariables.ingredientMult = (globalVariables.n / 27) * 0.25
	
	for i in globalVariables.ingredientStack:
		if i != "Flamel":
			globalVariables.ingredientStack[i] = int(globalVariables.ingredientStack[i] * globalVariables.ingredientMult)
		empty -= globalVariables.ingredientStack[i]
	
	if $background/edge/menu/arcade/arcade/difficulty/difficultyModes/extreme/extremeMode.button_pressed:
		globalVariables.lvlUP["Nothing"] = int(empty * 0.5)
		globalVariables.lvlUP["1"] = clamp(int(globalVariables.ingredientStack["Herb1"] * 0.4), 1, 9999)
		globalVariables.lvlUP["2"] = clamp(int(globalVariables.ingredientStack["Herb1"] * 1), globalVariables.lvlUP["1"] + 1, 9999)
		globalVariables.lvlUP["3"] = clamp(int(globalVariables.ingredientStack["Herb2"] * 3), globalVariables.lvlUP["2"] + 1, 9999)
		globalVariables.scoreMult *= 5
	elif $background/edge/menu/arcade/arcade/difficulty/difficultyModes/normal/normalMode.button_pressed:
		globalVariables.lvlUP["Nothing"] = int(empty * 0.2)
		globalVariables.lvlUP["1"] = clamp(int(globalVariables.ingredientStack["Herb1"] * 0.1), 1, 9999)
		globalVariables.lvlUP["2"] = clamp(int(globalVariables.ingredientStack["Herb1"] * 0.6), globalVariables.lvlUP["1"] + 1, 9999)
		globalVariables.lvlUP["3"] = clamp(int(globalVariables.ingredientStack["Herb2"] * 3), globalVariables.lvlUP["2"] + 1, 9999)
	get_tree().change_scene_to_file("res://scenes/lvl0.tscn")
