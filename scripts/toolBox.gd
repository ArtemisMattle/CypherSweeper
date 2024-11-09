extends Control

var open: bool = false
@export var upy: float = 380
@export var downy: float = 20
var toolsize: int = 128

@onready var tGrid: Container = $background/edge/toolGrid
@onready var opener: AnimationPlayer = $opener

var tools: Array[globalVariables.tool] # array for all tools in the toolBox
var tSpace: Array[int] # tracks which positions in the toolbox are open

var held: globalVariables.tool = null
var speed: float = 50
var rotSpeed: float = .3
var rotThresh: float = 5

var deactivated: bool = false

func _ready() -> void:
	signalBus.deactivate.connect(deactivate)
	set_physics_process(false)
	global_position.y = 720 - downy
	
		# tool stuff
	var Tools: Array[String] = [ # the names MUST correspond to a scene in "res://scenes/tools/"
		"magnifyer",
		"lexicon",
		"clock",
		"hintCoin",
	]
	
	for x: int in Tools.size():
		tools.append(globalVariables.tool.new())
		tools[x].tScene = load("res://scenes/tools/"+Tools[x]+".tscn").instantiate()
		tools[x].initiate()
		tGrid.add_child(tools[x].tScene)
		tSpace.append(x)
		tools[x].place.position = Vector2(toolsize / 2 + (x % 3) * toolsize , toolsize / 2 + (x / 3) * toolsize)
		tools[x].pickUp.input_event.connect(giveTool.bind(tools[x]))
	
	signalBus.toolTrans.connect(takeTool)

func _physics_process(delta: float) -> void: # tool movement
	if held != null:
		var posOld: Vector2 = held.place.global_position
		held.place.global_position = lerp(held.place.global_position, get_global_mouse_position() , speed * delta)
		if held.place.get_meta(&"rot"):
			if max(abs(posOld.x - held.place.global_position.x), abs(posOld.y - held.place.global_position.y)) > rotThresh:
				held.place.rotate(held.place.get_angle_to(get_global_mouse_position()) * delta * rotSpeed * (posOld - held.place.global_position).length())

func takeTool(t: globalVariables.tool) -> void: # recieves a tool from the parent juggling
	if t.tScene.get_parent() == self:
		pass
	else:
		held = t
		set_physics_process(true)
		globalVariables.holdable = false
		t.tScene.reparent(self)
		t.place.scale = Vector2(2, 2)
		t.pickUp.input_event.connect(giveTool.bind(t))


func giveTool(viewport: Node, event: InputEvent, shape_idx: int, t: globalVariables.tool) -> void: # gives a tool to the parent juggling
	if Input.is_action_pressed("pickUpTool"):
		if globalVariables.holdable:
			held = t
			set_physics_process(true)
			globalVariables.holdable = false
			t.tScene.reparent(self)
			tSpace.remove_at(tools.find(t, 0))
			tools.erase(t)
			t.place.scale = Vector2(2, 2)
	if t == held:
		if Input.is_action_pressed("pickUpTool"):
			if t.to_string() == "magnifyer":
				t.place.get_node("uncover").set_meta("enabled", true)
		else:
			set_physics_process(false)
			held = null
			globalVariables.holdable = true
			t.place.scale = Vector2(1, 1)
			if t.to_string() == "magnifyer":
				t.place.get_node("uncover").set_meta("enabled", false)
			if globalVariables.boxing:
				t.tScene.reparent(tGrid)
				var p: int
				for i: int in 9:
					if not tSpace.has(i):
						tSpace.append(i)
						p = i
						break
				tools.append(t)
				t.pickUp.input_event.connect(giveTool.bind(t))
				var offset: Vector2
				if globalVariables.sanity < 75:
					offset = Vector2.from_angle(randf_range(0, 2 * PI))
					offset *= randf_range(0, 1000 / globalVariables.sanity)
				t.place.position = Vector2(clamp(toolsize / 2 + (p % 3) * toolsize + offset.x, toolsize/2, tGrid.size.x - toolsize/2), clamp(toolsize / 2 + (p / 3) * toolsize + offset.y, toolsize/2, tGrid.size.y - toolsize/2))
			else:
				signalBus.toolTrans.emit(t)
				t.pickUp.input_event.disconnect(giveTool)

func deactivate(r: bool) -> void:
	if r:
		opener.speed_scale = 1
		opener.clear_queue()
	else:
		opener.speed_scale = 0
	globalVariables.holdable = r
	held = null
	deactivated = not r
	set_physics_process(false)

func _on_open_toggled(toggled_on: bool) -> void:
	if opener.is_playing():
		opener.play_backwards()
	else:
		opener.clear_queue()
		if toggled_on:
			opener.queue("open")
			open = toggled_on
		else:
			opener.queue("close")
			open = toggled_on

func lowSanity() -> void:
	for x: int in tools.size():
		tools[x].place.visible = true
	if globalVariables.sanity < 50:
		var y: int = clampi(randi_range(2, 7) - globalVariables.sanity/10 + tools.size()/4 ,0 , tools.size()/2+1)
		for i: int in y:
			var x: int = randi_range(0, tools.size()-1)
			tools[x].place.visible = false

func _on_tool_box(entered: bool) -> void:
		globalVariables.boxing = entered
