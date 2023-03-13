extends Control

@onready
var fileDialogue = $FileDialog

var file_path : String = ""
# Called when the node enters the scene tree for the first time.
func _ready():
	DisplayServer.window_set_min_size(Vector2i(1100, 600))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_button_pressed():
	fileDialogue.show()


func _on_file_dialog_file_selected(path):
	print(path)
	file_path = path


func _on_button_2_pressed():
	OS.execute(file_path, [])
	print(file_path)
