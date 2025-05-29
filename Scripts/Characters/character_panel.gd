extends Panel

@onready var texture_rect = $TextureRect
@onready var character_label = $Label
# Preload the textures (you can also use load() dynamically if needed)
var character_textures = {
	"cronus": preload("res://Assets/characters/Cronus.png"),
	"hephaestus": preload("res://Assets/characters/Hephaestus.png"),
	"precognition": preload("res://Assets/characters/Precognition.png"),
	"wisper": preload("res://Assets/characters/Wisper.png")
}

func update_character_image(character_name: String) -> void:
	if character_textures.has(character_name):
		texture_rect.texture = character_textures[character_name]
		character_label.text = character_name.capitalize()
	else:
		texture_rect.texture = null
		character_label.text = "Unknown"
		
func _ready():
	var selected = CharacterShared.selected_character
	print("Selected character is: ", selected)
	if selected != null and selected != "":
		update_character_image(selected)
	else:
		character_label.text = "None selected"
