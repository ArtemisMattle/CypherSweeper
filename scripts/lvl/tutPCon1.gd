extends Node

var damage: Array[int] = [1, 7, 13, 21, 30, 50, 101]
var xpdiff: float = 0.6
var xpThold: Dictionary = {}
var lvlMax: Dictionary
var iniSan: int
var winbonus: float = sqrt(2)
var s: float = 0
var flamel: bool = false

# music stuff
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

@onready var langSel: OptionButton = $pauseMenu/centerer/settings/settings/language/languageSelector

#@onready var bB=$"../../buttonBlocker"

func _ready() -> void:
	signalBus.lvlNothing.connect(lvl1.bind(globalVariables.lvl1))
	signalBus.uncoverIngr.connect(uncover)
	signalBus.lvlFlamel.connect(Flamel)
	globalVariables.lostsanity = 0
	for i: String in globalVariables.xp:
		globalVariables.xp[i] = 0
	
	globalVariables.paused = false
	playing = true
	#pause button setup
	$pause/centerer/stacker/pauseButton.disabled=false
	$pause.visible=true
	$pauseMenu/centerer/settings/settings/language/languageSelector.get_popup().get_viewport().transparent_bg = true
	print(globalVariables.language)
	for id in langSel.get_selectable_item(true)+1:
		if "btn"+globalVariables.language==langSel.get_item_text(id):
			langSel.select(id)
		elif "btn"+globalVariables.language.left(2)==langSel.get_item_text(id):
			langSel.select(id)
	
	shapeshift(globalVariables.colours[0], globalVariables.colours[1], globalVariables.colours[2], globalVariables.darkmode)
	colourPickerResize()
	signalBus.populated.connect(buttonClickSound)
	#bB.visible=false
	if globalVariables.mod.has("OF"):
		$playerInfo.queue_free()
	xpThreshold()


func lvl1(ing: String) -> bool: # 
	lvlUp(ing)
	return true

func uncover(ingredient: String, last: bool) -> void: #workhorse function, determines what ingredient was uncovered and what should be done about it
	if ingredient == "Flamel5":
		if not flamel:
			takeDamage(6, true, false)
			return
		else:
			s += winbonus
			if globalVariables.uncovered == globalVariables.n:
				endGame(true)
			return
	else:
		globalVariables.xp[ingredient.left(-1)] += ingredient.to_int()
		if globalVariables.level[ingredient.left(-1)] < ingredient.to_int():
			takeDamage(ingredient.to_int(), true, true)
			
		for i: String in globalVariables.xp: # levels up ingredients when xp thresholds are meet
			if globalVariables.level[i] == lvlMax[i]:
				pass
			elif globalVariables.xp[i] >= xpThold[i + str(globalVariables.level[i] + 1)]:
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
	var msg: int = randi_range(0, 100)
	if win:
		match msg:
			_: $gameOver/centerer/gameOver/centerer/end.text = tr("lbWon")
	else:
		match msg:
			_: $gameOver/centerer/gameOver/centerer/end.text = tr("lbGameOver")
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


func lvlUp(ingredient: String) -> void: # increases the level for the ingredient
	globalVariables.level[ingredient] += 1
	signalBus.lvlUp.emit(globalVariables.level[ingredient])
	levelUp.play(0.9)

func Flamel() -> void: # shows the Flamel when it's time to reveal it
	flamel = true
	levelUp.play(0.9)
	levelUp.play(0.6)
	levelUp.play(0.5)

