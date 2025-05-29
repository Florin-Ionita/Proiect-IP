extends Panel

@onready var icon: TextureRect = $Icon
var slot_index: int = -1
var item_data = null

func _ready():
	mouse_filter = Control.MOUSE_FILTER_STOP
	print("Slot", slot_index, "ready. Icon found:", icon != null)
	if icon:
		print("Icon type:", icon.get_class())

func set_slot_index(index: int) -> void:
	slot_index = index

func can_drop_data(position: Vector2, data: Variant) -> bool:
	print("=== can_drop_data SLOT", slot_index, "===")
	if typeof(data) != TYPE_DICTIONARY:
		print("Data is not a dictionary!")
		return false
	if not data.has("texture"):
		print("Missing texture in data!")
		return false
	return true

func drop_data(position: Vector2, data: Dictionary) -> void:
	print("=== drop_data SLOT", slot_index, " CALLED ===")

	if icon == null:
		print("ERROR: Icon node is null!")
		return

	if not data.has("texture"):
		print("ERROR: Data missing 'texture' key!")
		return

	icon.texture = data["texture"]
	modulate = Color(0.8, 1.0, 0.8)  # Slight green tint to show drop success

	if data.has("item_data"):
		item_data = data["item_data"]
		print("Item data set:", item_data)
