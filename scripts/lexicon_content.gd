extends MarginContainer


@onready var pLablel: Label = $textBox/leftBox/pageLable
@onready var pLabler: Label = $textBox/rightBox/pageLable
@onready var lexl: RichTextLabel = $textBox/leftBox/lexTextl
@onready var lexr: RichTextLabel = $textBox/rightBox/lexTextr
@onready var back: TextureButton = $back
@onready var next: TextureButton = $next
var lastPage: int = 21

@onready var arrow: Sprite2D = $arrow
var arrowAim: Vector2
var Aim: Node
@onready var flamel: Sprite2D = $flamel5
@onready var ingredients: Control = $ingredients
@onready var neighborhood: Sprite2D = $neighborhood
@onready var hint: Sprite2D = $hint

func _ready() -> void:
	signalBus.returnAim.connect(aim)

func aim(target: Node) -> void: # saves the node that is aimed at
	Aim = target
	

func _process(delta: float) -> void:
	if arrow.visible:
		arrow.rotate((Aim.global_position - arrow.global_position + get_viewport().get_camera_2d().position - Vector2(640, 500) + Vector2.DOWN * 100 / sqrt(get_viewport().get_camera_2d().zoom.y)).angle() - arrow.global_rotation)
		#var pos: Vector2 = arrow.global_position - 
		#var ang: float = -get_global_transform().get_rotation() + PI / 2 - arrow.rotation + pos.x / 200 - pos.y / (abs(pos.x)+100)
		#arrow.rotate(ang)
	

func changePage() -> void: # changes the page
	pLablel.text = str(2 * globalVariables.lexPage + 1)
	pLabler.text = str(2 * globalVariables.lexPage + 2)
	lexl.text = tr("lexl" + str(globalVariables.lexPage))
	lexr.text = tr("lexr" + str(globalVariables.lexPage))
	back.visible = true
	next.visible = true
	arrow.visible = false
	flamel.visible = false
	neighborhood.visible = false
	hint.visible = false
	ingredients.visible = false
	match globalVariables.lexPage:
		0: 
			back.visible = false
			flamel.visible = true
		3:
			ingredients.visible = true
		4:
			neighborhood.visible = true
		5:
			hint.visible = true
		6:
			arrow.visible = true
			signalBus.getAim.emit(0) # asks the void for an aim (the playerController answers)
		7:
			arrow.visible = true
			signalBus.getAim.emit(1)
		lastPage: next.visible = false
		_: pass

func _on_back_pressed() -> void: # last page
	globalVariables.lexPage -= 1
	changePage()

func _on_next_pressed() -> void: # next page
	globalVariables.lexPage += 1
	changePage()

