extends TextEdit

const MAX_LENGTH = 10
var currentText = ""
@onready var label_2: Label = $"../Label2"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	currentText = get_text()
	label_2.text = str(0,"/",MAX_LENGTH)

func _on_text_changed() -> void:
	var newText = get_text()
	if newText.length() > MAX_LENGTH:
		set_text(currentText)
		set_caret_column(MAX_LENGTH)
	else:
		currentText = newText
		var textCount = str(newText.length(), "/", MAX_LENGTH)
		label_2.text = textCount
