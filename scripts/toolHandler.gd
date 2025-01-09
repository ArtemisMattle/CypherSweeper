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
			if t.tScene.get_parent() == self:
				pass
			else:
				t.tScene.reparent(self)
				tools.append(t)
	else:
		if globalVariables.boxing:
			tools.erase(t)
		if t.tScene.get_meta("boxTool"):
			t.tScene.reparent(self)
			tools.append(t)



