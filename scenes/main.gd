extends Control

@onready
var app_grid_container := $VBoxContainer/ScrollContainer/AppGridContainer
@onready
var app_card := $VBoxContainer/ScrollContainer/AppGridContainer/AppCard
@onready
var fileDialogue = $FileDialog

var file_path : String = ""
var apps : Array = []

func _ready():
	load_app_data()
	create_initial_cards()

func create_initial_cards():
	var initial_apps = apps
	for app in initial_apps:
		create_app_card(app.get("path"), app.get("name"))

func save_app_data():
	var save_data = FileAccess.open("user://appdata.save", FileAccess.WRITE)
	var json_string = JSON.stringify(apps)
	save_data.store_line(json_string)

func load_app_data():
	if not FileAccess.file_exists("user://appdata.save"):
		return # Error! We don't have a save to load.
	var saved_data = FileAccess.open("user://appdata.save", FileAccess.READ)
	
	while saved_data.get_position() < saved_data.get_length():
		var json_string = saved_data.get_line()

		# Creates the helper class to interact with JSON
		var json = JSON.new()

		# Check if there is any error while parsing the JSON string, skip in case of failure
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		# Get the data from the JSON object
		var app_data = json.get_data()
		print("app_data", app_data)
		apps = app_data

func create_app_card(path: String, app_name : String):
	var new_card = app_card.get_node(".").duplicate()
	new_card.path = path
	var app_name_label = new_card.get_child(2)
	app_name_label.text = app_name
	new_card.visible = true
	app_grid_container.add_child(new_card)
#	apps.append(app_info)

func _on_add_pressed():
	fileDialogue.popup_centered()

func _on_file_dialog_file_selected(path):
	# Getting app information
	var app_path_list = path.split("/") 
	var app_name = app_path_list[-1].split(".exe")[0]
	var app_info = {
		"path": path,
		"name": app_name
	}
	apps.append(app_info)
	save_app_data()
	create_app_card(path, app_name)
	
