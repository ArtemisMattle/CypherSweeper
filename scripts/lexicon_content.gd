extends MarginContainer


@onready var pLablel: Label = $textBox/leftBox/pageLable
@onready var pLabler: Label = $textBox/rightBox/pageLable
@onready var lexl: RichTextLabel = $textBox/leftBox/lexTextl
@onready var lexr: RichTextLabel = $textBox/rightBox/lexTextr
@onready var back: TextureButton = $back
@onready var next: TextureButton = $next
var lastPage: int = 10

@onready var arrow: Sprite2D = $arrow
var arrowAim: Vector2
@onready var flamel: Sprite2D = $flamel5
@onready var ingredients: Control = $ingredients
@onready var neighborhood: Sprite2D = $neighborhood
@onready var hint: Sprite2D = $hint

func _ready() -> void:
	signalBus.modulate.connect(shapeshift)
	changePage()

func _process(delta: float) -> void:
	if arrow.visible:
		arrow.look_at(arrowAim)
	

func changePage() -> void: # changes the page
	pLablel.text = str(2 * globalVariables.lexPage + 1)
	pLabler.text = str(2 * globalVariables.lexPage + 2)
	lexl.text = "lexl" + str(globalVariables.lexPage)
	lexr.text = "lexr" + str(globalVariables.lexPage)
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
			arrow.visible = true
			arrowAim = Vector2i(1000, 650)
		3:
			ingredients.visible = true
		4:
			neighborhood.visible = true
		5:
			hint.visible = true
		6:
			arrow.visible = true
			arrowAim = Vector2i(700, 650)
		
		lastPage: next.visible = false
		_: pass

func _on_back_pressed() -> void: # last page
	globalVariables.lexPage -= 1
	changePage()

func _on_next_pressed() -> void: # next page
	globalVariables.lexPage += 1
	changePage()

func shapeshift() -> void:
	$textBox.modulate = globalVariables.colours[1]
	$ingredients/lbHerb.modulate = globalVariables.colours[1]
	$ingredients/lbSalt.modulate = globalVariables.colours[1]
	$ingredients/lbShroom.modulate = globalVariables.colours[1]
	$next.modulate = globalVariables.colours[1]
	$back.modulate = globalVariables.colours[1]
