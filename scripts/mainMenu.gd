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
	$background/edge/menu/title.visible = false

func openTitle():
	$background/edge/menu/title.visible = true

func closeSetting():
	$background/edge/menu/settings.visible = false

func openSetting():
	$background/edge/menu/settings.visible = true

func closeCredits():
	$background/edge/menu/credits.visible = false

func openCredits():
	$background/edge/menu/credits.visible = true

func _on_colourblind_mode_toggled(toggled_on):
	settings.colourblindMode = toggled_on

enum sMode {normal, fast, zippy}
func _on_zippy_mode_pressed() -> void:
	settings.speedMode = sMode.zippy

func _on_fast_mode_pressed() -> void:
	settings.speedMode = sMode.fast

func _on_normal_mode_pressed() -> void:
	settings.speedMode = sMode.normal
