extends Node2D
var sanity=1
var cursor = load("res://assets/textures/cursors/pincher.png")
var click= load("res://assets/textures/cursors/pincherCl.png")
var cursorLow = load("res://assets/textures/cursors/hand.png")
var clickLow = load("res://assets/textures/cursors/handCl.png")
var check = false
# Called when the node enters the scene tree for the first time.

func _ready():
	Input.set_custom_mouse_cursor( cursor)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if(sanity >0):
		#if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			#Input.set_custom_mouse_cursor(click)
			#check= true
		#elif check:
			#Input.set_custom_mouse_cursor(cursor)
			#check=false			
		#if(Input.is_action_just_pressed("ui_up")):
			#sanity=0
			#Input.set_custom_mouse_cursor(cursorLow)
	#else:
		#if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			#Input.set_custom_mouse_cursor(clickLow)
			#check= true
		#elif check:
			#Input.set_custom_mouse_cursor(cursorLow)
			#check=false
		#if(Input.is_action_just_pressed("ui_up")):
			#Input.set_custom_mouse_cursor(cursor)
			#sanity=1
	pass

func _unhandled_input(event):
	if event is InputEventMouseButton:
		mouseHandler(event)
	elif event is InputEventKey:
		keyHandler(event)
				
func mouseHandler(event):
	if sanity>0:
		if event.pressed and event.button_index== 1: #1-> LMB, 2 -> RMB
			Input.set_custom_mouse_cursor(click)
		if event.is_released() and event.button_index== 1: #1-> LMB, 2 -> RMB
			Input.set_custom_mouse_cursor(cursor)
	else:
		if event.pressed and event.button_index== 1: #1-> LMB, 2 -> RMB
			Input.set_custom_mouse_cursor(clickLow)
		if event.is_released() and event.button_index== 1: #1-> LMB, 2 -> RMB
			Input.set_custom_mouse_cursor(cursorLow)

func keyHandler(event):
	if event.pressed and event.keycode==KEY_S:
		if sanity >0:
			sanity=0
			Input.set_custom_mouse_cursor(cursorLow)
		else:
			sanity =1
			Input.set_custom_mouse_cursor(cursor)
