extends Node2D

# save buttons to vars for further use
@onready var playBtn: Button = $background/edge/menu/mainbuttons/play
@onready var storyBtn: Button =$background/edge/menu/play/playStory
@onready var arcadeBtn: Button =$background/edge/menu/play/playArcade
@onready var rogueBtn: Button =$background/edge/menu/play/playRogue
@onready var settingsBtn: Button =$background/edge/menu/mainbuttons/settings
@onready var creditsBtn: Button =$background/edge/menu/mainbuttons/credits

# save menu pages to vars for further use
@onready var mainPg: VBoxContainer = $background/edge/menu/mainbuttons
@onready var playPg: VBoxContainer = $background/edge/menu/play
@onready var storyPg: VBoxContainer = $background/edge/menu/story
@onready var arcadePg: HBoxContainer =$background/edge/menu/arcade
@onready var settingsPg: HBoxContainer =$background/edge/menu/settings
@onready var creditsPg: HBoxContainer =$background/edge/menu/credits
@onready var roguePg=null #TODO put rogue page ref here when implemented
@onready var titlePg=$background/edge/menu/title

@onready var langSel=$background/edge/menu/settings/settings/language/languageSelector

@onready var mods: GridContainer = $background/edge/menu/arcade/arcade/modContainer
@onready var lbMult: Label = $background/edge/menu/arcade/arcade/seedContainer/lbMult

@onready var background: TextureRect = $background

@onready var click: AudioStreamPlayer = $clickSound
@onready var hover: AudioStreamPlayer = $hoverSound

var mainBtn: Array[Callable] = [_toTitle, _toArcade, _toStory, _toCredits, _toRogue, _toSettings]
var avLng:Array[String]=[]

func _ready() -> void:
	globalVariables.scoreMult = 1
	
	langSel.get_popup().get_viewport().transparent_bg = true
	
	var lang=TranslationServer.get_locale()[0].capitalize()+TranslationServer.get_locale()[1].capitalize()
	if TranslationServer.get_locale().length()==5:
		lang=lang+TranslationServer.get_locale().right(2)
	for id in langSel.get_selectable_item(true)+1:
		if "btn"+lang==langSel.get_item_text(id):
			langSel.select(id)
		elif "btn"+lang.left(2)==langSel.get_item_text(id):
			langSel.select(id)

	globalVariables.language = lang
	if lang.left(2) == "EN":
		if lang.right(2) == "GB":
			pass
		else:
			TranslationServer.set_locale("en")
			globalVariables.language = "EN"
	
	
	playPg.visible = false
	_toTitle()
	buttonClickSound()
	colourPickerResize()
	shapeshift(globalVariables.colours[0],globalVariables.colours[1],globalVariables.colours[2], globalVariables.darkmode)

func _process(delta: float) -> void:
	lbMult.text = "Score Modifyer: " + str(globalVariables.scoreMult)

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
	'match level:
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
	print(globalVariables.lvlUP)'
	get_tree().change_scene_to_file("res://scenes/lvl0.tscn")


func _on_tutorials_pressed() -> void: # starts the tutorial
	get_tree().change_scene_to_file("res://scenes/levels/tutorials/tut0.tscn")


func _on_arcade_pressed():
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
	globalVariables.lvl1 = globalVariables.ingr.pick_random()
	
	stackIngredients()
		
	globalVariables.buff["shield"] = 1
	globalVariables.buff["freeHint"] = 1
	
	get_tree().change_scene_to_file("res://scenes/lvl0.tscn")


func _on_language_selected(index: int) -> void: # changes the language (locale)
	match langSel.get_item_text(index):
		"btnEN": TranslationServer.set_locale("en") 
		"btnDE": TranslationServer.set_locale("de") 
		"btnENGB": TranslationServer.set_locale("en_GB")
		"btnFR": TranslationServer.set_locale("fr")
		"btnES": TranslationServer.set_locale("es")
		"btnEO": TranslationServer.set_locale("eo")
		_: print(langSel.get_item_text(index) + "fehlt noch")
	globalVariables.language = langSel.get_item_text(index).right(-3)

