extends Node2D

@export var detail: int = 1
@onready var parent: Button = get_parent()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$detail.texture = load("res://assets/textures/UI-elements/MenuButton/menubtn_opt" + str(detail) + ".tres")
	parent.resized.connect(lReady)
	

func lReady() -> void:
	position.y = int(parent.size.y / 2)
	position.x = parent.size.x - 24
	
	if parent.size.y == 81:
		pass
	else:
		var h: int = parent.size.y - 30
		h = h - 34
		var hh: int = int(h/2)
		if 2*hh == h:
			$piped.scale.y = hh
			$pipeu.scale.y = hh
		else:
			$piped.scale.y = hh + 1
			$pipeu.scale.y = hh
