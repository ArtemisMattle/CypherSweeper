extends Node2D


var msg: PackedScene = preload("res://scenes/levels/tutorials/tutMsg.tscn")
@onready var time: Timer = $tutMsgTimer
var msgTxt: String = ""

func _init() -> void:
	globalVariables.size = 5
	for i: String in globalVariables.level:
		globalVariables.level[i] = 0
	for i: String in globalVariables.ingredientStack:
		globalVariables.ingredientStack[i] = 0
	globalVariables.ingredientStack["Herb1"] = 13
	globalVariables.specials["coffee"] = 0
	globalVariables.n = 1 - (3 * globalVariables.size) + (3 * (globalVariables.size * globalVariables.size))
	globalVariables.sanity = 100
	globalVariables.leveled1 = false
	signalBus.upsane.emit()
	globalVariables.buff["shield"] = 1
	globalVariables.xp.clear()
	globalVariables.xp["Herb"] = 0.0
	globalVariables.lvl1 = "Herb"
	globalVariables.rngseed = randi_range(0,99)


func _ready() -> void:
	signalBus.lvlNothing.connect(lvlup)
	signalBus.lvlFlamel.connect(flamel)
	signalBus.upsane.connect(dmg)
	var tst = msg.instantiate()
	add_child(tst)
	tst.initi(tr("msgTut00"))

func lvlup() -> void:
	time.start()
	msgTxt = tr("msgTut01")

func flamel() -> void:
	time.start()
	msgTxt = tr("msgTut02")

func dmg() -> void:
	if globalVariables.sanity < 100:
		if not globalVariables.tutDamaged:
			globalVariables.tutDamaged = true
			time.start()
			msgTxt = tr("msgTutDmg")

func _on_tut_msg_timer_timeout() -> void:
	var tst = msg.instantiate()
	add_child(tst)
	tst.initi(msgTxt)


func _on_next_pressed() -> void:
	globalVariables.mod = []
	get_tree().change_scene_to_file("res://scenes/levels/tutorials/tut1.tscn")
