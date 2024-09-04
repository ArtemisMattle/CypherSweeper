extends Control

@onready var opener: AnimationPlayer = $place/opener

func _ready() -> void:
	signalBus.deactivate.connect(deactivate)

func deactivate(r) -> void:
	if r:
		opener.speed_scale = 1
		opener.clear_queue()
	else:
		opener.speed_scale = 0

func _on_open_toggled(toggled_on: bool) -> void:
	if opener.is_playing():
		opener.play_backwards()
	else:
		opener.clear_queue()
		if toggled_on:
			opener.queue("open")
		else:
			opener.queue("close")
