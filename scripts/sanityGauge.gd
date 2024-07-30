extends Sprite2D
var san
var eyecover
var eye
var sanity=100

# Called when the node enters the scene tree for the first time.
func _ready():
	
	san=find_child("Sanity")
	eyecover=find_child("SanEyeCover")
	eye=find_child("TheEye")
	updateSanity()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if sanity-delta*10 > 0:
		sanity-=delta*10
	
	updateSanity()
	glance()

func updateSanity():
	san.scale.x =sanity/100
	if(sanity<60):
		eyecover.self_modulate.a=(sanity-10)*0.02
	else:
		eyecover.self_modulate.a=1
func glance():
	var mpos=(get_local_mouse_position()-(get_window().size/2.0-position))/(get_window().size*1.0)
	
	eye.position.x=-159+sin(clamp(mpos.x,-1.5,1.5))*25+randi_range(-4,4)*(60-sanity)/120
	eye.position.y=sin(clamp(mpos.y,-1.5,1.5))*10+randi_range(-3,3)*(60-sanity)/120
	eye.scale.x=0.25+0.75*cos(clamp(mpos.x,-1.5,1.5))+randf_range(-.01,.01)*(60-sanity)/120
	eye.scale.y=0.6+0.4*cos(clamp(mpos.y,-1.5,1.5))+randf_range(-.01,.01)*(60-sanity)/120
	
	
