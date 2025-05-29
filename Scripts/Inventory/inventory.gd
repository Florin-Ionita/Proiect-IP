#extends Control
#var template_inv_slot = preload("res://Scenes/Templates/InventorySlot.tscn")
#@onready var gridcontainer = $NinePatchRect/MarginContainer/VBoxContainer/GridContainer
#
#func _ready() -> void:
	#print("=== Setting up inventory ===")
	#
	## Set the MAIN CONTROL to ignore as well - this is key!
	#mouse_filter = Control.MOUSE_FILTER_IGNORE
	#
	## Set ALL parent containers to ignore mouse events
	#$NinePatchRect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	#$NinePatchRect/MarginContainer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	#$NinePatchRect/MarginContainer/VBoxContainer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	#gridcontainer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	#
	#for i in range(3):  # Test with 3 slots
		#var inv_slot_new = template_inv_slot.instantiate()
		#inv_slot_new.set_slot_index(i)
		#gridcontainer.add_child(inv_slot_new)
#
## Remove the _input function since main control should ignore input
## Remove the _can_drop_data function too
