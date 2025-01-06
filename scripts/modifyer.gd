extends GridContainer

var mod: PackedScene = preload("res://scenes/mod.tscn")
var mods: Array[globalVariables.modifyer] = globalVariables.mods.duplicate()

func _ready() -> void:
	for i: int in len(mods): # instantiates the modifyer buttons
		mods[i].btn = mod.instantiate()
		add_child(mods[i].btn)
			# loads the modifyer sprite
		mods[i].btn.get_node("modPic").texture = load("res://assets/textures/UI-elements/modifier/mod" + mods[i].n + ".png")
			# loads the modifyer tooltip
		mods[i].btn.tooltip_text = "ttMod" + mods[i].n
			# loads and colours the value lable
		var lb: Label = mods[i].btn.get_node("value")
		if mods[i].v > 0:
			lb.text = "+" + str(mods[i].v)
			lb.modulate = Color.DARK_RED
		else:
			lb.text = str(mods[i].v)
			lb.modulate = Color.BLUE
			# connects the buttons to the variable handler
		mods[i].btn.toggled.connect(change.bind(mods[i]))
		mods[i].btn.button_pressed = mods[i].onByDefault
		if mods[i].n != "LR" and mods[i].n != "BA" and mods[i].n != "OF" and mods[i].n != "HE" and mods[i].n != "FU" and mods[i].n != "ST":
			mods[i].btn.disabled = true

func change(active: bool, m: globalVariables.modifyer) -> void: # mostly handles the variable manipulation for the modifyers
	if active:
		globalVariables.scoreMult += float(m.v) / 10
		globalVariables.mod.append(m.n)
	else:
		globalVariables.scoreMult -= float(m.v) / 10
		globalVariables.mod.erase(m.n)
	for i: String in m.incompatible: # disables incompatible modifyers
		var x: globalVariables.modifyer = m.findNamed(i)
		if x.btn.button_pressed != x.onByDefault: # makes sure non mutual exclusion works
			x.btn.button_pressed = x.onByDefault
		x.btn.disabled = active


