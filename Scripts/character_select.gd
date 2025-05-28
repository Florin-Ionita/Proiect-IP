extends Node2D

func _on_cronus_pressed() -> void:
	Shared.selected_character = "cronus"
	Shared.active_ability = "Slow Down"
	Shared.aa_cooldown = 30.0
	get_tree().change_scene_to_file("res://Scenes/game.tscn")

func _on_hephaestus_pressed() -> void:
	Shared.selected_character = "hephaestus"
	Shared.active_ability = "Skip"
	Shared.aa_cooldown = 10.0
	get_tree().change_scene_to_file("res://Scenes/game.tscn")

func _on_precognition_pressed() -> void:
	Shared.selected_character = "precognition"
	Shared.active_ability = "Reroll"
	Shared.aa_cooldown = 10.
	get_tree().change_scene_to_file("res://Scenes/game.tscn")

func _on_wisper_pressed() -> void:
	Shared.selected_character = "wisper"
	Shared.active_ability = "Reverse Time"
	Shared.aa_cooldown = 10.0
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
