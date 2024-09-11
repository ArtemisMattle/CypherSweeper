extends Node2D

# save buttons to vars for further use
@onready var playBtn: Button = $background/edge/menu/mainbuttons/play
@onready var storyBtn=$background/edge/menu/play/playStory
@onready var arcadeBtn=$background/edge/menu/play/playArcade
@onready var rogueBtn=$background/edge/menu/play/playRogue
@onready var settingsBtn=$background/edge/menu/mainbuttons/settings
@onready var creditsBtn=$background/edge/menu/mainbuttons/credits

# save menu pages to vars for further use
@onready var mainPg: VBoxContainer = $background/edge/menu/mainbuttons
@onready var playPg: VBoxContainer = $background/edge/menu/play
@onready var storyPg=$background/edge/menu/levelSelect
@onready var arcadePg=$background/edge/menu/arcade
@onready var settingsPg=$background/edge/menu/settings
@onready var creditsPg=$background/edge/menu/credits
@onready var roguePg=null #TODO put rogue page ref here when implemented
@onready var titlePg=$background/edge/menu/title

@onready var langSel=$background/edge/menu/settings/settings/language/languageSelector

@onready var click: AudioStreamPlayer = $clickSound
@onready var hover: AudioStreamPlayer = $hoverSound

var mainBtn: Array[Callable] = [_toTitle, _toArcade, _toStory, _toCredits, _toRogue, _toSettings]
var avLng:Array[String]=[]

func _ready() -> void:
	langSel.get_popup().get_viewport().transparent_bg = true
	
	var lang=TranslationServer.get_locale()[0].capitalize()+TranslationServer.get_locale()[1].capitalize()
	if TranslationServer.get_locale().length()==5:
		lang=lang+TranslationServer.get_locale().right(2)
	
	for id in langSel.get_selectable_item(true)+1:
		if "btn"+lang==langSel.get_item_text(id):
			langSel.select(id)
		elif "btn"+lang.left(2)==langSel.get_item_text(id):
			langSel.select(id)
	
	
	playPg.visible = false
	_toTitle()
	buttonClickSound()

func exitPg() -> void:
	storyPg.visible=false
	arcadePg.visible=false
	settingsPg.visible=false
	creditsPg.visible=false
	#roguePG.visible=false #uncomment when implemented
	titlePg.visible=false
	
	disconnectBtnFunc(storyBtn.pressed)
	disconnectBtnFunc(arcadeBtn.pressed)
	disconnectBtnFunc(settingsBtn.pressed)
	#disconnectBtnFunc(rogueBtn.pressed)
	disconnectBtnFunc(creditsBtn.pressed)
	
	arcadeBtn.pressed.connect(_toArcade)
	storyBtn.pressed.connect(_toStory)
	creditsBtn.pressed.connect(_toCredits)
	#rogueBtn.pressed.connect(_toRogue)
	settingsBtn.pressed.connect(_toSettings)
	arcadeBtn.text = "btnPArcade"
	storyBtn.text = "btnPStory"
	rogueBtn.text = "btnPRogue"
	settingsBtn.text = "btnSettings"
	creditsBtn.text = "btnCredits"
	

func _toTitle() -> void:
	exitPg()
	titlePg.visible=true
	
func disconnectBtnFunc(btn:Signal) -> void:
	for i in btn.get_connections():
		if mainBtn.has(i.callable):
			btn.disconnect(i.callable)

func _toPlay() -> void:
	exitPg()
	playPg.visible = true
	mainPg.visible = false

func _toStory() -> void:
	exitPg()
	storyPg.visible=true
	storyBtn.pressed.connect(_toTitle)
	storyBtn.text= "btnBack"

func _toArcade() -> void:
	exitPg()
	arcadePg.visible=true
	arcadeBtn.pressed.connect(_toTitle)
	arcadeBtn.text= "btnBack"

func _toRogue() -> void:
	exitPg()
	roguePg.visible=true
	rogueBtn.pressed.connect(_toTitle)
	rogueBtn.text= "btnBack"

func _toMain() -> void:
	exitPg()
	mainPg.visible = true
	playPg.visible = false
	_toTitle()

func _toSettings() -> void:
	exitPg()
	settingsPg.visible=true
	settingsBtn.pressed.connect(_toTitle)
	settingsBtn.text= "btnBack"

