extends PanelContainer

var busses: Dictionary = {"Master" = 0, "music" = 0, "sfx" = 0}

var t: float = 0
@onready var fade: AnimationPlayer = $fader
@onready var sfx: AudioStreamPlayer = $sfxScrew

func _ready() -> void:
	for i: String in busses:
		busses[i] = AudioServer.get_bus_index(i)
	$volume/audioMaster/volume.value = db_to_linear(AudioServer.get_bus_volume_db(busses["Master"]))
	$volume/audioSFX/volume.value = db_to_linear(AudioServer.get_bus_volume_db(busses["sfx"]))
	$volume/audioMusic/volume.value = db_to_linear(AudioServer.get_bus_volume_db(busses["music"]))
	$volume/audioMaster/mute.button_pressed = AudioServer.is_bus_mute(busses["Master"])
	$volume/audioSFX/mute.button_pressed = AudioServer.is_bus_mute(busses["sfx"])
	$volume/audioMusic/mute.button_pressed = AudioServer.is_bus_mute(busses["music"])

func _on_master_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(busses["Master"], linear_to_db(value))
	if t > 0.1:
		t = 0
		if not sfx.playing:
			sfx.play(randf_range(0,10))
			fade.play("fadeIn")

func _on_sfx_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(busses["sfx"], linear_to_db(value))
	if t > 0.1:
		t = 0
		if not sfx.playing:
			sfx.play(randf_range(0,10))
			fade.play("fadeIn")

func _on_music_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(busses["music"], linear_to_db(value))
	if t > 0.1:
		t = 0
		if not sfx.playing:
			sfx.play(randf_range(0,10))
			fade.play("fadeIn")

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

func _process(delta: float) -> void:
	t += delta
	if t >= .3:
		fade.play("fadeOut")
