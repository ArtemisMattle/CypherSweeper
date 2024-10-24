extends GridContainer

var mod: PackedScene = preload("res://scenes/mod.tscn")
var mods: Array[modifyer] = [
	modifyer.new("HEK", 3, ["EC"]),# playerControler
	modifyer.new("EC", 7, ["HEK"]),# playerControler
	modifyer.new("DI", 3, ["LR"]), # main Menu
	modifyer.new("LR", -3, ["DI"]), # main Menu
	modifyer.new("AA", 3, ["BA"]), # main Menu
	modifyer.new("BA", -3, ["AA"]), # main Menu
	modifyer.new("DL", 5),#TODO
	modifyer.new("BR", 4),#TODO
]

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
		mods[i].btn.toggled.connect(change.bind(i))

func change(active: bool, m: int) -> void: # mostly handles the variable manipulation for the modifyers
	if active:
		globalVariables.scoreMult += float(mods[m].v) / 10
		globalVariables.mod.append(mods[m].n)
	else:
		globalVariables.scoreMult -= float(mods[m].v) / 10
		globalVariables.mod.erase(mods[m].n)
	for i: String in mods[m].incompatible: # disables incompatible modifyers
		var x: modifyer = findNamed(i)
		x.btn.disabled = active

func findNamed(name: String) -> modifyer: # finds modifyers by name instead of id
	for i: modifyer in mods:
		if i.n == name:
			return i
	return null

class modifyer: # contains the few necessary informations for modifyers
	var n: String
	var v: int
	var incompatible: Array[String]
	var btn: TextureButton
	
	func _init(name: String, value: int = 0, incomp: Array[String] = []) -> void:
		n = name
		v = value
		incompatible = incomp
