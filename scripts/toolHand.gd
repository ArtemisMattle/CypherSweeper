extends Node2D

var tools: Array[globalVariables.tool] # array for all tools in the toolHandler, aka the worldSpace

func _ready() -> void:
	globalVariables.holdable = true
	signalBus.toolTrans.connect(takeTool)

func takeTool(t: globalVariables.tool, held: bool) -> void: # recieves a tool from the parent juggling
	if held:
		if t.tScene.get_meta("boxTool"):
			pass
		else:
			t.tScene.reparent(self)
			tools.append(t)
	else:
		tools.erase(t)
