extends Node

var damage: Array[int] = [1, 7, 13, 21, 30, 50, 101]
var xp: Dictionary = {"Herb" = 0, "Shroom" = 0, "Salt" = 0}
var iniSan: int
#@onready var bB=$"../../buttonBlocker"

func _ready() -> void:
	signalBus.lvlNothing.connect(lvl1)
	signalBus.uncoverIngr.connect(uncover)
	signalBus.lvlFlamel.connect(Flamel)
	signalBus.upsane.connect(dead)
	iniSan=globalVariables.sanity
	
	#pause button setup
	globalVariables.paused = false
	$pause/centerer/stacker/pauseButton.disabled=false
	$pause.visible=true
	#bB.visible=false
	

func lvl1() -> void:
	if globalVariables.level[globalVariables.lvl1] < 1:
		globalVariables.level[globalVariables.lvl1] = 1
		xp[globalVariables.lvl1] = globalVariables.lvlUP["1"]
		lvlUp(globalVariables.lvl1)

func uncovere(ingredient: String) -> void: #workhorse function, determines what ingredient was uncovered and what should be done about it
	if ingredient == "Flamel5":
		if globalVariables.uncovered < globalVariables.n:
			takeDamage(6, true, false)
		else:
			endGame(true)
	else:
		xp[ingredient.left(-1)] += ingredient.right(1).to_int()
		if globalVariables.level[ingredient.left(-1)] < ingredient.right(1).to_int():
			takeDamage(ingredient.right(1).to_int(), true, true)

func takeDamage(level: int, counts: bool, modifyable: bool) -> void: #modifies the sanity when making mistakes, level determines severity & counts determines if it affects score
	if counts:
		globalVariables.lostsanity += damage[level]
	globalVariables.sanity = clampi(globalVariables.sanity - damage[level], 0, 100)
	
	if globalVariables.sanity == 0:
		endGame(false)

func endGame(win: bool) -> void: #TODO gets called when the game is done, handles everything after the last 'ingredient'
	globalVariables.paused = true
	signalBus.deactivate.emit(false)
	if win:
		globalVariables.scoreMult *= 3
	var score: int = score()

func score() -> int: #TODO calculates the score
	var time: float = $timer.t
	var s: float = 0
	if globalVariables.lostsanity == 0:
		globalVariables.scoreMult *= sqrt(2)
	globalVariables.scoreMult *= clamp(exp(-time * log(2) / (globalVariables.size * globalVariables.size)) * 2 + 1, 1.0, 2.0)
	for i: int in xp:
		s += xp[i]
	return clamp(floor((globalVariables.uncovered  + (s * s) ) * 0.1 * globalVariables.scoreMult) - globalVariables.lostsanity, 0, 999999999)

func uncover(ingredient: String) -> void:
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
		"Flamel5":
			if globalVariables.uncovered < globalVariables.n:
				globalVariables.sanity -= damage[6]
				signalBus.upsane.emit()
			else:
				globalVariables.paused = true
				var time: float = $timer.t
				var s: float = 0
				if globalVariables.lostsanity == 0:
					globalVariables.scoreMult *= sqrt(2)
				globalVariables.scoreMult *= 3 * (exp(-time * log(2) / (globalVariables.size * 10)) + 1)
				for i: int in xp:
					s += xp[i]
				$gameOver/centerer/gameOver/time.text += str(floor(time/60)) + " Minutes and " + str(fmod(floor(time),60)) + " Seconds"
				$gameOver/centerer/gameOver/mod.text += str(snappedf(globalVariables.scoreMult, 0.001))
				$gameOver/centerer/gameOver/score.text += str(clamp(floor((globalVariables.uncovered  + (s * s) ) * 0.1 * globalVariables.scoreMult) - globalVariables.lostsanity, 0, 999999999)) + " Points"
				$gameOver/centerer/gameOver/centerer/end.text = "You Won!"
				$gameOver.visible = true
				$pause/centerer/stacker/pauseButton.disabled=true
				$pause.visible=false
				#bB.visible=true
	if globalVariables.level["Herb"] < 1:
		@warning_ignore("integer_division")
		xp["Herb"] += randi_range(0, 7) / 4
	if globalVariables.level["Shroom"] < 1:
		@warning_ignore("integer_division")
		xp["Shroom"] += randi_range(0, 7) / 4
	if globalVariables.level["Salt"] < 1:
		@warning_ignore("integer_division")
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
	var ingredientCheck: int = 0
	var maxCheck: int = 0 #prevent no right moves scenarios
	for i: String in globalVariables.ingredientStack:
		if i.ends_with("1"):
			if globalVariables.uncoveredIngred[i] == globalVariables.ingredientStack[i]:
				ingredientCheck += 1
	if ingredientCheck > maxCheck:
		maxCheck = ingredientCheck
		for i: String in globalVariables.level:
			if globalVariables.level[i] >= 1:
				ingredientCheck -= 1
		if ingredientCheck >= 0:
			var ing: Array[String] = ["Herb", "Shroom", "Salt"]
			var x: int = randi_range(0, ing.size()-1)
			var y: int = 0
			while true:
				if y == ing.size():
					break
				if globalVariables.level[ing[x]] == 0:
					globalVariables.lvl1 = ing[x]
					lvl1()
					break
				else:
					y += 1
					if x > 0:
						x -= 1
					else:
						x = ing.size()-1

