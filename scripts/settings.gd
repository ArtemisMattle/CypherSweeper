extends Node

var setPath: String = "user://CSSetting.cfg"
var settings: ConfigFile = ConfigFile.new()

var language: String = "EN"

var masterMute: bool = false
var musicMute: bool = false
var soundMute: bool = false
var busses: Dictionary = {"Master" = 0, "music" = 0, "sfx" = 0}

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
	if event.is_action_pressed("save"):
		saveSet()

func tFullscreen() -> void:
	if fs:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func saveSet() -> void:
	settings.set_value("language", "language", language)
	
	
	for i: String in busses:
		busses[i] = AudioServer.get_bus_index(i)
	
	settings.set_value("sound", "masterMute", masterMute)
	settings.set_value("sound", "soundMute", soundMute)
	settings.set_value("sound", "musicMute", musicMute)
	settings.set_value("sound", "masterVolume", AudioServer.get_bus_volume_db(busses["Master"]))
	settings.set_value("sound", "soundVolume", AudioServer.get_bus_volume_db(busses["sfx"]))
	settings.set_value("sound", "musicVolume", AudioServer.get_bus_volume_db(busses["music"]))
	
	settings.save(setPath)

func loadSet() -> void:
	var err = settings.load(setPath)
	if err != OK:
		return
	
	if settings.has_section("language"):
		language = settings.get_value("language", "language")
		TranslationServer.set_locale(language)
	
	if settings.has_section("sound"):
		masterMute = settings.get_value("sound", "masterMute")
		soundMute = settings.get_value("sound", "soundMute")
		musicMute = settings.get_value("sound", "musicMute")
		AudioServer.set_bus_volume_db(busses["Master"], settings.get_value("sound", "masterVolume"))
		AudioServer.set_bus_volume_db(busses["sfx"], settings.get_value("sound", "soundVolume"))
		AudioServer.set_bus_volume_db(busses["music"], settings.get_value("sound", "musicVolume"))
