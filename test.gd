extends Control
var speed: float = 30
var rot: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var posOld: Vector2 = $node2d.global_position
	$node2d.global_position = lerp($node2d.global_position, get_global_mouse_position() , speed * delta)
	if max(abs(abs(posOld.x)-abs($node2d.global_position.x)), abs(abs(posOld.y)-abs($node2d.global_position.y))) > 2.5:
		rot = lerp(rot, $node2d.get_angle_to(get_global_mouse_position())+(PI/2), 1)
		$node2d.rotate(rot)

