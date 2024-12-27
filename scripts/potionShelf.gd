extends Control

@onready var opener: AnimationPlayer = $place/opener
@onready var shelf: HBoxContainer = $place/background/edge/potions
@onready var sound: AudioStreamPlayer = $sfx
var active: bool = true
var pot: Array[Control]
var maxstorage: int = 4

var potion: PackedScene = preload("res://scenes/potion.tscn")
var shield: Texture2D = preload("res://assets/textures/potions/potionLableShield.png")
var hint: Texture2D = preload("res://assets/textures/potions/potionLableHint.png")

enum potions {shield, hint}

func _ready() -> void:
	signalBus.deactivate.connect(deactivate)
	for i: int in maxstorage:
		pot.append(null)
	
	for i: int in globalVariables.buff["freePotion"]:
		_on_button_pressed()
	

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

func gainPotion(poti: int) -> void: #process the gaining of potions
	for i: int in maxstorage:
		if pot[i] == null:
			pot[i] = potion.instantiate()
			shelf.add_child(pot[i])
			pot[i].set_meta("Type", poti)
			pot[i].get_node("potionBottle").pressed.connect(_on_drink.bind(poti, i))
			
			var label = CanvasTexture.new()
			# label canvas texture has to be set individually, otherwise references same mem adress because packed scene
			
			label.normal_texture=pot[i].get_node("potionLable").texture.normal_texture
			match pot[i].get_meta("Type"):
				potions.shield:
					pot[i].get_node("potionLiquid").modulate = Color.AQUA
					label.diffuse_texture = shield
					pot[i].tooltip_text = "ttShieldPotion"
				potions.hint:
					pot[i].get_node("potionLiquid").modulate = Color.GOLD
					label.diffuse_texture = hint
					pot[i].tooltip_text = "ttHintPotion"
					
			pot[i].get_node("potionLable").texture=label
			break

func _on_drink(poti: int, pos: int) -> void: #processes the drinking of potions and the effects they have
	signalBus.potionD.emit(poti)
	match poti:
		potions.shield:
			globalVariables.buff["shield"] += 1
		potions.hint:
			globalVariables.buff["freeHint"] += 2
	pot[pos].queue_free()
	pot[pos] = null
	sound.play()


func _on_button_pressed() -> void:
	gainPotion(randi_range(0,1))
