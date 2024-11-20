extends Node2D

@onready var lbMsg: RichTextLabel = $background/stacker/message
var lHeight: int = 40
var lLen: int = 64
var width: int = 450


func initi(txt: String) -> bool:
	
	var lines: int = len(txt) / lLen +1
	var height: int = lines * lHeight
	
	lbMsg.custom_minimum_size = Vector2i(width, height)
	lbMsg.text = "[center]" + txt + "[/center]"
	signalBus.deactivate.emit(false)
	return true

func _on_continue_pressed() -> void:
	signalBus.deactivate.emit(true)
	self.queue_free()
