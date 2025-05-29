extends Node2D

func _on_cronus_pressed() -> void:
	CharacterShared.selected_character = "cronus"
	CharacterShared.active_ability = "Slow Down"
	CharacterShared.aa_cooldown = 30.0
	get_tree().change_scene_to_file("res://Scenes/game.tscn")

func _on_hephaestus_pressed() -> void:
	CharacterShared.selected_character = "hephaestus"
	CharacterShared.active_ability = "Skip"
	CharacterShared.aa_cooldown = 10.0
	get_tree().change_scene_to_file("res://Scenes/game.tscn")

func _on_precognition_pressed() -> void:
	CharacterShared.selected_character = "precognition"
	CharacterShared.active_ability = "Reroll"
	CharacterShared.aa_cooldown = 10.
	get_tree().change_scene_to_file("res://Scenes/game.tscn")

func _on_wisper_pressed() -> void:
	CharacterShared.selected_character = "wisper"
	CharacterShared.active_ability = "Reverse Time"
	CharacterShared.aa_cooldown = 10.0
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
