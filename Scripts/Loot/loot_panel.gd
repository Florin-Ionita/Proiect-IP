extends PanelContainer

@onready var grid = $LootGrid
var loot_item_scene = preload("res://Scenes/Loot/loot_item.tscn")

func _ready():
	var items_to_display = [
		{ "id": 101, "texture": load("res://Assets/Rarities/Common.png") },
		{ "id": 102, "texture": load("res://Assets/Rarities/Rare.png") },
		{ "id": 103, "texture": load("res://Assets/Rarities/Epic.png") }
	]

	for item in items_to_display:
		var loot_item = load("res://Scenes/Loot/loot_item.tscn").instantiate()
		grid.add_child(loot_item)
		#loot_item.set_item(item.texture, item)
		
