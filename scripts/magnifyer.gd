extends Control

@onready var uncoverer: CharacterBody2D = $placer/uncover
var modeMax: int = 2
var time: bool = true
@export var cArray: Array[Color]

func _on_pick_up_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void: # handles opening and closing of the lexicon
	#if get_parent().name == "toolBox":
		if Input.is_action_pressed("activateTool"):
			if time:
				if uncoverer.get_meta("mode") >= modeMax:
					uncoverer.set_meta("mode", 0)
				else:
					uncoverer.set_meta("mode", uncoverer.get_meta("mode") + 1)
				$placer/toolSprite/dot.modulate = cArray[uncoverer.get_meta("mode")]
			time = false
			$hysterese.start()


func _on_hysterese_timeout() -> void:
	time = true
	$hysterese.stop
