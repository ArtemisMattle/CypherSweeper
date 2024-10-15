extends Node

var damage: Array[int] = [1, 7, 13, 21, 30, 50, 101]
var xp: Dictionary = {"Herb" = 0, "Shroom" = 0, "Salt" = 0}
var iniSan: int
var playing: bool = true
var activeMusic: bool = true
var activeTrack: int = 10
@onready var music: Dictionary = {true: $music1, false: $music2}
@onready var fade: AnimationPlayer = $fader
@onready var click: AudioStreamPlayer = $clickSound
@onready var hover: AudioStreamPlayer = $hoverSound
@onready var hovers: AudioStreamPlayer = $hoverSoundS
@onready var levelUp: AudioStreamPlayer = $levelUp
@onready var damageSFX: AudioStreamPlayer = $damage
var tracks: Array[String] = [
	"res://assets/audio/music/level/Main Game Sanity 9 - 0.mp3",
	"res://assets/audio/music/level/Main Game Sanity 19 - 10.mp3",
	"res://assets/audio/music/level/Main Game Sanity 29 - 20.mp3",
	"res://assets/audio/music/level/Main Game Sanity 39 - 30.mp3",
	"res://assets/audio/music/level/Main Game Sanity 49 - 40.mp3",
	"res://assets/audio/music/level/Main Game Sanity 59 - 50.mp3",
	"res://assets/audio/music/level/Main Game Sanity 69 - 60.mp3",
	"res://assets/audio/music/level/Main Game Sanity 79 - 70.mp3",
	"res://assets/audio/music/level/Main Game Sanity 89 - 80.mp3",
	"res://assets/audio/music/level/Main Game Sanity 100 - 90.mp3",]

#@onready var bB=$"../../buttonBlocker"

func _ready() -> void:
	signalBus.lvlNothing.connect(lvl1.bind(globalVariables.lvl1))
	signalBus.uncoverIngr.connect(uncover)
	signalBus.lvlFlamel.connect(Flamel)
	globalVariables.lostsanity = 0
	
	#pause button setup
	globalVariables.paused = false
	playing = true
	$pause/centerer/stacker/pauseButton.disabled=false
	$pause.visible=true
	$pauseMenu/centerer/settings/settings/language/languageSelector.get_popup().get_viewport().transparent_bg = true
	signalBus.populated.connect(buttonClickSound)
	#bB.visible=false


func lvl1(ing: String) -> bool: # 
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
		xp[ingredient.left(-1)] += ingredient.to_int()
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
	if playing:
		damageSFX.play()
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
			playing = false

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
	var time: float = globalVariables.playTime
	var msg: int = randi_range(0, 100)
	if win:
		match msg:
			_: $gameOver/centerer/gameOver/centerer/end.text = tr("lbWon")
	else:
		match msg:
			_: $gameOver/centerer/gameOver/centerer/end.text = tr("lbGameOver")
	$gameOver/centerer/gameOver/time.text = tr("lbTime") + " " + str(floor(time/60)) + " " + tr("lbMin") + " " + str(fmod(floor(time),60)) + " " + tr("lbSec")
	$gameOver/centerer/gameOver/score.text = tr("lbScore") + " " + str(score(time))
	$gameOver/centerer/gameOver/mod.text = tr("lbMod") + " " + str(snappedf(globalVariables.scoreMult, 0.001))
	globalVariables.cursor = load("res://assets/textures/cursors/pincher.png")
	globalVariables.click = load("res://assets/textures/cursors/pincherCl.png")
	$pause.visible = false
	$gameOver.visible = true
	
	if win: # changes the music to after game loops, also plays a short jingle
		music[not activeMusic].stream = load("res://assets/audio/music/Setting Menu.mp3")
		$endGameJingle.stream = load("res://assets/audio/sfx/endGame/Sieg Option 2.mp3")
	else:
		music[not activeMusic].stream = load("res://assets/audio/music/Pause Menu.mp3")
		$endGameJingle.stream = load("res://assets/audio/sfx/endGame/Niederlage Opt 2.mp3")
	$endGameJingle.play()
	music[not activeMusic].play(music[activeMusic].get_playback_position())
	if activeMusic: # does a crossfade
		fade.play("fade1")
	else:
		fade.play("fade2")
	activeMusic = not activeMusic

func score(time: float) -> int: #calculates the score
	var s: float = 0
	if globalVariables.lostsanity == 0:
		globalVariables.scoreMult *= sqrt(2)
	globalVariables.scoreMult *= clamp(exp(-time * log(2) / (globalVariables.size * globalVariables.size)) * 2 + 1, 1.0, 2.0)
	for i: String in xp:
		s += xp[i]
	return clamp(floor((globalVariables.uncovered  + (s * s) ) * 0.1 * globalVariables.scoreMult) - globalVariables.lostsanity, 0, 999999999)

func lvlUp(ingredient: String) -> void: # increases the level for the ingredient
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
	levelUp.play(0.9)

func Flamel() -> void: # shows the Flamel when it's time to reveal it
	$playerInfo/edge/HBoxContainer/flamel.texture = load("res://assets/textures/ingredients/Flamel5.png")
	levelUp.play(0.9)
	levelUp.play(0.6)
	levelUp.play(0.5)

func _on_pause_button_toggled(toggled_on: bool) -> void: # pauses the game and shows a pause menu
	$pauseMenu.visible = toggled_on
	$pauseMenu/centerer/pause.visible = true
	$pauseMenu/centerer/settings.visible = false
	globalVariables.paused = toggled_on
	signalBus.deactivate.emit(not toggled_on)
	#bB.visible=toggled_on
	$pause/centerer/stacker/pauseButton.button_pressed = toggled_on 

func _on_settings_pressed() -> void: # goes into the settings menu
	$pauseMenu/centerer/settings.visible = true
	$pauseMenu/centerer/pause.visible = false

func _on_return_button_pressed() -> void: # retuns to the pause menu
	$pauseMenu/centerer/pause.visible = true
	$pauseMenu/centerer/settings.visible = false

# changes the speedMode ingame
enum sMode {normal, fast, zippy}
func _on_zippy_mode_pressed() -> void:
	settings.speedMode = sMode.zippy

func _on_fast_mode_pressed() -> void:
	settings.speedMode = sMode.fast

func _on_normal_mode_pressed() -> void:
	settings.speedMode = sMode.normal

func _on_exit_pressed() -> void: # returns you to the menu
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

func buttonClickSound() -> void: # searches all buttons and connects them to the sound effect player
	for buttons: Node in get_tree().get_nodes_in_group("buttonClick"):
		buttons.pressed.connect(sfxPlay.bind(1))
		buttons.mouse_entered.connect(sfxPlay.bind(2))
	for buttons: Node in get_tree().get_nodes_in_group("buttonHover"):
		buttons.mouse_entered.connect(sfxPlay.bind(2))
	for buttons: Node in get_tree().get_nodes_in_group("buttonHoverS"):
		buttons.mouse_entered.connect(sfxPlay.bind(3))

func sfxPlay(sound: int) -> void: # plays sounds for different events
	match sound:
		1:click.play()
		2:hover.play()
		3:hovers.play()
