@tool
extends Control

@export_category("Colour")
@export var bgColour: Color
@export var hlColour: Color
@export var sepColour: Color

@export_category("Variables")
@export var outRad: int = 128
@export var inRad: int = 32
@export var lineWidth: int = 3

const spriteSize: Vector2 = Vector2(32, 32)
var flagOptions: int = 6

var selection: String = "neutral"
var selNr: int

var options: Array[optSlice] = []

@onready var sfx: AudioStreamPlayer = $hoverSound

func _ready() -> void:
	for i: int in flagOptions:
		options.append(optSlice.new())
	options[0].initiate("Neutral", 1, ["flagNeutral"])
	options[1].initiate("Flamel", 1, ["Flamel5"])
	options[2].initiate("Numbered", 5, [""])
	options[3].initiate("Herb", 3, ["Herb1", "Herb2", "Herb3"])
	options[4].initiate("Salt", 3, ["Salt1", "Salt2", "Salt3"])
	options[5].initiate("Shroom", 3, ["Shroom1", "Shroom2", "Shroom3"])

func _draw() -> void:
	draw_circle(Vector2.ZERO, outRad, bgColour)
	
	var radInc: float = PI * 2 / (len(options) - 1)
	var rads: float = (selNr - 1) * radInc - PI/2 - radInc/2
	var ppArc: int = 32
	var points: Vector2 = Vector2.from_angle(rads)
	var pInner: PackedVector2Array
	var pOuter: PackedVector2Array
	
	
	
	if selection == "Flamel":
		for i: int in ppArc:
			var ang = rads + i * radInc / (ppArc-1)
			pInner.append(inRad * Vector2.from_angle(ang))
			pOuter.append(outRad * Vector2.from_angle(ang))
	elif selection.left(-1) == "Numbered":
		var ring: float = (outRad - inRad) / 2
		var radius: int = 1
		var numRadInc: float = radInc
		if selection.to_int() < 4:
			radius = 2
			numRadInc /= 3
		else:
			numRadInc /= 2
		for i: int in ppArc/2:
			var ang = rads + numRadInc * ((selection.to_int() - 1) % 3) + i * numRadInc / (ppArc/2-1)
			pInner.append((inRad + (ring * (radius - 1))) * Vector2.from_angle(ang))
			pOuter.append((inRad + (ring * radius)) * Vector2.from_angle(ang))
	elif selection != "Neutral":
		var ring: float = (outRad - inRad) / options[selNr].levels
		for i: int in ppArc:
			var ang = rads + i * radInc / (ppArc-1)
			pInner.append((inRad + (ring * (selection.to_int() - 1))) * Vector2.from_angle(ang))
			pOuter.append((inRad + (ring * selection.to_int())) * Vector2.from_angle(ang))
		
	
	if selection == "Neutral":
		draw_circle(Vector2.ZERO, inRad, hlColour)
	else:
		pOuter.reverse()
		var hl: PackedColorArray = PackedColorArray([hlColour])
		draw_polygon((pInner + pOuter), hl)
	
	for i: int in range(len(options) -1):
		rads = i * radInc - PI/2 - radInc/2
		points = Vector2.from_angle(rads)
		draw_line(points * inRad, points * outRad, sepColour, lineWidth, false)
		for j: int in options[i+1].levels:
			if i == 1:
				@warning_ignore("integer_division")
				draw_arc(Vector2.ZERO, (inRad + outRad)/2, rads, rads+ radInc, 32, sepColour, lineWidth, false)
				draw_line(Vector2.from_angle(rads+radInc/2) * inRad, Vector2.from_angle(rads+radInc/2) * (inRad + outRad)/2, sepColour, lineWidth, false)
				draw_line(Vector2.from_angle(rads+radInc/3) * outRad, Vector2.from_angle(rads+radInc/3) * (inRad + outRad)/2, sepColour, lineWidth, false)
				draw_line(Vector2.from_angle(rads+radInc*2/3) * outRad, Vector2.from_angle(rads+radInc*2/3) * (inRad + outRad)/2, sepColour, lineWidth, false)
			else:
				@warning_ignore("integer_division")
				var height: int = (outRad-inRad) / options[i+1].levels
				draw_arc(Vector2.ZERO, inRad + height * j, rads, rads + radInc, 32, sepColour, lineWidth, false)
	
	draw_arc(Vector2.ZERO, inRad, 0 , 2*PI, 64, sepColour, lineWidth, false)
	draw_arc(Vector2.ZERO, outRad, 0 , 2*PI, 64, sepColour, lineWidth, false)
	draw_texture(options[0].symbols[0], -spriteSize / 2)
	
	for i: int in range(len(options)-1):
		var mRads: float = i * radInc - PI/2 - radInc/6
		@warning_ignore("integer_division")
		var incRad: float = (outRad-inRad) / (len(options[i+1].symbols))
		
		if i == 0:
			draw_texture(options[1].symbols[0], Vector2.from_angle(mRads + radInc/6) * ((incRad/2) + inRad) - spriteSize/2)
		
		if i == 1:
			var offSet: int = outRad / 12
			draw_circle(Vector2.from_angle(mRads - radInc/6)* (outRad - (outRad - inRad)/4), lineWidth * 2 , Color.BLACK)
			draw_circle(Vector2.from_angle(mRads + radInc/9)* (outRad + offSet - (outRad - inRad)/4), lineWidth, Color.BLACK)
			draw_circle(Vector2.from_angle(mRads + radInc*2/9)* (outRad - offSet - (outRad - inRad)/4), lineWidth, Color.BLACK)
			draw_circle(Vector2.from_angle(mRads + radInc/2)* (outRad - (outRad - inRad)/4), lineWidth, Color.BLACK)
			draw_circle(Vector2.from_angle(mRads - radInc/12 + radInc/2)* (outRad + offSet - (outRad - inRad)/4), lineWidth, Color.BLACK)
			draw_circle(Vector2.from_angle(mRads + radInc/12 + radInc/2)* (outRad - offSet - (outRad - inRad)/4), lineWidth, Color.BLACK)
			
			draw_circle(Vector2.from_angle(mRads + radInc/3*0.95)* (inRad + offSet + (outRad - inRad)/4), lineWidth, Color.BLACK)
			draw_circle(Vector2.from_angle(mRads + radInc/3)* (inRad - offSet + (outRad - inRad)/4), lineWidth, Color.BLACK)
			draw_circle(Vector2.from_angle(mRads + radInc/2*1.1)* (inRad + offSet + (outRad - inRad)/4), lineWidth, Color.BLACK)
			draw_circle(Vector2.from_angle(mRads + radInc/2)* (inRad - offSet + (outRad - inRad)/4), lineWidth, Color.BLACK)
			draw_circle(Vector2.from_angle(mRads + radInc*3/7)* (inRad + (outRad - inRad)/4), lineWidth, Color.BLACK)
			
			draw_circle(Vector2.from_angle(mRads - radInc/6*1.1)* (inRad + offSet + (outRad - inRad)/4), lineWidth, Color.BLACK)
			draw_circle(Vector2.from_angle(mRads - radInc/6)* (inRad - offSet + (outRad - inRad)/4), lineWidth, Color.BLACK)
			draw_circle(Vector2.from_angle(mRads*0.95)* (inRad + offSet + (outRad - inRad)/4), lineWidth, Color.BLACK)
			draw_circle(Vector2.from_angle(mRads)* (inRad - offSet + (outRad - inRad)/4), lineWidth, Color.BLACK)
		
		for j: int in len(options[i+1].symbols):
			if i > 1:
				draw_texture(options[i+1].symbols[j], Vector2.from_angle(mRads + radInc/3 * (j % 2)) * ((incRad * (j + .5)) + inRad) - spriteSize/2)

