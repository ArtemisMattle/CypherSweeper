extends CPUParticles2D



func _ready() -> void:
	signalBus.lvlUp.connect(emit)

func emit() -> void:
	restart()
