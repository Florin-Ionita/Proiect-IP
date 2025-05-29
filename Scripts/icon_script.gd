extends TextureRect

var item_data = null

func _ready():
	mouse_filter = Control.MOUSE_FILTER_STOP
	print("ItemIcon ready")

func _gui_input(event):
	if event is InputEventMouseButton:
		print("Mouse button:", event.button_index, "pressed:", event.pressed)
	elif event is InputEventMouseMotion and event.button_mask & MOUSE_BUTTON_MASK_LEFT:
		print("Dragging motion detected - get_drag_data should be called next!")

# Try both versions of the function name
func get_drag_data(position):
	print("=== get_drag_data CALLED ===")
	var preview = TextureRect.new()
	preview.texture = texture
	preview.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	preview.custom_minimum_size = Vector2(64, 64)
	set_drag_preview(preview)
	return {"item_data": item_data, "texture": texture}

func _get_drag_data(position):
	print("=== _get_drag_data CALLED ===")
	var preview = TextureRect.new()
	preview.texture = texture  
	preview.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	preview.custom_minimum_size = Vector2(64, 64)
	set_drag_preview(preview)
	return {"item_data": item_data, "texture": texture}
