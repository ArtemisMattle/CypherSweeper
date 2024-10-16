extends Control

var openBig: bool = false
var open: bool = false
var time: bool = true


func _ready() -> void:
	$placer/toolSprite.visible = true
	$placer/pickUp/boxClosed.visible = true
	$placer/openBook.visible = false
	$placer/pickUp/boxOpen.visible = false
	$placer/openBook.rotate(PI/2)
	
	
	for bigLexicon: TextureButton in get_tree().get_nodes_in_group("bigLex"):
		bigLexicon.pressed.connect(_on_big_lexicon_pressed)

func _on_pick_up_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void: # handles opening and closing of the lexicon
	if get_parent().name == "toolHandler":
		if Input.is_action_pressed("activateTool"):
			if time:
				if open:
					$placer/toolSprite.visible = true
					$placer/pickUp/boxClosed.visible = true
					$placer/openBook.visible = false
					$placer/pickUp/boxOpen.visible = false
					open = false
					$placer.rotate(PI/2)
				else:
					$placer.rotate(-PI/2)
					$placer/toolSprite.visible = false
					$placer/pickUp/boxClosed.visible = false
					$placer/openBook.visible = true
					$placer/pickUp/boxOpen.visible = true
					open = true
			time = false
			$hysterese.start()


func _on_hysterese_timeout() -> void: # prevents flapping
	time = true
	$hysterese.stop()

func _on_big_lexicon_pressed() -> void:
	$placer/openBook.visible = openBig
	$bigLexicon.visible = not openBig
	globalVariables.paused = not openBig
	signalBus.deactivate.emit(openBig)
	openBig = not openBig
	if openBig:
		$bigLexicon/background/lexiconContent.changePage()
	else:
		$placer/openBook/lexiconContent.changePage()

