extends Node

var item_data = {}

func _ready() -> void:
	var item_data_file = FileAccess.open("res://Resources/piece_data.json", FileAccess.READ)
	if item_data_file:
		var content = item_data_file.get_as_text()
		item_data = JSON.parse_string(content)
		print(item_data)
		item_data_file.close()
	else: 
		print("n-a mers jsonu sa fie uploadat")
	
