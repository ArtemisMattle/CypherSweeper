extends PanelContainer

var busses: Dictionary = {"Master" = 0, "music" = 0, "sfx" = 0}

func _ready() -> void:
	for i in busses:
		busses[i] = AudioServer.get_bus_index(i)
	$volume/audioMaster/volume.value = db_to_linear(AudioServer.get_bus_volume_db(busses["Master"]))
	$volume/audioSFX/volume.value = db_to_linear(AudioServer.get_bus_volume_db(busses["sfx"]))
	$volume/audioMusic/volume.value = db_to_linear(AudioServer.get_bus_volume_db(busses["music"]))
	$volume/audioMaster/mute.button_pressed = AudioServer.is_bus_mute(busses["Master"])
	$volume/audioSFX/mute.button_pressed = AudioServer.is_bus_mute(busses["sfx"])
	$volume/audioMusic/mute.button_pressed = AudioServer.is_bus_mute(busses["music"])

func _on_master_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(busses["Master"], linear_to_db(value))

func _on_sfx_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(busses["sfx"], linear_to_db(value))

func _on_music_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(busses["music"], linear_to_db(value))

func _on_masterMute_toggled(toggled_on: bool) -> void:
	settings.masterMute = not toggled_on
	$volume/audioMaster/volume.editable = not toggled_on
	AudioServer.set_bus_mute(busses["Master"], toggled_on)

func _on_sfxMute_toggled(toggled_on: bool) -> void:
	settings.soundMute = not toggled_on
	$volume/audioSFX/volume.editable = not toggled_on
	AudioServer.set_bus_mute(busses["sfx"], toggled_on)

func _on_musicMute_toggled(toggled_on: bool) -> void:
	settings.musicMute = not toggled_on
	$volume/audioMusic/volume.editable = not toggled_on
	AudioServer.set_bus_mute(busses["music"], toggled_on)
