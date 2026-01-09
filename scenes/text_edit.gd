extends TextEdit

const MAX_LENGTH = 750
var currentText = ""
@onready var label_2: Label = $"../Label2"
@onready var button: Button = $"../HBoxContainer/Button"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	currentText = get_text()
	label_2.text = str(0,"/",MAX_LENGTH)
	button.disabled = true

func _on_text_changed() -> void:
	var newText = get_text()
	if newText.length() > MAX_LENGTH:
		set_text(currentText)
		set_caret_column(MAX_LENGTH)
	else:
		currentText = newText
		var textCount = str(newText.length(), "/", MAX_LENGTH)
		if newText.length() == 0:
			button.disabled = true
		else:
			button.disabled = false
		label_2.text = textCount
		
		
