extends Node2D

var tools: Array[globalVariables.tool] # array for all tools in the toolHandler, aka the worldSpace

func _ready() -> void:
	globalVariables.holdable = true
	signalBus.toolTrans.connect(takeTool)

func takeTool(t: globalVariables.tool) -> void: # recieves a tool from the parent juggling
	if t in tools:
		tools.erase(t)
	else:
		tools.append(t)
		t.tScene.reparent(self)
		t.place.global_position
		t.pickUp.input_event.connect(giveTool.bind(t))

func giveTool(viewport: Node, event: InputEvent, shape_idx: int, t: globalVariables.tool) -> void: #handles the drag&drop for the tools, as well as the parent juggling
	if Input.is_action_pressed("pickUpTool"):
		if globalVariables.holdable:
			globalVariables.holdable = false
			signalBus.toolTrans.emit(t)
			t.pickUp.input_event.disconnect(giveTool)


