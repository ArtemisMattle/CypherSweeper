extends MarginContainer


@onready var pLable: Label = $pageLable
@onready var lex: RichTextLabel = $lexText
@onready var back: TextureButton = $back
@onready var next: TextureButton = $next
var lastPage: int = 21

@onready var arrow: Sprite2D = $arrow
var arrowAim: Vector2
@onready var flamel: Sprite2D = $flamel5
@onready var ingredients: Control = $ingredients
@onready var neighborhood: Sprite2D = $neighborhood
@onready var hint: Sprite2D = $hint



func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	draw_circle(globalVariables.camPos - 2 * global_position + Vector2(640, 360), 10, Color.BLACK)

func changePage() -> void: # changes the page
	pLable.text = str(globalVariables.lexPage + 1)
	lex.text = tr("lex" + str(globalVariables.lexPage))
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
		2:
			ingredients.visible = true
		4:
			neighborhood.visible = true
		5:
			hint.visible = true
		6:
			arrow.visible = true
			arrowAim = Vector2(700, 650)
		lastPage: next.visible = false
		_: pass

func _on_back_pressed() -> void: # last page
	globalVariables.lexPage -= 1
	changePage()


func _on_next_pressed() -> void: # next page
	globalVariables.lexPage += 1
	changePage()

