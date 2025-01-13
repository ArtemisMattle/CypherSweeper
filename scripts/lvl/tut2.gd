extends Node2D


var msg: PackedScene = preload("res://scenes/levels/tutorials/tutMsg.tscn")
@onready var time: Timer = $tutMsgTimer
var msgTxt: String = ""
var newMsg: bool = false
var nextMsg: Array[String] = []
var lvl1: int = 0
var lvl3: int = 0

func _init() -> void:
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
	globalVariables.specials["coffee"] = 0
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

func _ready() -> void:
	signalBus.lvlUp.connect(lvlup)
	signalBus.upsane.connect(dmg)
	var tst = msg.instantiate()
	add_child(tst)
	tst.initi(tr("msgTut20"))
	message("msgTut21")

func message(txt: String) -> void:
	if not newMsg:
		time.start()
		msgTxt = tr(txt)
		newMsg = true
	else:
		nextMsg.append(txt)

func lvlup(ingr: String) -> void:
	if globalVariables.level[ingr] == 1:
		lvl1 += 1
		if lvl1 == 1:
			message(tr("msgTut22") % tr(ingr))
		elif lvl1 == 3:
			message("msgTut23")
	if globalVariables.level[ingr] == 3:
		lvl3 += 1
		if lvl3 == 3:
			message("msgTut24")

func dmg() -> void:
	if globalVariables.sanity < 1:
		return
	if globalVariables.sanity < 100:
		if not globalVariables.tutDamaged:
			globalVariables.tutDamaged = true
			message("msgTutDmg")

func _on_tut_msg_timer_timeout() -> void:
	if globalVariables.sanity < 1:
		return
	var tst = msg.instantiate()
	add_child(tst)
	tst.initi(msgTxt)
	newMsg = false
	if not nextMsg.is_empty():
		message(nextMsg[0])
		nextMsg.remove_at(0)


func _on_next_pressed() -> void:
	globalVariables.mod = []
	get_tree().change_scene_to_file("res://scenes/levels/tutorials/tut3.tscn")
