extends Control

@onready var opener: AnimationPlayer = $place/opener
@onready var shelf: HBoxContainer = $place/background/edge/potions
@onready var sound: AudioStreamPlayer = $sfx
var active: bool = true
var storage: int = 0
var maxstorage: int = 4

enum potions {shield, hint}

func _ready() -> void:
	signalBus.deactivate.connect(deactivate)
	gainPotion(potions.shield)
	gainPotion(potions.hint)
	gainPotion(potions.hint)
	gainPotion(potions.shield)
	gainPotion(potions.shield)
	

func deactivate(r: bool) -> void: #processes the deactivation when paused or ended
	active = r
	if r:
		opener.speed_scale = 1
		opener.clear_queue()
	else:
		opener.speed_scale = 0

func _on_open_toggled(toggled_on: bool) -> void: #processes the opening and closing
	if opener.is_playing():
		opener.play_backwards()
	else:
		opener.clear_queue()
		if toggled_on:
			opener.queue("open")
		else:
			opener.queue("close")

func gainPotion(potion: int) -> void: #process the gaining of potions
	if storage < maxstorage:
		storage += 1
		var pot: TextureButton = TextureButton.new()
		shelf.add_child(pot)
		match potion:
			potions.shield:
				pot.texture_normal = load("res://assets/textures/tools/coin-pi.png")
				pot.pressed.connect(_on_drink.bind(potions.shield, pot))
			potions.hint:
				pot.texture_normal = load("res://assets/textures/tools/clock.png")
				pot.pressed.connect(_on_drink.bind(potions.hint, pot))

func _on_drink(potion: int, pot: TextureButton) -> void: #processes the drinking of potions and the effects they have
	match potion:
		potions.shield:
			globalVariables.buff["shield"] += 1
		potions.hint:
			globalVariables.buff["freeHint"] += 2
	storage -= 1
	pot.queue_free()
	sound.play()
