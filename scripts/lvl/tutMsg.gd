extends Node2D

@onready var lbMsg: RichTextLabel = $layer/background/stacker/message
var lHeight: int = 40
var lLen: int = 64
var width: int = 450


func initi(txt: String, pos: Vector2i = Vector2i(640, 360)) -> bool:
	
	Engine.time_scale = 0
	
	var lines: int = len(txt) / lLen +1
	var height: int = lines * lHeight
	
	$layer/background.position = pos - Vector2i(width, height+50)
	
	lbMsg.custom_minimum_size = Vector2i(width, height)
	lbMsg.text = "[center]" + txt + "[/center]"
	signalBus.deactivate.emit(false)
	return true

func _on_continue_pressed() -> void:
	Engine.time_scale = 1
	signalBus.deactivate.emit(true)
	self.queue_free()