func _toCredits() -> void:
	exitPg()
	creditsPg.visible=true
	creditsBtn.pressed.connect(_toTitle)
	creditsBtn.text= "btnBack"

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
		
	globalVariables.lvlUP["Nothing0"] = int(empty * 0.1)
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
	globalVariables.leveled1 = false
	signalBus.upsane.emit()
	var seed=($background/edge/menu/arcade/arcade/seedContainer/seedInput.text)
	if seed != "":
		globalVariables.rngseed=int(hash(seed))
	else:
		globalVariables.rngseed=hash(randi_range(0,99999999))
	for i in globalVariables.level:
		globalVariables.level[i] = 0
	empty = globalVariables.n
	globalVariables.lvl1 = globalVariables.ingr.pick_random()
	
	if $background/edge/menu/arcade/arcade/population/populationModes/high/highMode.button_pressed:
		for i in globalVariables.ingredientStack:
			globalVariables.ingredientStack[i] = 1
		globalVariables.ingredientMult = (globalVariables.n / 9) * 0.45
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
		globalVariables.ingredientStack["Flamel5"] = 1
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
		globalVariables.ingredientStack["Flamel5"] = 1
		globalVariables.ingredientMult = (globalVariables.n / 27) * 0.25
	
	for i in globalVariables.ingredientStack:
		if i != "Flamel5":
			globalVariables.ingredientStack[i] = int(globalVariables.ingredientStack[i] * globalVariables.ingredientMult)
		empty -= globalVariables.ingredientStack[i]
	
	if $background/edge/menu/arcade/arcade/difficulty/difficultyModes/extreme/extremeMode.button_pressed:
		globalVariables.lvlUP["Nothing0"] = int(empty * 0.5)
		globalVariables.lvlUP["1"] = clamp(int(globalVariables.ingredientStack["Herb1"] * 0.4), 1, 9999)
		globalVariables.lvlUP["2"] = clamp(int(globalVariables.ingredientStack["Herb1"] * 1), globalVariables.lvlUP["1"] + 1, 9999)
		globalVariables.lvlUP["3"] = clamp(int(globalVariables.ingredientStack["Herb2"] * 3), globalVariables.lvlUP["2"] + 1, 9999)
		globalVariables.scoreMult *= 5
	elif $background/edge/menu/arcade/arcade/difficulty/difficultyModes/normal/normalMode.button_pressed:
		globalVariables.lvlUP["Nothing0"] = int(empty * 0.2)
		globalVariables.lvlUP["1"] = clamp(int(globalVariables.ingredientStack["Herb1"] * 0.1), 1, 9999)
		globalVariables.lvlUP["2"] = clamp(int(globalVariables.ingredientStack["Herb1"] * 0.6), globalVariables.lvlUP["1"] + 1, 9999)
		globalVariables.lvlUP["3"] = clamp(int(globalVariables.ingredientStack["Herb2"] * 3), globalVariables.lvlUP["2"] + 1, 9999)
	
	globalVariables.buff["shield"] = 1
	globalVariables.buff["freeHint"] = 1
	
	get_tree().change_scene_to_file("res://scenes/lvl0.tscn")

func buttonClickSound() -> void: # searches all buttons and connects them to the sound effect player
	for buttons: Node in get_tree().get_nodes_in_group("buttonClick"):
		buttons.pressed.connect(sfxPlay.bind(1))
		buttons.mouse_entered.connect(sfxPlay.bind(2))
	for buttons: Node in get_tree().get_nodes_in_group("buttonHover"):
		buttons.mouse_entered.connect(sfxPlay.bind(2))

func sfxPlay(sound: int) -> void: # plays sounds for different events
	match sound:
		1:click.play()
		2:hover.play()

func _on_language_selected(index: int) -> void: # changes the language (locale)
	match langSel.get_item_text(index):
		"btnEN": TranslationServer.set_locale("en") 
		"btnDE": TranslationServer.set_locale("de") 
		"btnENGB": TranslationServer.set_locale("en_GB")
		"btnFR": TranslationServer.set_locale("fr")
		"btnES": TranslationServer.set_locale("es")
		"btnEO": TranslationServer.set_locale("eo")
		_: print(langSel.get_item_text(index) + "fehlt noch")
		

		

