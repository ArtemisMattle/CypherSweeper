extends Control

var open: bool = false
var time: bool = true
var page: int = 0

@onready var pLable: Label = $placer/openBook/edge/pageLable
@onready var lex: RichTextLabel = $placer/openBook/edge/lexText
@onready var back: TextureButton = $placer/openBook/edge/back
@onready var next: TextureButton = $placer/openBook/edge/next

func _ready() -> void:
	$placer/toolSprite.visible = true
	$placer/pickUp.visible = true
	$placer/openBook.visible = false
	$placer/pickUpOpen.visible = false

func _on_pick_up_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void: # handles opening and closing of the lexicon
	if get_parent().name == "toolHandler":
		if Input.is_action_pressed("activateTool"):
			if time:
				if open:
					$placer/toolSprite.visible = true
					$placer/pickUp.visible = true
					$placer/openBook.visible = false
					$placer/pickUpOpen.visible = false
					open = false
				else:
					$placer/toolSprite.visible = false
					$placer/pickUp.visible = false
					$placer/openBook.visible = true
					$placer/pickUpOpen.visible = true
					open = true
			time = false
			$hysterese.start()

func changePage() -> void: # changes the page TODO
	pLable.text = str(page + 1)
	lex.text = "lex" + str(page)
	back.visible = true
	next.visible = true
	$placer/openBook/edge/flamel5.visible = false
	$placer/openBook/edge/neighborhood.visible = false
	match page:
		0: 
			back.visible = false
			$placer/openBook/edge/flamel5.visible = true
		1:
			$placer/openBook/edge/neighborhood.visible = true
		6: next.visible = false
		_: pass

func _on_back_pressed() -> void: # last page
	if page > 0:
		page -= 1
		changePage()
	else:
		print("first page")


func _on_next_pressed() -> void: # next page
	if page < 6:
		page += 1
		changePage()
	else:
		print("last page")


func _on_hysterese_timeout() -> void: # prevents flapping
	time = true
