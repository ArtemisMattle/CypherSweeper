@tool
extends Control

@export_category("Colour")
@export var bgColour: Color
@export var sepColour: Color

@export_category("Variables")
@export var outRad: int = 128
@export var inRad: int = 32
@export var lineWidth: int = 3

const spriteSize: Vector2 = Vector2(32, 32)
var flagOptions: int = 6

var options: Array[optSlice] = []

func _ready() -> void:
	for i: int in flagOptions:
		options.append(optSlice.new())
	options[0].initiate("neutral", 1, ["flagNeutral"])
	options[1].initiate("flamel", 1, ["Flamel5"])
	options[2].initiate("numbered", 5, ["OpenDyslexicThree-1","OpenDyslexicThree-2","OpenDyslexicThree-3","OpenDyslexicThree-4","OpenDyslexicThree-5"])
	options[3].initiate("herb", 3, ["Herb1", "Herb2", "Herb3"])
	options[4].initiate("salt", 3, ["Salt1", "Salt2", "Salt3"])
	options[5].initiate("shroom", 3, ["Shroom1", "Shroom2", "Shroom3"])

func _draw() -> void:
	draw_circle(Vector2.ZERO, outRad, bgColour)
	draw_arc(Vector2.ZERO, inRad, 0 , 2*PI, 64, sepColour, lineWidth, false)
	draw_arc(Vector2.ZERO, outRad, 0 , 2*PI, 64, sepColour, lineWidth, false)
	
	var radInc = PI * 2 / (len(options) - 1)
	
	for i: int in range(len(options) -1):
		var rads = i * radInc - PI/2 - radInc/2
		var points = Vector2.from_angle(rads)
		draw_line(points * inRad, points * outRad, sepColour, lineWidth, false)
		for j in options[i+1].levels:
			var height: int = (outRad-inRad) / options[i+1].levels
			draw_arc(Vector2.ZERO, inRad + height * j, rads, rads + radInc, 32, sepColour, lineWidth, false)
	
	draw_texture(options[0].symbols[0], -spriteSize / 2)
	
	for i: int in range(len(options)-1):
		var mRads: float = i * radInc - PI/2 - radInc/6
		var incRad: float = (outRad-inRad) / (len(options[i+1].symbols))
		
		if i == 0:
			draw_texture(options[1].symbols[0], Vector2.from_angle(mRads + radInc/6) * ((incRad/2) + inRad) - spriteSize/2)
		
		for j: int in len(options[i+1].symbols):
			if i > 0:
				draw_texture(options[i+1].symbols[j], Vector2.from_angle(mRads + radInc/3 * (j % 2)) * ((incRad * (j + .5)) + inRad) - spriteSize/2)


func _process(delta: float) -> void:
	queue_redraw()


class optSlice:
	var name: String
	var levels: int
	var symbols: Array[Texture2D]
	
	func initiate(n: String, l: int, s: Array) -> void:
		name = n
		levels = l
		for i: int in len(s):
			symbols.append(load("res://assets/textures/ingredients/" + s[i] + ".png"))
