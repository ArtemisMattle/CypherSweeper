extends Control

var held: bool = false
var holdable: bool = true
var speed: float = 25
@export var upy: float = 400
@export var downy: float = 20
var openy: float = 450
var closey: float = 670

func _ready() -> void:
	signalBus.deactivate.connect(deactivate)
	set_physics_process(false)
	held = false
	global_position.y = 720 - downy

func deactivate(r) -> void:
	held = false
	holdable = r

func _physics_process(delta) -> void:
	var miny: float = 720 - upy
	var maxy: float = 720 - downy
	global_position.y = clamp(lerp(global_position.y, get_global_mouse_position().y , speed * delta), miny, maxy)
	
	set_physics_process(held)

func _on_pick_up_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if holdable:
		held = Input.is_action_pressed("pickUpTool")
		set_physics_process(held)
