extends Node2D



func _on_play_story_pressed() -> void:
	match $background/edge/menu/mainbuttons/playStory.text:
		"Play Story":
			closeTitle()
			closeCredits()
			closeSetting()
			openLvlSelect()
			$background/edge/menu/mainbuttons/playStory.text="Exit"
		"Exit":
			openTitle()
			closeCredits()
			closeSetting()
			closeLvlSelect()
			$background/edge/menu/mainbuttons/playStory.text="Play Story"
		
	#get_tree().change_scene_to_file("res://scenes/lvl0.tscn")

func _on_settings_pressed() -> void:
	match $background/edge/menu/mainbuttons/Settings.text:
		"Settings":
			$background/edge/menu/mainbuttons/Settings.text = "Exit"
			closeTitle()
			closeCredits()
			closeLvlSelect()
			openSetting()
		"Exit":
			closeSetting()
			openTitle()

func _on_credits_pressed() -> void:
	match $background/edge/menu/mainbuttons/Credits.text:
		"Credits":
			$background/edge/menu/mainbuttons/Credits.text = "Exit"
			closeTitle()
			closeSetting()
			closeLvlSelect()
			openCredits()
		"Exit":
			closeCredits()
			openTitle()

func closeTitle():
	$background/edge/menu/title.visible = false
	
func openTitle():
	$background/edge/menu/title.visible = true

func closeLvlSelect():
	$background/edge/menu/levelSelect.visible=false
	$background/edge/menu/mainbuttons/playStory.text="Play Story"
	
func openLvlSelect():
	$background/edge/menu/levelSelect.visible=true
	
func closeSetting():
	$background/edge/menu/settings.visible = false
	$background/edge/menu/mainbuttons/Settings.text = "Settings"

func openSetting():
	$background/edge/menu/settings.visible = true

func closeCredits():
	$background/edge/menu/credits.visible = false
	$background/edge/menu/mainbuttons/Credits.text = "Credits"

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
