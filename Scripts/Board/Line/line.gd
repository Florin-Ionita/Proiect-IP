extends Node

class_name Line

var blocks: Array;

func _ready() -> void:
	blocks = []
	for i in range(BoardShared.block_length):
		blocks.append(null)

func add_block_at(pos: int, block: Area2D):
	block.reparent(self)
	
	if pos >= 0 and pos < blocks.size():
		blocks[pos] = block
	else:
		push_error("Position out of bounds!")

func is_full():
	return BoardShared.block_length == get_child_count()

func empty():
	for i in range(blocks.size()):
		if blocks[i]:
			remove_child(blocks[i])
			blocks[i].queue_free()
			blocks[i] = null
