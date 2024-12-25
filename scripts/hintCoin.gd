extends Control

func _ready() -> void:
	signalBus.returnUnrevealed.connect(findUnrevealed)

func _on_pick_up_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void:
	#if get_parent().name == "toolBox":
		if Input.is_action_pressed("activateTool"):
			if globalVariables.buff["freeHint"] > 0:
				globalVariables.buff["freeHint"] -= 1
			else:
				globalVariables.scoreMult *= (100 - PI)/100
			signalBus.getRandomUnrevealed.emit()

func findUnrevealed(i: String, p: Vector2) -> void:
	var offset: Vector2
	signalBus.drop.emit(false)
	if globalVariables.sanity < 75:
			offset = Vector2.from_angle(randf_range(0, 2 * PI))
			offset *= clampf(randf_range(0, 150 / globalVariables.sanity), 0, 16)
	$placer.global_position = p + offset
	$placer/toolSprite/ingredient.texture = load("res://assets/textures/ingredients/" + i + ".png")
	$placer/toolSprite.texture = load("res://assets/textures/tools/coin-blank.png")
	$placer.rotate(randf_range(0, (2 * PI) / globalVariables.sanity))
