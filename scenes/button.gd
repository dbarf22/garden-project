extends Button

@onready var text_box: CanvasLayer = $"../../../.."
@onready var text_edit: TextEdit = $"../../TextEdit"

var xCoord: int
var yCoord: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func handle_interact(x:int, y:int):
	text_box.show();
	xCoord = x
	yCoord = y

func _on_pressed():
	var message: String = text_edit.get_text()
	self.disabled = true
	await HttpRequestManager.send_message(message,xCoord,yCoord,1)
	if HttpRequestManager.RESULT_SUCCESS != 0: 
		print("Error.")
		# todo: error message
	self.disabled = false
	text_box.hide();
