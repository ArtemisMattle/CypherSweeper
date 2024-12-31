extends Camera2D
const minZoom: float = 0.5
const maxZoom: float = 2.0
const zoomInc: float = 0.05
const zoomRate: float = 7.0
var tZoom: float = 2.0
var direction: Vector2 = Vector2.ZERO
var speed: float = 420


func _process(delta: float) -> void: # mouse movement
	if globalVariables.paused:
		return
	var mp = get_local_mouse_position()
	if direction != Vector2.ZERO:
		direction = direction.normalized()
		position += direction * speed * delta * 10
		direction = Vector2.ZERO
	if globalVariables.tbOpen: # disables mouse movement, if the toolbox is opened
		return
	if globalVariables.psOpen: # disables mouse movement, if the toolbox is opened
		return
	if mp.x > 600 / tZoom or mp.x < -600 / tZoom or mp.y > 280 / tZoom or mp.y < -310 / tZoom:
		return
	if mp.x > 420 / tZoom:
		position.x += speed * delta / tZoom
	elif mp.x < -420 / tZoom:
		position.x -= speed * delta / tZoom
	if mp.y > 200 / tZoom:
		position.y += speed * delta / tZoom
	elif mp.y < -200 / tZoom:
		position.y -= speed * delta / tZoom

func _physics_process(delta):
	if not globalVariables.paused:
		zoom = lerp(zoom , tZoom * Vector2.ONE, zoomRate * delta)
		set_physics_process(not is_equal_approx(zoom.x, tZoom))

func _unhandled_input(event: InputEvent): #inputs through the input system
	if not globalVariables.paused:
		#if Input.is_action_pressed("pan"):
			#if event is InputEventMouseMotion:
				#position -= event.relative / zoom
		if Input.is_action_pressed("zoom in"):
			zoom_in()
		if Input.is_action_pressed("zoom out"):
			zoom_out()
		if Input.is_action_pressed("move up"):
			direction = direction + Vector2.UP
		if Input.is_action_pressed("move down"):
			direction = direction + Vector2.DOWN
		if Input.is_action_pressed("move right"):
			direction = direction + Vector2.RIGHT
		if Input.is_action_pressed("move left"):
			direction = direction + Vector2.LEFT

func zoom_in():
	tZoom = min(tZoom + zoomInc, maxZoom)
	set_physics_process(true)
func zoom_out():
	tZoom = max(tZoom - zoomInc, minZoom)
	set_physics_process(true)
