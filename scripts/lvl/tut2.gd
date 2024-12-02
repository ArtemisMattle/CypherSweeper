extends Node2D


var msg: PackedScene = preload("res://scenes/levels/tutorials/tutMsg.tscn")
@onready var time: Timer = $tutMsgTimer
var msgTxt: String = ""
var lvl1: int = 0
var lvl3: int = 0

func _init():
	globalVariables.size = 9
	for i: String in globalVariables.level:
		globalVariables.level[i] = 0
	for i: String in globalVariables.ingredientStack:
		globalVariables.ingredientStack[i] = 0
	globalVariables.ingredientStack["Herb1"] = 13
	globalVariables.ingredientStack["Herb2"] = 7
	globalVariables.ingredientStack["Herb3"] = 3
	globalVariables.ingredientStack["Shroom1"] = 13
	globalVariables.ingredientStack["Shroom2"] = 7
	globalVariables.ingredientStack["Shroom3"] = 3
	globalVariables.ingredientStack["Salt1"] = 13
	globalVariables.ingredientStack["Salt2"] = 7
	globalVariables.ingredientStack["Salt3"] = 3
	globalVariables.specials["Coffee"] = 0
	globalVariables.n = 1 - (3 * globalVariables.size) + (3 * (globalVariables.size * globalVariables.size))
	globalVariables.sanity = 100
	globalVariables.leveled1 = false
	signalBus.upsane.emit()
	globalVariables.buff["shield"] = 1
	globalVariables.xp.clear()
	globalVariables.xp["Herb"] = 0.0
	globalVariables.xp["Shroom"] = 0.0
	globalVariables.xp["Salt"] = 0.0
	globalVariables.rngseed = randi_range(0, 99)
	globalVariables.lvl1 = globalVariables.xp.keys().pick_random()

func _ready():
	signalBus.lvlUp.connect(lvlup)
	var tst = msg.instantiate()
	add_child(tst)
	tst.initi(tr("msgTut20"))

func lvlup(ingr: String):
	if globalVariables.level[ingr] == 1:
		lvl1 += 1
		if lvl1 == 1:
			msgTxt = tr("msgTut21") % tr(ingr)
			time.start()
		elif lvl1 == 3:
			msgTxt = tr("msgTut22")
			time.start()
	if globalVariables.level[ingr] == 3:
		lvl3 += 1
		if lvl3 == 3:
			msgTxt = tr("msgTut23")
			time.start()


func _on_tut_msg_timer_timeout():
	var tst = msg.instantiate()
	add_child(tst)
	tst.initi(msgTxt)


func _on_next_pressed() -> void:
	globalVariables.mod = []
	get_tree().change_scene_to_file("res://scenes/levels/tutorials/tut1.tscn")