func xpThreshold() -> void: # calculates the thresholds for lvlUps
	var empty: int = globalVariables.n
	var xpType: Dictionary = {}
	
	for i: String in globalVariables.ingredientStack:
		empty -= globalVariables.ingredientStack[i]
		
		if i.to_int() == 1:
			xpType[i.left(-1)] = globalVariables.ingredientStack[i]
			xpThold[i] = xpType[i.left(-1)] * xpdiff / 3
			xpThold[i.left(-1) + str(i.to_int() + 1)] = xpType[i.left(-1)] * xpdiff
		else:
			xpType[i.left(-1)] += globalVariables.ingredientStack[i] * i.to_int()
			xpThold[i.left(-1) + str(i.to_int() + 1)] = xpType[i.left(-1)] * xpdiff
			lvlMax[i.left(-1)] = i.to_int()
	globalVariables.lvlNothing = int(empty * xpdiff / 3)

		# Menu stuff

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
	globalVariables.mod = []
	get_tree().change_scene_to_file("res://scenes/menu.tscn")


func _on_reset_pressed() -> void:
	globalVariables.mod = []
	get_tree().change_scene_to_file("res://scenes/levels/tutorials/tut1.tscn")

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

func _on_language_selected(index: int) -> void:
	match langSel.get_item_text(index):
		"btnEN": TranslationServer.set_locale("en") 
		"btnDE": TranslationServer.set_locale("de") 
		"btnENGB": TranslationServer.set_locale("en_GB")
		"btnFR": TranslationServer.set_locale("fr")
		"btnES": TranslationServer.set_locale("es")
		"btnEO": TranslationServer.set_locale("eo")
		_: print(langSel.get_item_text(index) + "fehlt noch")
	globalVariables.language = langSel.get_item_text(index).right(-3)

@onready var backgroundsample: Array[TextureRect] = [
	$pauseMenu/centerer/settings/settings/colour/background/bgImg,
	$pauseMenu/centerer/settings/settings/colour/shadow/sample/bgImg,
	$pauseMenu/centerer/settings/settings/colour/grid/sample/bgImg
	]

@onready var shadowsample: Array[TextureRect] = [
	$pauseMenu/centerer/settings/settings/colour/shadow/sample/shaImg,
	$pauseMenu/centerer/settings/settings/colour/grid/sample/shaImg
	]

@onready var gridsample: TextureRect = $pauseMenu/centerer/settings/settings/colour/grid/sample/gridImg

@onready var colourPicks: Array[ColorPickerButton] = [
	$pauseMenu/centerer/settings/settings/colour/background/background,
	$pauseMenu/centerer/settings/settings/colour/shadow/shadow,
	$pauseMenu/centerer/settings/settings/colour/grid/grid
]


func singleMod(c: Color, pos: int) -> void: # forwards the colourpickers to modulate and adds the unchanged colours
	match pos:
		0: shapeshift(c, globalVariables.colours[1], globalVariables.colours[2], globalVariables.darkmode)
		1: shapeshift(globalVariables.colours[0], c, globalVariables.colours[2], globalVariables.darkmode)
		2: shapeshift(globalVariables.colours[0], globalVariables.colours[1], c, globalVariables.darkmode)

func colourPickerResize() -> void:
	for cP: ColorPickerButton in get_tree().get_nodes_in_group("colourPick"):
		cP.get_picker().hex_visible = false
		cP.get_picker().deferred_mode = true
		cP.get_picker().presets_visible = false
		cP.get_picker().color_modes_visible = false
		cP.get_popup().get_viewport().transparent_bg = true
		cP.get_picker().get_child(0, true).get_child(0, true).get_child(1, true).get_child(2, true).visible = false

func shapeshift(bg: Color, sha: Color, grid: Color, dark: bool) -> void: # changes the colours of the samples and sends the necessary signals for the rest
	globalVariables.colours[0] = bg
	colourPicks[0].color = bg
	for i: TextureRect in backgroundsample:
		i.modulate = bg
	globalVariables.colours[1] = sha
	colourPicks[1].color = sha
	for i: TextureRect in shadowsample:
		i.modulate = sha
	globalVariables.colours[2] = grid
	colourPicks[2].color = grid
	gridsample.modulate = grid
	
	globalVariables.darkmode = dark
	signalBus.modulate.emit()


