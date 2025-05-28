extends Node2D

func _on_cronus_pressed() -> void:
	Shared.selected_character = "cronus"
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
	


func _on_hephaestus_pressed() -> void:
	Shared.selected_character = "hephaestus"
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
	

func _on_precognition_pressed() -> void:
	Shared.selected_character = "precognition"
	get_tree().change_scene_to_file("res://Scenes/game.tscn")


func _on_wisper_pressed() -> void:
	Shared.selected_character = "wisper"
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
