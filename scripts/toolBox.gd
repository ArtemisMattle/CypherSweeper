extends Control

@export var upy: float = 380
@export var downy: float = 20
var toolsize: int = 128

@onready var tGrid: Container = $background/edge/toolGrid
@onready var opener: AnimationPlayer = $opener

var tools: Array[globalVariables.tool] # array for all tools in the toolBox
var tSpace: Array[int] # tracks which positions in the toolbox are open

#var held: globalVariables.tool = null
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
	
	signalBus.toolTrans.connect(takeTool)

func takeTool(t: globalVariables.tool, held) -> void: # recieves a tool from the parent juggling
	if held:
		if t.tScene.get_meta("boxTool"):
			if t.tScene.get_parent() == self:
				pass
			else:
				t.tScene.reparent(self)
	else:
		if globalVariables.boxing:
			t.tScene.reparent(tGrid)
			var p: int
			for i: int in 9:
				if not tSpace.has(i):
					tSpace.append(i)
					p = i
					break
			tools.append(t)
			#t.pickUp.input_event.connect(giveTool.bind(t))
			var offset: Vector2
			if globalVariables.sanity < 75:
				offset = Vector2.from_angle(randf_range(0, 2 * PI))
				offset *= randf_range(0, 1000 / (globalVariables.sanity + 0.1))
			t.place.position = Vector2(clamp(toolsize / 2 + (p % 3) * toolsize + offset.x, toolsize/2, tGrid.size.x - toolsize/2), clamp(toolsize / 2 + (p / 3) * toolsize + offset.y, toolsize/2, tGrid.size.y - toolsize/2))



#func giveTool(viewport: Node, event: InputEvent, shape_idx: int, t: globalVariables.tool) -> void: # gives a tool to the parent juggling
	#if Input.is_action_pressed("pickUpTool"):
		#if globalVariables.holdable:
			#tSpace.remove_at(tools.find(t, 0))
			#tools.erase(t)
		#else:
			#if globalVariables.boxing:
				#t.tScene.reparent(tGrid)
				#var p: int
				#for i: int in 9:
					#if not tSpace.has(i):
						#tSpace.append(i)
						#p = i
						#break
				#tools.append(t)
				#t.pickUp.input_event.connect(giveTool.bind(t))
				#var offset: Vector2
				#if globalVariables.sanity < 75:
					#offset = Vector2.from_angle(randf_range(0, 2 * PI))
					#offset *= randf_range(0, 1000 / globalVariables.sanity)
				#t.place.position = Vector2(clamp(toolsize / 2 + (p % 3) * toolsize + offset.x, toolsize/2, tGrid.size.x - toolsize/2), clamp(toolsize / 2 + (p / 3) * toolsize + offset.y, toolsize/2, tGrid.size.y - toolsize/2))
			#else:
				#signalBus.toolTrans.emit(t)
				#t.pickUp.input_event.disconnect(giveTool)

func deactivate(r: bool) -> void:
	if r:
		opener.speed_scale = 4
		opener.clear_queue()
	else:
		opener.speed_scale = 0
	globalVariables.holdable = r
	deactivated = not r

func _on_open_toggled(toggled_on: bool) -> void:
	if opener.is_playing():
		opener.play_backwards()
	else:
		opener.clear_queue()
		if toggled_on:
			opener.queue("open")
			globalVariables.tbOpen = toggled_on
		else:
			opener.queue("close")
			globalVariables.tbOpen = toggled_on

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
