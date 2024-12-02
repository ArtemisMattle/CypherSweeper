extends Node

var language: String = "EN"

var sanity: int = 100
var lostsanity: int = 0
var playTime: float = 0
var paused: bool = false
var uncoveredIngred: Dictionary = {
	"Nothing0" = 0, 
	"Herb1" = 0,
	"Herb2" = 0,
	"Herb3" = 0,
	"Shroom1" = 0,
	"Shroom2" = 0,
	"Shroom3" = 0,
	"Salt1" = 0,
	"Salt2" = 0,
	"Salt3" = 0,
	"Flamel5" = 0,}
var uncovered: int = 0
var size: int
var n: int
var xpFlagBoon: float = 0.15
var xp: Dictionary = {
	"Herb" = 0.0, 
	"Shroom" = 0.0, 
	"Salt" = 0.0,}
var level: Dictionary = {
	"Herb" = 0, 
	"Shroom" = 0, 
	"Salt" = 0,}
var lvlNothing: int
var lvl1: String = "Herb"
var leveled1: bool = false
var ingr: Array[String] = ["Herb", "Shroom", "Salt"]

var tutDamaged: bool = false

var ingredientMult: float = 1
var ingredientStack: Dictionary = {
	"Herb1" = 0,
	"Herb2" = 0,
	"Herb3" = 0,
	"Shroom1" = 0,
	"Shroom2" = 0,
	"Shroom3" = 0,
	"Salt1" = 0,
	"Salt2" = 0,
	"Salt3" = 0,}
var specials: Dictionary = {
	"coffee" = 9,
}
var empty: int 
var sum: int

var beanCount=100; # Percentage of map with coffee beans

var colours: Array[Color] = [
	Color(0.878, 0.8, 0.533),
	Color(0, 0, 0),
	Color(0.694, 0.451, 0.718)
	]
var darkmode: bool = false

var mod: Array[String] = [] # array of active modifyers

var buff: Dictionary = {
	"shield" = 0,
	"freeHint" = 0,
}

var mods: Array[modifyer] = [ # array of all modifyers
	modifyer.new("HEK", 3, ["EC"]),# playerControler ,  not demo
	modifyer.new("EC", 7, ["HEK"]),# playerControler , not demo
	modifyer.new("DI", 3, ["LR"]), # main Menu ,  not demo
	modifyer.new("LR", -3, ["DI"]), # main Menu
	modifyer.new("AA", 3, ["BA"]), # main Menu ,  not demo
	modifyer.new("BA", -3, ["AA"]), # main Menu
	modifyer.new("DL", 5), # generator  ,  not demo
	modifyer.new("BS", 4), # generator  ,  not demo
	modifyer.new("OF", 10, ["HE", "FU", "ST", "HEK", "EC", "AA", "BA"]), # generator & playerController & main Menu
	modifyer.new("HE", -2, [], true), # main Menu
	modifyer.new("FU", -2, [], true), # main Menu
	modifyer.new("ST", -2, [], true), # main Menu
]


var boxing: bool = false # if a tool gets put back into the box
var holdable: bool = true

var lexPage: int = 0 # tells the lexicon on which page it is

var cam: Camera2D

var scoreMult: float = 1
var rngseed: int = 5

var cursor: Resource
var click: Resource

func _ready() -> void: # provides setup for the cursor curser
	# cursor curser setup
	cursor = load("res://assets/textures/cursors/pincher.png")
	click = load("res://assets/textures/cursors/pincherCl.png")
	signalBus.upsane.connect(cursedCursor)

func minLvl() -> int: # provides the lowest level
	var lvl: int = 5
	for i: String in level:
		if level[i] < lvl:
			lvl = level[i]
	return lvl

func baseScoreMult() -> float: # recalculates the ScoreMultiplyer
	var x: float = 1.6
	for m: String in mod:
		var y: modifyer = mods[0].findNamed(m)
		x += float(y.v) / 10
	return x
#cursor curser

func cursedCursor() -> void:
	if sanity > 70:
		cursor = load("res://assets/textures/cursors/pincher.png")
		click = load("res://assets/textures/cursors/pincherCl.png")
	elif sanity > 30:
		cursor = load("res://assets/textures/cursors/pincher.png")
		click = load("res://assets/textures/cursors/pincherCl.png")
	else:
		cursor = load("res://assets/textures/cursors/hand.png")
		click = load("res://assets/textures/cursors/handCl.png")

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		mouseHandler(event)

func mouseHandler(event: InputEvent) -> void:
	if event.pressed and event.button_index== 1: #1-> LMB, 2 -> RMB
		Input.set_custom_mouse_cursor(click)
	if event.is_released() and event.button_index== 1: #1-> LMB, 2 -> RMB
		Input.set_custom_mouse_cursor(cursor)

func sToHex(x: String) -> String:
	
	var y: String
	while not x.is_empty():
		y += x.left(1).to_utf8_buffer().hex_encode()
		x = x.erase(0)
	return y


class tool: # class for non consumable tools, used by toolBox and toolHandler
	var tScene: Control = null
	var place: Node2D = null
	var pickUp: Area2D = null # must have the "pickUpTool" Group
	
	func initiate() -> void:
		place = tScene.get_node("placer")
		pickUp = tScene.get_node("placer/pickUp")
	
	func _to_string() -> String:
		if tScene == null:
			return "null"
		else:
			return tScene.name

class modifyer: # contains the few necessary informations for modifyers
	var n: String
	var v: int
	var onByDefault: bool = false
	var incompatible: Array[String]
	var btn: TextureButton
	
	func _init(name: String, value: int = 0, incomp: Array[String] = [], oBD: bool = false) -> void:
		n = name
		v = value
		onByDefault = oBD
		incompatible = incomp
	
	func findNamed(name: String) -> modifyer: # finds modifyers by name instead of id
		for i: modifyer in globalVariables.mods:
			if i.n == name:
				return i
		return null
