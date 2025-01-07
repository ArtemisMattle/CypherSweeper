extends Node

var language: String = "EN"

var masterMute: bool = false
var musicMute: bool = false
var soundMute: bool = false

var fs: bool = false
var darkmode: bool = false
var colours: Array[Color] = [
	Color(0.878, 0.8, 0.533),
	Color(0, 0, 0),
	Color(0.694, 0.451, 0.718)
	]

enum sMode {normal, fast, zippy}
var speedMode: int = sMode.normal

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("fullscreen"):
		fs = not fs
		tFullscreen()

func tFullscreen() -> void:
	if fs:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
