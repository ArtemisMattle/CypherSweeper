extends Node

var damage: Array[int] = [1, 7, 13, 21, 30, 50, 101]
var xp: Dictionary = {"Herb" = 0, "Shroom" = 0, "Salt" = 0}
var iniSan

func _ready():
	signalBus.lvlNothing.connect(lvl1)
	signalBus.uncoverIngr.connect(uncover)
	signalBus.lvlFlamel.connect(Flamel)
	iniSan=globalVariables.sanity
	$gameOver/centerer/gameOver/end.text = "Game Over!"

func lvl1():
	globalVariables.level["Herb"] = 1
	xp["Herb"] = globalVariables.lvlUP["1"]
	lvlUpHerb()
	signalBus.turnSound.connect(turnSFX)
	signalBus.upsane.connect(dead)

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
			if globalVariables.uncovered < globalVariables.n - 1:
				globalVariables.sanity -= damage[6]
				signalBus.upsane.emit()
			else:
				$gameOver/centerer/gameOver/end.text = "You Won!"
				$gameOver.visible = true
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

func Flamel():
	$playerInfo/edge/HBoxContainer/flamel.texture = load("res://assets/textures/ingredients/Flamel.png")


func _on_pause_button_toggled(toggled_on: bool) -> void:
	$pauseMenu.visible = toggled_on

func _on_settings_pressed() -> void:
	$pauseMenu/centerer/settings.visible = true
	$pauseMenu/centerer/pause.visible = false

func _on_return_button_pressed() -> void:
	$pauseMenu/centerer/pause.visible = true
	$pauseMenu/centerer/settings.visible = false

func _on_masterMute_toggled(toggled_on: bool) -> void:
	settings.masterMute = not toggled_on
	$background/edge/menu/volume/audioMaster/volume.editable = not toggled_on

func _on_soundMute_toggled(toggled_on: bool) -> void:
	settings.soundMute = not toggled_on
	$background/edge/menu/volume/audioSFX/volume.editable = not toggled_on

func _on_musicMute_toggled(toggled_on: bool) -> void:
	settings.musicMute = not toggled_on
	$background/edge/menu/volume/audioMusic/volume.editable = not toggled_on

func _on_colourblind_mode_toggled(toggled_on):
	settings.colourblindMode = toggled_on
	signalBus.colourchange.emit()

enum sMode {normal, fast, zippy}
func _on_zippy_mode_pressed() -> void:
	settings.speedMode = sMode.zippy

func _on_fast_mode_pressed() -> void:
	settings.speedMode = sMode.fast

func _on_normal_mode_pressed() -> void:
	settings.speedMode = sMode.normal

func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

func dead():
	var t = $music.get_playback_position()
	match globalVariables.sanity / 10:
		9: $music.stream = load("res://assets/audio/music/level/Main Game Sanity 100 - 90.wav")
		8: $music.stream = load("res://assets/audio/music/level/Main Game Sanity 89 - 80.wav")
		7: $music.stream = load("res://assets/audio/music/level/Main Game Sanity 79 - 70.wav")
		6: $music.stream = load("res://assets/audio/music/level/Main Game Sanity 69 - 60.wav")
		5: $music.stream = load("res://assets/audio/music/level/Main Game Sanity 59 - 50.wav")
		4: $music.stream = load("res://assets/audio/music/level/Main Game Sanity 49 - 40.wav")
		3: $music.stream = load("res://assets/audio/music/level/Main Game Sanity 39 - 30.wav")
		2: $music.stream = load("res://assets/audio/music/level/Main Game Sanity 29 - 20.wav")
		1: $music.stream = load("res://assets/audio/music/level/Main Game Sanity 19 - 10.wav")
		0: $music.stream = load("res://assets/audio/music/level/Main Game Sanity 9 - 0.wav")
	$music.play(t)
	if globalVariables.sanity <= 0:
				$gameOver.visible = true


func _on_return_pressed():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

func turnSFX():
	$turnSFX.play()
