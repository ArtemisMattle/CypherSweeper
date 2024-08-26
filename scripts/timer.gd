extends Node2D

@onready var primes: Sprite2D = $background/primes
@onready var seconds: Sprite2D = $background/seconds
@onready var text: Label = $timerClock

var t: float

func _ready() -> void: # decides which clock is used
	$timerClock.visible = get_meta("digital")
	$background.visible = get_meta("analog")
	text.text = "0"
	t = globalVariables.playTime


func _process(delta: float) -> void: # updates the clocks
	if not globalVariables.paused:
		t += delta
		if get_meta("digital"):
			text.text = str(floor(t/60)) + ":" + str(fmod(floor(t),60))
		if get_meta("analog"):
			seconds.rotation = (2 * PI) / 60 * t + PI * randf_range(-1.2,1.2) * 0.3 / globalVariables.sanity + 100 * t / (globalVariables.sanity * globalVariables.sanity * globalVariables.sanity)
			primes.rotation = (2 * PI) / (60 * 60) * t + 10 * t / (globalVariables.sanity * globalVariables.sanity * globalVariables.sanity)