func lvlUp(ingredient: String) -> void:
	match ingredient:
		"Herb": 
			$playerInfo/edge/HBoxContainer/VBoxContainer/herb/herb.texture = load("res://assets/textures/ingredients/Herb"+str(globalVariables.level["Herb"])+".png")
			$playerInfo/edge/HBoxContainer/VBoxContainer/herb/number.text = str(globalVariables.level["Herb"])
		"Shroom":
			$playerInfo/edge/HBoxContainer/VBoxContainer/shroom/shroom.texture = load("res://assets/textures/ingredients/Shroom"+str(globalVariables.level["Shroom"])+".png")
			$playerInfo/edge/HBoxContainer/VBoxContainer/shroom/number.text = str(globalVariables.level["Shroom"])
		"Salt":
			$playerInfo/edge/HBoxContainer/VBoxContainer2/salt/salt.texture = load("res://assets/textures/ingredients/Salt"+str(globalVariables.level["Salt"])+".png")
			$playerInfo/edge/HBoxContainer/VBoxContainer2/salt/number.text = str(globalVariables.level["Salt"])
		"Shadow":
			$playerInfo/edge/HBoxContainer/VBoxContainer2/shadow/shadow.texture = load("res://assets/textures/ingredients/Herb"+str(globalVariables.level["Shadow"])+".png")
			$playerInfo/edge/HBoxContainer/VBoxContainer2/shadow/number.text = str(globalVariables.level["Shadow"])

func Flamel() -> void:
	$playerInfo/edge/HBoxContainer/flamel.texture = load("res://assets/textures/ingredients/Flamel5.png")

func _on_pause_button_toggled(toggled_on: bool) -> void:
	$pauseMenu.visible = toggled_on
	globalVariables.paused = toggled_on
	signalBus.deactivate.emit(not toggled_on)
	#bB.visible=toggled_on
	
func _on_settings_pressed() -> void:
	$pauseMenu/centerer/settings.visible = true
	$pauseMenu/centerer/pause.visible = false

func _on_return_button_pressed() -> void:
	$pauseMenu/centerer/pause.visible = true
	$pauseMenu/centerer/settings.visible = false


enum sMode {normal, fast, zippy}
func _on_zippy_mode_pressed() -> void:
	settings.speedMode = sMode.zippy

func _on_fast_mode_pressed() -> void:
	settings.speedMode = sMode.fast

func _on_normal_mode_pressed() -> void:
	settings.speedMode = sMode.normal

func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

func _on_return_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

func dead() -> void:
	globalVariables.lostsanity += iniSan - globalVariables.sanity
	iniSan = globalVariables.sanity
	var t: float = $music.get_playback_position()
	@warning_ignore("integer_division")
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
		signalBus.deactivate.emit(false)
		globalVariables.paused = true
		$pause/centerer/stacker/pauseButton.disabled=true
		$pause.visible=false
		#bB.visible=true
		var time: float = $timer.t
		var s: float = 0
		globalVariables.scoreMult *= (exp(-time * log(2) / (globalVariables.size * 10)) + 1)
		for i: String in xp:
			s += xp[i]
		$gameOver/centerer/gameOver/centerer/end.text = "Game Over!"
		$gameOver/centerer/gameOver/time.text += str(floor(time/60)) + " Minutes and " + str(fmod(floor(time),60)) + " Seconds"
		$gameOver/centerer/gameOver/mod.text += str(snappedf(globalVariables.scoreMult, 0.001))
		$gameOver/centerer/gameOver/score.text += str(floor((globalVariables.uncovered  + (s * s) ) * 0.1 * globalVariables.scoreMult - globalVariables.lostsanity)) + " Points"
		$gameOver.visible = true
		
		globalVariables.cursor = load("res://assets/textures/cursors/pincher.png")
		globalVariables.click = load("res://assets/textures/cursors/pincherCl.png")