func stackIngredients() -> void: # takes care of the ingredient stack
	
	var ingrMult: float = 0.35 # setting up the ingredient multiplyer
	if globalVariables.mod.has("DI"):
		ingrMult = 0.45
	elif globalVariables.mod.has("LR"):
		ingrMult = 0.25
	
	if globalVariables.mod.has("OF") and globalVariables.mod.has("DL"):
		ingrMult -= 0.15
	elif globalVariables.mod.has("OF"):
		ingrMult -= 0.1
	elif globalVariables.mod.has("DL"):
		ingrMult -= 0.1
	
	for i: String in globalVariables.ingredientStack:
		globalVariables.ingredientStack[i] = 1
		if i.to_int() <= 1:
			globalVariables.ingredientStack[i] += 1
		if i.to_int() <= 2:
			globalVariables.ingredientStack[i] += 1
	
	if globalVariables.mod.has("AA"):
		for i: String in globalVariables.ingredientStack:
			if i.to_int() > 1:
				globalVariables.ingredientStack[i] += 1
			if i.to_int() > 2:
				globalVariables.ingredientStack[i] += 1
	elif globalVariables.mod.has("BA"):
		for i: String in globalVariables.ingredientStack:
			if i.to_int() <= 1:
				globalVariables.ingredientStack[i] += 1
			if i.to_int() <= 2:
				globalVariables.ingredientStack[i] += 1
	
	for i: String in globalVariables.ingredientStack:
		if not globalVariables.mod.has("HE"):
			if globalVariables.lvl1 == "Herb":
				globalVariables.lvl1 = globalVariables.ingr.pick_random()
			if i.left(-1) == "Herb":
				globalVariables.ingredientStack[i] = 0
		if not globalVariables.mod.has("ST"):
			if globalVariables.lvl1 == "Salt":
				globalVariables.lvl1 = globalVariables.ingr.pick_random()
			if i.left(-1) == "Salt":
				globalVariables.ingredientStack[i] = 0
		if not globalVariables.mod.has("FU"):
			if globalVariables.lvl1 == "Shroom":
				globalVariables.lvl1 = globalVariables.ingr.pick_random()
			if i.left(-1) == "Shroom":
				globalVariables.ingredientStack[i] = 0
	
	globalVariables.xp.clear()
	if globalVariables.mod.has("HE"):
		globalVariables.xp["Herb"] = 0.0
	if globalVariables.mod.has("ST"):
		globalVariables.xp["Salt"] = 0.0
	if globalVariables.mod.has("FU"):
		globalVariables.xp["Shroom"] = 0.0
	elif not globalVariables.mod.has("HE") and not globalVariables.mod.has("ST") and not globalVariables.mod.has("FU"):
		globalVariables.lvl1 = ""
		return
	
	globalVariables.sum = 0 # finalising the ingredient multiplyer for 'normal modes'
	for i: String in globalVariables.ingredientStack:
		globalVariables.sum += globalVariables.ingredientStack[i]
	globalVariables.empty = globalVariables.n
	globalVariables.ingredientMult = (globalVariables.n / globalVariables.sum) * ingrMult
	
	for i in globalVariables.ingredientStack: # finalising the ingredient stack
		globalVariables.ingredientStack[i] = int(globalVariables.ingredientStack[i] * globalVariables.ingredientMult)
		globalVariables.empty -= globalVariables.ingredientStack[i]

func colourPickerResize() -> void:
	for cP: ColorPickerButton in get_tree().get_nodes_in_group("colourPick"):
		cP.get_picker().hex_visible = false
		cP.get_picker().deferred_mode = true
		cP.get_picker().presets_visible = false
		cP.get_picker().color_modes_visible = false
		cP.get_popup().get_viewport().transparent_bg = true
		cP.get_picker().get_child(0, true).get_child(0, true).get_child(1, true).get_child(2, true).visible = false

@onready var backgroundsample: Array[TextureRect] = [
	$background/edge/menu/settings/settings/colour/background/bgImg,
	$background/edge/menu/settings/settings/colour/shadow/sample/bgImg,
	$background/edge/menu/settings/settings/colour/grid/sample/bgImg
]
@onready var shadowsample: Array[TextureRect] = [
	$background/edge/menu/settings/settings/colour/shadow/sample/shaImg,
	$background/edge/menu/settings/settings/colour/grid/sample/shaImg
]
@onready var gridsample: TextureRect = $background/edge/menu/settings/settings/colour/grid/sample/gridImg
@onready var colourPicks: Array[ColorPickerButton] = [
	$background/edge/menu/settings/settings/colour/background/background,
	$background/edge/menu/settings/settings/colour/shadow/shadow,
	$background/edge/menu/settings/settings/colour/grid/grid
]

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
	if dark:
		background.texture = load("res://assets/textures/splashscreens/CityNight.png")
	else:
		background.texture = load("res://assets/textures/splashscreens/City.png")

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

