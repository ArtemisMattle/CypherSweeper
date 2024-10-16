extends Camera2D
const minZoom: float = 0.5
const maxZoom: float = 2.0
const zoomInc: float = 0.05
const zoomRate: float = 7.0
var tZoom: float = 2.0

func _physics_process(delta):
	if not globalVariables.paused:
		zoom = lerp(zoom, tZoom * Vector2.ONE, zoomRate * delta)
		set_physics_process(not is_equal_approx(zoom.x, tZoom))

func _unhandled_input(event: InputEvent):
	if not globalVariables.paused:
		if Input.is_action_pressed("pan"):
			if event is InputEventMouseMotion:
				position -= event.relative / zoom
		if Input.is_action_pressed("zoom in"):
			zoom_in()
		if Input.is_action_pressed("zoom out"):
			zoom_out()
		if Input.is_action_pressed("move up"):
			pass
		if Input.is_action_pressed("move down"):
			pass
		if Input.is_action_pressed("move right"):
			pass
		if Input.is_action_pressed("move left"):
			pass
	globalVariables.camPos = position

func zoom_in():
	tZoom = min(tZoom + zoomInc, maxZoom)
	set_physics_process(true)
func zoom_out():
	tZoom = max(tZoom - zoomInc, minZoom)
	set_physics_process(true)
