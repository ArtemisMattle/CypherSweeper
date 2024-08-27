extends Sprite2D

var held: bool = false
var holdable: bool = true
var speed: float = 25

func _ready() -> void:
	signalBus.deactivate.connect(deactivate)

func deactivate(r) -> void:
	held = false
	holdable = r

func _physics_process(delta):
	global_position = lerp(global_position, get_global_mouse_position() , speed * delta)
	set_physics_process(held)

func _on_pick_up_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if holdable:
		held = Input.is_action_pressed("pickUpTool")
		set_physics_process(held)
		$uncover.set_meta("enabled", held)