func _process(_delta: float) -> void:
	var mousePos: Vector2 = get_local_mouse_position()
	var mouseRad: float = mousePos.length()
	var sel: String = ""
	if mouseRad < inRad:
		sel = "Neutral"
	else:
		var mouseRads: float = fposmod(mousePos.angle() + PI/2 + (PI / (len(options)-1)), 2 * PI)
		selNr = ceil(mouseRads / ((2 * PI) / (len(options)-1)))
		sel = options[selNr].name
		if sel == "Shroom" or sel == "Salt" or sel == "Herb":
			sel += str(clamp(ceil(((mouseRad-inRad) / (outRad-inRad)) * options[selNr].levels), 1, options[selNr].levels))
		if sel == "Numbered":
			if mouseRad < inRad + (outRad - inRad) / 2:
				sel += str(ceil(mouseRads / ((2 * PI) / (2*(len(options)-1))))+1)
			else:
				sel += str(ceil(mouseRads / ((2 * PI) / (3*(len(options)-1))))-3)
	if selection != sel:
		selection = sel
		sfx.play()
	queue_redraw()
	if mouseRad > outRad * 1.3:
		signalBus.flagging.emit("")

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_released():
		signalBus.flagging.emit(selection)

class optSlice:
	var name: String
	var levels: int
	var symbols: Array[Texture2D]
	
	func initiate(n: String, l: int, s: Array) -> void:
		name = n
		levels = l
		for i: int in len(s):
			symbols.append(load("res://assets/textures/ingredients/" + s[i] + ".png"))
	
	func _to_string() -> String:
		return name
