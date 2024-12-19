extends Node

var tool: Control = null
var place: Node2D = null
var held: bool = false

var speed: float = 50
var rotSpeed: float = .3
var rotThresh: float = 5

func _ready() -> void:
	tool = get_parent()
	if not tool.get_meta("tool"): #tests and alarms if the placement is wrong
		print("Toolerror 1: false placement of DragDropper in" + tool.to_string())
	place = tool.get_node("placer")
	set_physics_process(false)

func _physics_process(delta: float) -> void: # tool movement
	held = true
	var posOld: Vector2 = place.global_position
	place.global_position = lerp(place.global_position, place.get_global_mouse_position() , speed * delta)
	if tool.get_meta(&"rot"):
		if max(abs(posOld.x - place.global_position.x), abs(posOld.y - place.global_position.y)) > rotThresh:
			place.rotate(place.get_angle_to(place.get_global_mouse_position()) * delta * rotSpeed * (posOld - place.global_position).length())



func _on_pick_up_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("pickUpTool"):
		print(globalVariables.holdable)
		if globalVariables.holdable:
			set_physics_process(true)
			globalVariables.holdable = false
			place.scale = Vector2(2, 2)
		elif held:
			set_physics_process(false)
			held = false
			globalVariables.holdable = true
			place.scale = Vector2(1, 1)
