extends Node2D


var msg: PackedScene = preload("res://scenes/levels/tutorials/tutMsg.tscn")
@onready var time: Timer = $tutMsgTimer
var msgTxt: String = ""

func _init():
	globalVariables.size = 5
	globalVariables.ingredientStack["Herb1"] = 13
	globalVariables.n = 1 - (3 * globalVariables.size) + (3 * (globalVariables.size * globalVariables.size))
	globalVariables.sanity = 100
	globalVariables.leveled1 = false
	signalBus.upsane.emit()
	globalVariables.buff["shield"] = 1
	globalVariables.xp.clear()
	globalVariables.xp["Herb"] = 0.0


func _ready():
	signalBus.lvlNothing.connect(lvlup)
	var tst = msg.instantiate()
	add_child(tst)
	tst.position = Vector2i(640, 360)
	tst.initi("Welcome to the Cypher Sweeper Tutorial, in this level you will learn the absolute basics of the gameplay and how to win a game. To start uncover a cell by left clicking it, after closing this message.")

func lvlup():
	time.start()
	msgTxt = "Now that you learned a bit about the recipe you are decyfering, you are ready for the more dangerous knowledge, or [b] Ingredients [/b] as we'll call them, but be careful not to touch the [b] Flamel [/b] yet, it has a value of 5."

func flamel():
	time.start()
	msgTxt = "You have almost complete knowledge over that recipe, all that is left to do is uncover the [b] Flamel [/b] it functions similar to an 8 Ball in billiards."

func _on_tut_msg_timer_timeout():
	var tst = msg.instantiate()
	add_child(tst)
	tst.position = Vector2i(640, 360)
	tst.initi(msgTxt)
