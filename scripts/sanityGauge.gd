extends Sprite2D
@onready var san: TextureProgressBar = $Sanity
@onready var eyecover: Sprite2D = $SanEyeCover
@onready var eye: Sprite2D = $TheEye
var shutter: int = 0
var eyePos: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	updateSanity()
	signalBus.upsane.connect(updateSanity)
	eyePos = eye.position

func _process(_delta):
	glance()
	if abs(shutter - eyecover.position.y) > 4:
		if shutter > eyecover.position.y:
			eyecover.position.y = clamp(eyecover.position.y + 3 * _delta, 0, shutter)
		else:
			eyecover.position.y = clamp(eyecover.position.y - 3 * _delta, shutter, 100)

func updateSanity():
	san.value = globalVariables.sanity
	if globalVariables.sanity > 90:
		shutter = 0
	elif globalVariables.sanity > 50:
		shutter =  (90 - globalVariables.sanity) * 2.5
	else:
		shutter = 100

func glance():
	var mpos=(get_local_mouse_position()-eyePos) / (get_window().content_scale_factor * 1000)
	
	eye.position.x=-160+sin(clamp(mpos.x,-1.5,1.5))*25+randi_range(-1,1)*(60-globalVariables.sanity)/30
	eye.position.y=sin(clamp(mpos.y,-1.5,1.5))*20+randi_range(-1,1)*(60-globalVariables.sanity)/40
	eye.scale.x=0.25+0.75*cos(clamp(mpos.x,-1.5,1.5))+randf_range(-.01,.01)*(60-globalVariables.sanity)/120
	eye.scale.y=0.6+0.4*cos(clamp(mpos.y,-1.5,1.5))+randf_range(-.01,.01)*(60-globalVariables.sanity)/120
	
	
