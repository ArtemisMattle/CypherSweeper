extends Node2D

var tools: Array[globalVariables.tool] # array for all tools in the toolHandler, aka the worldSpace
var held: globalVariables.tool = null
var speed: float = 50
var deactivated: bool = false
var rotSpeed: float = .3
var rotThresh: float = 5

func _ready() -> void:
	globalVariables.holdable = true
	signalBus.toolTrans.connect(takeTool)
	signalBus.deactivate.connect(deactivate)
	set_physics_process(false)
	
func takeTool(t: globalVariables.tool) -> void: # recieves a tool from the parent juggling
	if t in tools:
		tools.erase(t)
	else:
		tools.append(t)
		t.tScene.reparent(self)
		t.place.global_position
		t.pickUp.input_event.connect(giveTool.bind(t))
		held = t
		held.place.global_position = get_global_mouse_position()
		globalVariables.holdable = false
		set_physics_process(true)
		

func _physics_process(delta: float) -> void:
	if held != null:
		var posOld: Vector2 = held.place.global_position
		held.place.global_position = lerp(held.place.global_position, get_global_mouse_position() , speed * delta)
		if held.place.get_meta(&"rot"):
			if max(abs(posOld.x - held.place.global_position.x), abs(posOld.y - held.place.global_position.y)) > rotThresh:
				held.place.rotate(held.place.get_angle_to(get_global_mouse_position()) * delta * rotSpeed * (posOld - held.place.global_position).length())

func giveTool(viewport: Node, event: InputEvent, shape_idx: int, t: globalVariables.tool) -> void: #handles the drag&drop for the tools, as well as the parent juggling
	if Input.is_action_pressed("pickUpTool"):
		if globalVariables.holdable:
			held = t
			globalVariables.holdable = false
			set_physics_process(true)
	if t == held:
		if Input.is_action_pressed("pickUpTool"):
			if t.to_string() == "magnifyer":
				t.place.get_node("uncover").set_meta("enabled", true)
		else:
			set_physics_process(false)
			held = null
			globalVariables.holdable = true
			if t.to_string() == "magnifyer":
				t.place.get_node("uncover").set_meta("enabled", false)
			if globalVariables.boxing:
				signalBus.toolTrans.emit(t)
				t.pickUp.input_event.disconnect(giveTool)

func deactivate(r: bool) -> void:
	globalVariables.holdable = r
	held = null
	deactivated = not r
	set_physics_process(false)
