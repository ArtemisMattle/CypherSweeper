extends Node

var sanity: int = 100
var lostsanity: int = 0
var playTime: float = 0
var paused: bool = false
var uncoveredIngred: Dictionary = {
	"Nothing" = 0, 
	"Herb1" = 0,
	"Herb2" = 0,
	"Herb3" = 0,
	"Shroom1" = 0,
	"Shroom2" = 0,
	"Shroom3" = 0,
	"Salt1" = 0,
	"Salt2" = 0,
	"Salt3" = 0,
	"Flamel" = 0,}
var uncovered: int = 0
var size: int
var n: int 
var level: Dictionary = {
	"Herb" = 0, 
	"Shroom" = 0, 
	"Salt" = 0, 
	"Shadow" = 0}
var lvlUP: Dictionary = {
	"Nothing" = 21, 
	"1" = 5,
	"2" = 15,
	"3" = 30,
	"4" = 9999,
	"5" = 9999,}
var lvl1: String = "Herb"

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
	"Salt3" = 0,
	"Flamel" = 1,}

var scoreMult: float = 1
var cursor
var click


#cursor curser
func _ready() -> void:
	cursor = load("res://assets/textures/cursors/pincher.png")
	click= load("res://assets/textures/cursors/pincherCl.png")
	signalBus.upsane.connect(cursedCursor)

func cursedCursor():
	if sanity > 70:
		cursor = load("res://assets/textures/cursors/pincher.png")
		click = load("res://assets/textures/cursors/pincherCl.png")
	elif sanity > 30:
		cursor = load("res://assets/textures/cursors/pincher.png")
		click = load("res://assets/textures/cursors/pincherCl.png")
	else:
		cursor = load("res://assets/textures/cursors/hand.png")
		click = load("res://assets/textures/cursors/handCl.png")

func _unhandled_input(event):
	if event is InputEventMouseButton:
		mouseHandler(event)

func mouseHandler(event):
	if event.pressed and event.button_index== 1: #1-> LMB, 2 -> RMB
		Input.set_custom_mouse_cursor(click)
	if event.is_released() and event.button_index== 1: #1-> LMB, 2 -> RMB
		Input.set_custom_mouse_cursor(cursor)
