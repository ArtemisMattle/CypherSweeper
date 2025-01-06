extends Control

@onready var tts: PackedScene = preload("res://scenes/tooltip.tscn")
func _make_custom_tooltip(for_text: String) -> Object:
	var tooltip: Control = tts.instantiate()
	tooltip.initi(for_text)
	return tooltip
