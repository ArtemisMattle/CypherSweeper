extends Node

var masterMute: bool = false
var musicMute: bool = false
var soundMute: bool = false

var fs: bool = false

enum sMode {normal, fast, zippy}
var speedMode: int = sMode.normal

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("fullscreen"):
		fs = not fs
		tFullscreen()

func tFullscreen() -> void:
	if fs:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
