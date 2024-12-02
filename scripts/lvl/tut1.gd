extends Node2D


var msg: PackedScene = preload("res://scenes/levels/tutorials/tutMsg.tscn")
@onready var time: Timer = $tutMsgTimer
var msgTxt: String = ""

func _init():
	globalVariables.size = 7
	for i: String in globalVariables.level:
		globalVariables.level[i] = 0
	for i: String in globalVariables.ingredientStack:
		globalVariables.ingredientStack[i] = 0
	globalVariables.ingredientStack["Shroom1"] = 13
	globalVariables.ingredientStack["Shroom2"] = 7
	globalVariables.ingredientStack["Shroom3"] = 3
	globalVariables.specials["Coffee"] = 0
	globalVariables.n = 1 - (3 * globalVariables.size) + (3 * (globalVariables.size * globalVariables.size))
	globalVariables.sanity = 100
	globalVariables.leveled1 = false
	signalBus.upsane.emit()
	globalVariables.buff["shield"] = 1
	globalVariables.xp.clear()
	globalVariables.xp["Shroom"] = 0.0
	globalVariables.lvl1 = "Shroom"
	globalVariables.rngseed = randi_range(0, 99)

func _ready():
	signalBus.lvlUp.connect(lvlup)
	var tst = msg.instantiate()
	add_child(tst)
	tst.initi(tr("msgTut10"))

func lvlup(lvl: int):
	time.start()
	msgTxt = tr("msgTut1" + str(lvl))


func _on_tut_msg_timer_timeout():
	var tst = msg.instantiate()
	add_child(tst)
	tst.initi(msgTxt)


func _on_next_pressed() -> void:
	globalVariables.mod = []
	get_tree().change_scene_to_file("res://scenes/levels/tutorials/tut2.tscn")
