extends Sprite2D
var san
var eyecover
var eye

# Called when the node enters the scene tree for the first time.
func _ready():
	
	san=find_child("Sanity")
	eyecover=find_child("SanEyeCover")
	eye=find_child("TheEye")
	updateSanity()
	signalBus.upsane.connect(updateSanity)

func _process(_delta):
	glance()

func updateSanity():
	san.value = globalVariables.sanity
	if(globalVariables.sanity<60):
		eyecover.self_modulate.a=(globalVariables.sanity-10)*0.02
	else:
		eyecover.self_modulate.a=1

func glance():
	var mpos=(get_local_mouse_position()-(get_window().size/2.0-position))/(get_window().size*1.0)
	
	eye.position.x=-159+sin(clamp(mpos.x,-1.5,1.5))*25+randi_range(-4,4)*(60-globalVariables.sanity)/120
	eye.position.y=sin(clamp(mpos.y,-1.5,1.5))*10+randi_range(-3,3)*(60-globalVariables.sanity)/120
	eye.scale.x=0.25+0.75*cos(clamp(mpos.x,-1.5,1.5))+randf_range(-.01,.01)*(60-globalVariables.sanity)/120
	eye.scale.y=0.6+0.4*cos(clamp(mpos.y,-1.5,1.5))+randf_range(-.01,.01)*(60-globalVariables.sanity)/120
	
	
