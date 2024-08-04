extends Node2D

var text: Label
var t: float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$timerClock.visible = get_meta("digital")
	$background.visible = get_meta("analog")
	text = $timerClock
	text.text = "0"
	t = globalVariables.playTime


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not globalVariables.paused:
		t += delta
		text.text = str(floor(t/60)) + ":" + str(fmod(floor(t),60))
		$background/seconds.rotation = (2 * PI) / 60 * t
		$background/primes.rotation = (2 * PI) / (60 * 60) * t
