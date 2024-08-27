extends Node

var damage: Array[int] = [1, 7, 13, 21, 30, 50, 101]
var xp: Dictionary = {"Herb" = 0, "Shroom" = 0, "Salt" = 0}
var iniSan: int
var activeMusic: bool = true
var activeTrack: int = 10
@onready var music: Dictionary = {true: $music1, false: $music2}
@onready var fade: AnimationPlayer = $fader
var tracks: Array[String] = [
	"res://assets/audio/music/level/Main Game Sanity 9 - 0.wav",
	"res://assets/audio/music/level/Main Game Sanity 19 - 10.wav",
	"res://assets/audio/music/level/Main Game Sanity 29 - 20.wav",
	"res://assets/audio/music/level/Main Game Sanity 39 - 30.wav",
	"res://assets/audio/music/level/Main Game Sanity 49 - 40.wav",
	"res://assets/audio/music/level/Main Game Sanity 59 - 50.wav",
	"res://assets/audio/music/level/Main Game Sanity 69 - 60.wav",
	"res://assets/audio/music/level/Main Game Sanity 79 - 70.wav",
	"res://assets/audio/music/level/Main Game Sanity 89 - 80.wav",
	"res://assets/audio/music/level/Main Game Sanity 100 - 90.wav",]

#@onready var bB=$"../../buttonBlocker"

func _ready() -> void:
	signalBus.lvlNothing.connect(lvl1.bind(globalVariables.lvl1))
	signalBus.uncoverIngr.connect(uncover)
	signalBus.lvlFlamel.connect(Flamel)
	signalBus.upsane.connect(musicCurser)
	globalVariables.lostsanity = 0
	
	#pause button setup
	globalVariables.paused = false
	$pause/centerer/stacker/pauseButton.disabled=false
	$pause.visible=true
	$pauseMenu/centerer/settings/settings/language/languageSelector.get_popup().get_viewport().transparent_bg = true
	#bB.visible=false

func lvl1(ing: String) -> bool:
	if globalVariables.level[ing] < 1:
		xp[ing] = globalVariables.lvlUP["1"]
		lvlUp(ing)
		return true
	return false

func uncover(ingredient: String, last: bool) -> void: #workhorse function, determines what ingredient was uncovered and what should be done about it
	if ingredient == "Flamel5":
		if globalVariables.uncovered < globalVariables.n:
			takeDamage(6, true, false)
		else:
			endGame(true)
	else:
		xp[ingredient.left(-1)] += ingredient.right(1).to_int()
		if globalVariables.level[ingredient.left(-1)] < ingredient.right(1).to_int():
			takeDamage(ingredient.right(1).to_int(), true, true)
	if not globalVariables.leveled1: # gives xp to ingredients without level
		if globalVariables.level.values().has(0):
			for i: String in globalVariables.level:
				if globalVariables.level[i] < 1:
					@warning_ignore("integer_division")
					xp[i] += randi_range(0,7) / 4
			if last: # forces lvlups if necessary for damageless running
				while not lvl1(globalVariables.ingr.pick_random()):
					pass
		else:
			globalVariables.leveled1 = true
	for i: String in globalVariables.level: # levels up ingredients when xp thresholds are meet
		if xp[i] >= globalVariables.lvlUP[str(globalVariables.level[i]+1)]:
			lvlUp(i)

func takeDamage(level: int, counts: bool, modifyable: bool) -> void: #modifies the sanity when making mistakes, level determines severity & counts determines if it affects score
	if counts:
		globalVariables.lostsanity += damage[level]
	globalVariables.sanity = clampi(globalVariables.sanity - damage[level], 0, 100)
	signalBus.upsane.emit()
	if globalVariables.sanity <= activeTrack * 10 - 10:
		@warning_ignore("integer_division")
		activeTrack = globalVariables.sanity / 10
		musicCurser(activeTrack)
	if globalVariables.sanity == 0:
		endGame(false)

func musicCurser(nextTrack: int ) -> void: #changes the background music 
	music[not activeMusic].stream = load(tracks[nextTrack])
	music[not activeMusic].play(music[activeMusic].get_playback_position())
	if activeMusic: # does a crossfade
		fade.play("fade1")
	else:
		fade.play("fade2")
	activeMusic = not activeMusic

func endGame(win: bool) -> void: #gets called when the game is done, handles everything after the last 'ingredient'
	globalVariables.paused = true
	signalBus.deactivate.emit(false)
	if win:
		globalVariables.scoreMult *= 3
	var time: float = $timer.t
	var msg: int = randi_range(0, 100)
	if win:
		match msg:
			_: $gameOver/centerer/gameOver/centerer/end.text = "You Won!"
	else:
		match msg:
			_: $gameOver/centerer/gameOver/centerer/end.text = "Game Over!"
	$gameOver/centerer/gameOver/time.text += str(floor(time/60)) + " Minutes and " + str(fmod(floor(time),60)) + " Seconds"
	$gameOver/centerer/gameOver/score.text += str(score(time))
	$gameOver/centerer/gameOver/mod.text += str(snappedf(globalVariables.scoreMult, 0.001))
	globalVariables.cursor = load("res://assets/textures/cursors/pincher.png")
	globalVariables.click = load("res://assets/textures/cursors/pincherCl.png")
	$pause.visible = false
	$gameOver.visible = true

func score(time: float) -> int: #calculates the score
	var s: float = 0
	if globalVariables.lostsanity == 0:
		globalVariables.scoreMult *= sqrt(2)
	globalVariables.scoreMult *= clamp(exp(-time * log(2) / (globalVariables.size * globalVariables.size)) * 2 + 1, 1.0, 2.0)
	for i: String in xp:
		s += xp[i]
	return clamp(floor((globalVariables.uncovered  + (s * s) ) * 0.1 * globalVariables.scoreMult) - globalVariables.lostsanity, 0, 999999999)

func lvlUp(ingredient: String) -> void:
	globalVariables.level[ingredient] += 1
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
