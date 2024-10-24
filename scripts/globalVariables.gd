extends Node

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

var ingredientMult: float = 1
var ingredientStack: Dictionary = {
	"Herb1" = 3,
	"Herb2" = 0,
	"Herb3" = 0,
	"Shroom1" = 3,
	"Shroom2" = 0,
	"Shroom3" = 0,
	"Salt1" = 3,
	"Salt2" = 0,
	"Salt3" = 0,}

var mod: Array[String] = []

var buff: Dictionary = {
	"shield" = 0,
	"freeHint" = 0,
}


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
