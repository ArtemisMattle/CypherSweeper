extends Control

@onready var primes: Sprite2D = $placer/background/primes
@onready var seconds: Sprite2D = $placer/background/seconds
@onready var text: Label = $placer/timerClock
@onready var pla: Node2D = $placer

var t: float

func _ready() -> void: # decides which clock is used
	$placer/timerClock.visible = get_meta("digital")
	$placer/background.visible = get_meta("analog")
	text.text = "0"


func _process(delta: float) -> void: # updates the clocks
	if not globalVariables.paused:
		t += delta
		globalVariables.playTime = t
		if get_meta("digital"):
			text.text = str(floor(t/60)) + ":" + str(fmod(floor(t),60))
		if get_meta("analog"):
			if globalVariables.sanity > 60:
				seconds.rotation = (2 * PI) / 60 * t
				primes.rotation = (2 * PI) / (60 * 60) * t
			elif globalVariables.sanity > 15:
				seconds.rotation = (2 * PI) / globalVariables.sanity * t
				primes.rotation = (2 * PI) / ((60 * 60) - 120 + 2 * globalVariables.sanity) * t
			elif globalVariables.sanity > 3:
				seconds.rotation = (2 * PI) / 30 * t + PI * randf_range(-1.2,1.2) * 0.3 / globalVariables.sanity + 100 * t / (globalVariables.sanity * globalVariables.sanity * globalVariables.sanity)
				primes.rotation -= (2 * PI) / (globalVariables.sanity * 10) * delta
			else:
				seconds.rotation -= (2 * PI) / 10 * delta
				primes.rotation -= (2 * PI) / (60) * delta + 100 * delta / (globalVariables.sanity * globalVariables.sanity * globalVariables.sanity)
				pla.rotation = (2 * PI) / 10 * t + PI * randf_range(-1.2,1.2) * 0.07 / globalVariables.sanity + 1 * t / 10 * (globalVariables.sanity * globalVariables.sanity)
