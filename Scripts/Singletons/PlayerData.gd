extends Node

var inv_data = {}

func _ready() -> void:
	var inv_data_file = FileAccess.open("res://Resources/inv_data_file.json", FileAccess.READ)
	if inv_data_file:
		var content = inv_data_file.get_as_text()
		inv_data = JSON.parse_string(content)
		print(inv_data)
		inv_data_file.close()
	else: 
		print("n-a mers jsonu sa fie uploadat pt inventar")
	
