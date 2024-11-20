extends Node2D


# Called when the node enters the scene tree for the first time.


func _init():
	globalVariables.size = 7
	globalVariables.ingredientStack["Shroom1"] = 20
	globalVariables.ingredientStack["Shroom2"] = 10
	globalVariables.ingredientStack["Shroom3"] = 5
	globalVariables.n = 1 - (3 * globalVariables.size) + (3 * (globalVariables.size * globalVariables.size))
	globalVariables.sanity = 100
	globalVariables.leveled1 = false
	signalBus.upsane.emit()
	globalVariables.buff["shield"] = 1
	globalVariables.xp.clear()
	globalVariables.xp["Shroom"] = 0.0
