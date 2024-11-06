extends Control


func initi(txt: String) -> void:
	var l: int = tr(txt).length()
	@warning_ignore("integer_division")
	l = clampi(l / 18, 1, 99)
	custom_minimum_size = Vector2i(450, 45 * l + 60)
	$background/text.custom_minimum_size = Vector2i(400, 45 * l+10)
	$background/text.text = "[center]" + tr(txt) + "[/center]"
