extends Node

var setPath: String = "user://CSSetting.cfg"


var language: String = "EN"

#var masterMute: bool = false
#var musicMute: bool = false
#var soundMute: bool = false
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

var mouseEdging: bool = true
var mousePaning: bool = true

func _ready() -> void:
	for i: String in busses:
		busses[i] = AudioServer.get_bus_index(i)
	loadSet()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("fullscreen"):
		fs = not fs
		tFullscreen()
		saveSet()

func tFullscreen() -> void:
	if fs:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func saveSet() -> void:
	var settings: ConfigFile = ConfigFile.new()
	settings.set_value("language", "language", language)
	
	settings.set_value("sound", "masterMute", AudioServer.is_bus_mute(busses["Master"]))
	settings.set_value("sound", "soundMute", AudioServer.is_bus_mute(busses["sfx"]))
	settings.set_value("sound", "musicMute", AudioServer.is_bus_mute(busses["music"]))
	settings.set_value("sound", "masterVolume", AudioServer.get_bus_volume_db(busses["Master"]))
	settings.set_value("sound", "soundVolume", AudioServer.get_bus_volume_db(busses["sfx"]))
	settings.set_value("sound", "musicVolume", AudioServer.get_bus_volume_db(busses["music"]))
	
	settings.set_value("display", "fullscreen", fs)
	settings.set_value("display", "darkMode", darkmode)
	settings.set_value("display", "colours", colours)
	
	settings.set_value("gameplay", "speedMode", speedMode)
	settings.set_value("gameplay", "mEdging", mouseEdging)
	settings.set_value("gameplay", "mPaning", mousePaning)
	
	settings.save(setPath)

func loadSet() -> void:
	var settings: ConfigFile = ConfigFile.new()
	var err = settings.load(setPath)
	if err != OK:
		return
	
	if settings.has_section("language"):
		language = settings.get_value("language", "language")
		match language:
			"EN": TranslationServer.set_locale("en") 
			"DE": TranslationServer.set_locale("de") 
			"ENGB": TranslationServer.set_locale("en_GB")
			"FR": TranslationServer.set_locale("fr")
			"ES": TranslationServer.set_locale("es")
			"EO": TranslationServer.set_locale("eo")
	
	if settings.has_section("sound"):
		AudioServer.set_bus_mute(busses["Master"], settings.get_value("sound", "masterMute"))
		AudioServer.set_bus_mute(busses["sfx"], settings.get_value("sound", "soundMute"))
		AudioServer.set_bus_mute(busses["music"], settings.get_value("sound", "musicMute"))
		
		AudioServer.set_bus_volume_db(busses["Master"], settings.get_value("sound", "masterVolume"))
		AudioServer.set_bus_volume_db(busses["sfx"], settings.get_value("sound", "soundVolume"))
		AudioServer.set_bus_volume_db(busses["music"], settings.get_value("sound", "musicVolume"))
	
	if settings.has_section("display"):
		fs = settings.get_value("display", "fullscreen", false)
		darkmode = settings.get_value("display", "darkMode", false)
		colours = settings.get_value("display", "colours", colours)
		tFullscreen()
	
	if settings.has_section("gameplay"):
		speedMode = settings.get_value("gameplay", "speedMode", sMode.normal)
		mouseEdging = settings.get_value("gameplay", "mEdging", true)
		mousePaning = settings.get_value("gameplay", "mPaning", true)
