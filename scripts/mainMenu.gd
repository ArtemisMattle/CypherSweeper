extends Node2D



func _on_play_story_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/lvl0.tscn")

func _on_settings_pressed() -> void:
	$background/edge/menu/mainbuttons/Credits.text = "Credits"
	match $background/edge/menu/mainbuttons/Settings.text:
		"Settings":
			$background/edge/menu/mainbuttons/Settings.text = "Exit"
			closeTitle()
			closeCredits()
			openSetting()
		"Exit":
			$background/edge/menu/mainbuttons/Settings.text = "Settings"
			closeSetting()
			openTitle()

func _on_credits_pressed() -> void:
	$background/edge/menu/mainbuttons/Settings.text = "Settings"
	match $background/edge/menu/mainbuttons/Credits.text:
		"Credits":
			$background/edge/menu/mainbuttons/Credits.text = "Exit"
			closeTitle()
			closeSetting()
			openCredits()
		"Exit":
			$background/edge/menu/mainbuttons/Credits.text = "Credits"
			closeCredits()
			openTitle()

func closeTitle():
	$background/edge/menu/titleSpace.visible = false
	$background/edge/menu/title.visible = false

func openTitle():
	$background/edge/menu/titleSpace.visible = true
	$background/edge/menu/title.visible = true

func closeSetting():
	$background/edge/menu/settings.visible = false
	$background/edge/menu/settingsSpace.visible = false
	$background/edge/menu/volume.visible = false

func openSetting():
	$background/edge/menu/settings.visible = true
	$background/edge/menu/settingsSpace.visible = true
	$background/edge/menu/volume.visible = true

func closeCredits():
	$background/edge/menu/credits.visible = false
	$background/edge/menu/creditsSpace.visible = false

func openCredits():
	$background/edge/menu/credits.visible = true
	$background/edge/menu/creditsSpace.visible = true

func _on_masterMute_toggled(toggled_on: bool) -> void:
	settings.masterMute = not toggled_on
	$background/edge/menu/volume/audioMaster/volume.editable = not toggled_on

func _on_soundMute_toggled(toggled_on: bool) -> void:
	settings.soundMute = not toggled_on
	$background/edge/menu/volume/audioSFX/volume.editable = not toggled_on

func _on_musicMute_toggled(toggled_on: bool) -> void:
	settings.musicMute = not toggled_on
	$background/edge/menu/volume/audioMusic/volume.editable = not toggled_on

enum sMode {normal, fast, zippy}
func _on_zippy_mode_pressed() -> void:
	settings.speedMode = sMode.zippy
	print(settings.speedMode)

func _on_fast_mode_pressed() -> void:
	settings.speedMode = sMode.fast
	print(settings.speedMode)

func _on_normal_mode_pressed() -> void:
	settings.speedMode = sMode.normal
	print(settings.speedMode)
