extends MarginContainer


@onready var pLable: Label = $pageLable
@onready var lex: RichTextLabel = $lexText
@onready var back: TextureButton = $back
@onready var next: TextureButton = $next

func changePage() -> void: # changes the page
	pLable.text = str(globalVariables.lexPage + 1)
	lex.text = tr("lex" + str(globalVariables.lexPage))
	back.visible = true
	next.visible = true
	$flamel5.visible = false
	$neighborhood.visible = false
	$hint.visible = false
	$ingredients.visible = false
	match globalVariables.lexPage:
		0: 
			back.visible = false
			$flamel5.visible = true
		2:
			$ingredients.visible = true
		4:
			$neighborhood.visible = true
		5:
			$hint.visible = true
		6: next.visible = false
		_: pass

func _on_back_pressed() -> void: # last page
	globalVariables.lexPage -= 1
	changePage()


func _on_next_pressed() -> void: # next page
	globalVariables.lexPage += 1
	changePage()

