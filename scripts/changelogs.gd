extends TextureRect

var build: String = "0.02"
var adds: Dictionary = {
	"0.01" = "
initial relese",
	"0.02" = "
Fullscreen (F11)
Settings persistence
Movement limits
Changelogs",
}
var updates: Dictionary = {
	"0.01" = "
initial relese",
	"0.02" = "
Many Tutorial messages
Tutorial message presentation",
}
var fixes: Dictionary = {
	"0.01" = "
initial relese",
	"0.02" = "
Button detail placement
Bugs concerning Tutorials
Bugs concerning the Tools",
}
@onready var add: RichTextLabel = $edge/box/changebox/adds
@onready var update: RichTextLabel = $edge/box/changebox/updates
@onready var fixe: RichTextLabel = $edge/box/changebox/fixes

func _ready() -> void:
	updateText()


func updateText() -> void:
	add.text = adds[build].right(-1)
	add.custom_minimum_size = Vector2i(210, add.get_content_height())
	update.text = updates[build].right(-1)
	update.custom_minimum_size = Vector2i(update.get_content_width(), update.get_content_height())
	fixe.text = fixes[build].right(-1)
	fixe.custom_minimum_size = Vector2i(fixe.get_content_width(), fixe.get_content_height())

func changeBuild(Build: String) -> void:
	build = Build
	updateText()
