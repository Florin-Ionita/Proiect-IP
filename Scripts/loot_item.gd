extends Panel
@onready var icon = $ItemIcon
var item_data = null

func set_item(texture: CompressedTexture2D, data):
	if icon:
		print("Setting texture:", texture)
		icon.texture = texture as Texture2D
		item_data = data
		# Pass the data to the icon
		icon.item_data = data
